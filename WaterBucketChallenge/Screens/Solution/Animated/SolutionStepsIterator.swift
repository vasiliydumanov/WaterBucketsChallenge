//
//  SolutionIterator.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 10.03.2022.
//

enum SolutionIteratorElement {
    case start
    case step(SolutionStep)
    case end
}

protocol IteratesSolutionSteps: AnyObject {
    var steps: [SolutionStep] { get set }
    func next() -> SolutionIteratorElement
    func reset()
}

final class SolutionStepsIterator: IteratesSolutionSteps {
    var steps: [SolutionStep] = []
    private var iterator: IndexingIterator<[SolutionStep]>?
    
    func next() -> SolutionIteratorElement {
        guard iterator != nil else {
            iterator = steps.makeIterator()
            return .start
        }
        return iterator?.next().map { .step($0) } ?? .end
    }
    
    func reset() {
        iterator = nil
    }
}
