//
//  WaterBucketsRiddleSolverTests.swift
//  WaterBucketChallengeTests
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import Nimble
import Quick

@testable import WaterBucketChallenge

final class WaterBucketChallengeSolverTests: QuickSpec {
    override func spec() {
        var solver: WaterBucketChallengeSolver!
        
        beforeEach {
            solver = .init()
        }
        
        describe(".solve") {
            context("when some inputs are 0") {
                it("should produce corresponding error") {
                    // when
                    let zeroXSolution = solver.solve(for: TestData.zeroXInputs)
                    let zeroYSolution = solver.solve(for: TestData.zeroYInputs)
                    let zeroZSolution = solver.solve(for: TestData.zeroZInputs)
                    // then
                    expect(zeroXSolution).to(equal(.failure(.zeroInputs)))
                    expect(zeroYSolution).to(equal(.failure(.zeroInputs)))
                    expect(zeroZSolution).to(equal(.failure(.zeroInputs)))
                }
            }
            
            context("when there is no bucket big enough for Z") {
                it("should produce corresponding error") {
                    // when
                    let smallBucketsSolution = solver.solve(for: TestData.smallBucketsInputs)
                    // then
                    expect(smallBucketsSolution).to(equal(.failure(.bucketsTooSmall)))
                }
            }
            
            context("when solvable") {
                it("should produce optimal solution") {
                    // when
                    let xContainsTargetVolumeSolution = solver.solve(for: TestData.SolvableCase.xContainsTargetVolume.inputs)
                    let yContainsTargetVolumeSolution = solver.solve(for: TestData.SolvableCase.yContainsTargetVolume.inputs)
                    // then
                    expect(xContainsTargetVolumeSolution).to(equal(
                        .success(TestData.SolvableCase.xContainsTargetVolume.solution)))
                    expect(yContainsTargetVolumeSolution).to(equal(
                        .success(TestData.SolvableCase.yContainsTargetVolume.solution)))
                }
            }
        }
    }
}

private extension WaterBucketChallengeSolverTests {
    enum TestData {
        struct SolvableCase {
            let inputs: Inputs
            let solution: Solution
            
            static let yContainsTargetVolume = SolvableCase(
                inputs: Inputs(x: 3, y: 5, z: 4),
                solution: Solution(
                    steps: [
                        .init(xFilledVolume: 0, yFilledVolume: 5, action: .fill(.y)),
                        .init(xFilledVolume: 3, yFilledVolume: 2, action: .transfer(.fromYToX)),
                        .init(xFilledVolume: 0, yFilledVolume: 2, action: .empty(.x)),
                        .init(xFilledVolume: 2, yFilledVolume: 0, action: .transfer(.fromYToX)),
                        .init(xFilledVolume: 2, yFilledVolume: 5, action: .fill(.y)),
                        .init(xFilledVolume: 3, yFilledVolume: 4, action: .transfer(.fromYToX))
                    ],
                    xContainsTargetVolume: false,
                    yContainsTargetVolume: true
                )
            )
            
            static let xContainsTargetVolume = SolvableCase(
                inputs: Inputs(x: 5, y: 3, z: 4),
                solution: Solution(
                    steps: [
                        .init(xFilledVolume: 5, yFilledVolume: 0, action: .fill(.x)),
                        .init(xFilledVolume: 2, yFilledVolume: 3, action: .transfer(.fromXToY)),
                        .init(xFilledVolume: 2, yFilledVolume: 0, action: .empty(.y)),
                        .init(xFilledVolume: 0, yFilledVolume: 2, action: .transfer(.fromXToY)),
                        .init(xFilledVolume: 5, yFilledVolume: 2, action: .fill(.x)),
                        .init(xFilledVolume: 4, yFilledVolume: 3, action: .transfer(.fromXToY))
                    ],
                    xContainsTargetVolume: true,
                    yContainsTargetVolume: false
                )
            )
        }
        
        static let zeroZInputs = Inputs(x: 3, y: 5, z: 0)
        static let zeroXInputs = Inputs(x: 0, y: 5, z: 3)
        static let zeroYInputs = Inputs(x: 5, y: 0, z: 3)
        static let smallBucketsInputs = Inputs(x: 3, y: 7, z: 10)
    }
}
