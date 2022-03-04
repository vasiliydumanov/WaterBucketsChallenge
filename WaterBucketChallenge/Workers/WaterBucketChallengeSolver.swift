//
//  RiddleSolver.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

/// An entity that describes a single action performed on buckets and its result
struct SolutionStep: Equatable {
    enum Action: Equatable {
        case fill(Bucket)
        case empty(Bucket)
        case transfer(TransferDirection)
    }
    
    enum TransferDirection: Equatable {
        case fromXToY
        case fromYToX
    }
    
    /// Filled volume in X bucket after action has been performed
    let xFilledVolume: UInt
    /// Filled volume in Y bucket after action has been performed
    let yFilledVolume: UInt
    let action: Action
}

struct Solution: Equatable {
    let steps: [SolutionStep]
    let xContainsTargetVolume: Bool
    let yContainsTargetVolume: Bool
}

enum SolutionError: Error {
    case zeroInputs
    case bucketsTooSmall
    case unsolvableInputs
}

protocol SolvesWaterBucketChallenge: AnyObject {
    func solve(for inputs: Inputs) -> Result<Solution, SolutionError>
}

final class WaterBucketChallengeSolver: SolvesWaterBucketChallenge {
    func solve(for inputs: Inputs) -> Result<Solution, SolutionError> {
        // All inputs should be non-zeroes
        guard
            inputs.x != 0 && inputs.y != 0 && inputs.z != 0
        else { return .failure(SolutionError.zeroInputs) }
        // At least one bucket should have sufficient volume for Z
        guard
            inputs.x >= inputs.z || inputs.y >= inputs.z
        else { return .failure(SolutionError.bucketsTooSmall) }
        // Z should be achievable with empty / fill / transfer operations
        guard
            inputs.z.isMultiple(of: gcd(inputs.x, inputs.y))
        else { return .failure(SolutionError.unsolvableInputs) }

        let initialBucketsState = BucketsState(
            x: BucketState(totalVolume: inputs.x, filledVolume: 0),
            y: BucketState(totalVolume: inputs.y, filledVolume: 0)
        )
        
        // Solve using one-directional X -> Y transfer
        let firstSolution = findSolution(for: initialBucketsState, transferDirection: .fromXToY, z: inputs.z)
        // Solve using one-directional Y -> X transfer
        let secondSolution = findSolution(for: initialBucketsState, transferDirection: .fromYToX, z: inputs.z)
        // Choose a solution with the least number of steps
        let optimalSolution = firstSolution.steps.count <= secondSolution.steps.count ? firstSolution : secondSolution
        
        return .success(optimalSolution)
    }
}

// MARK: - Solution Algorithm

private extension WaterBucketChallengeSolver {
    func gcd(_ a: UInt, _ b: UInt) -> UInt {
        let remainder = a % b
        guard remainder != 0 else { return b }
        return gcd(b, remainder)
    }
    
    func findSolution(
        for bucketsState: BucketsState,
        transferDirection: SolutionStep.TransferDirection,
        z: UInt
    ) -> Solution {
        var currentBucketsState = bucketsState
        var solutionSteps: [SolutionStep] = []
        
        /// Perform fill / empty / transfer operations untils one of the 2 buckets contains the target volume
        while currentBucketsState.x.filledVolume != z && currentBucketsState.y.filledVolume != z {
            let (stepAction, newBucketsState) = performStep(for: currentBucketsState, transferDirection: transferDirection)
            let step = SolutionStep(
                xFilledVolume: newBucketsState.x.filledVolume,
                yFilledVolume: newBucketsState.y.filledVolume,
                action: stepAction
            )
            solutionSteps.append(step)
            currentBucketsState = newBucketsState
        }
        
        return Solution(
            steps: solutionSteps,
            xContainsTargetVolume: currentBucketsState.x.filledVolume == z,
            yContainsTargetVolume: currentBucketsState.y.filledVolume == z
        )
    }

    func performStep(
        for bucketsState: BucketsState,
        transferDirection: SolutionStep.TransferDirection
    ) -> (stepAction: SolutionStep.Action, newBucketsState: BucketsState) {
        let sourceBucket = bucketsState.source(for: transferDirection)
        let targetBucket = bucketsState.target(for: transferDirection)
        
        // If target bucket is full, empty it
        if targetBucket.isFull {
            return (
                .empty(.target(for: transferDirection)),
                BucketsState(
                    source: sourceBucket,
                    target: targetBucket.emptied(),
                    transferDirection: transferDirection
                )
            )
        }
        
        // If source bucket is empty, fill it
        if sourceBucket.isEmpty {
            return (
                .fill(.source(for: transferDirection)),
                BucketsState(
                    source: sourceBucket.filled(),
                    target: targetBucket,
                    transferDirection: transferDirection
                )
            )
        }
        
        // Otherwise pour from source to target until target is full or source is empty
        let targetRemainingVolume = targetBucket.totalVolume - targetBucket.filledVolume
        let targetVolumeAfterTransfer = min(targetBucket.filledVolume + sourceBucket.filledVolume, targetBucket.totalVolume)
        let sourceVolumeAfterTransfer = UInt(max(Int(sourceBucket.filledVolume) - Int(targetRemainingVolume), 0))
        
        return (
            .transfer(transferDirection),
            BucketsState(
                source: sourceBucket.with(filledVolume: sourceVolumeAfterTransfer),
                target: targetBucket.with(filledVolume: targetVolumeAfterTransfer),
                transferDirection: transferDirection
            )
        )
    }
}

// MARK: - Helper Types

private extension WaterBucketChallengeSolver {
    struct BucketState {
        let totalVolume: UInt
        let filledVolume: UInt
        
        var isEmpty: Bool {
            filledVolume == 0
        }
        
        var isFull: Bool {
            totalVolume == filledVolume
        }
        
        func emptied() -> BucketState {
            with(filledVolume: 0)
        }
        
        func filled() -> BucketState {
            with(filledVolume: totalVolume)
        }
        
        func with(filledVolume: UInt) -> BucketState {
            .init(totalVolume: totalVolume, filledVolume: filledVolume)
        }
    }

    struct BucketsState {
        let x: BucketState
        let y: BucketState
        
        init(x: BucketState, y: BucketState) {
            self.x = x
            self.y = y
        }

        init(source: BucketState, target: BucketState, transferDirection: SolutionStep.TransferDirection) {
            switch transferDirection {
            case .fromXToY:
                self.x = source
                self.y = target
            case .fromYToX:
                self.x = target
                self.y = source
            }
        }
                
        func source(for transferDirection: SolutionStep.TransferDirection) -> BucketState {
            switch transferDirection {
            case .fromXToY:
                return x
            case .fromYToX:
                return y
            }
        }
        
        func target(for transferDirection: SolutionStep.TransferDirection) -> BucketState {
            switch transferDirection {
            case .fromXToY:
                return y
            case .fromYToX:
                return x
            }
        }
    }
}

private extension Bucket {
    static func source(for transferDirection: SolutionStep.TransferDirection) -> Bucket {
        switch transferDirection {
        case .fromXToY:
            return .x
        case .fromYToX:
            return .y
        }
    }
    
    static func target(for transferDirection: SolutionStep.TransferDirection) -> Bucket {
        switch transferDirection {
        case .fromXToY:
            return .y
        case .fromYToX:
            return .x
        }
    }
}
