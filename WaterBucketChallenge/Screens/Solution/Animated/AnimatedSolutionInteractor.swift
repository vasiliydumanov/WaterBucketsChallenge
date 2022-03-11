//
//  AnimatedSolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol AnimatedSolutionBusinessLogic: AnyObject {
    func requestBucketsNextState()
    func requestResetBuckets()
}

final class AnimatedSolutionInteractor: AnimatedSolutionBusinessLogic {
    private let solutionWithInputs: SolutionWithInputs
    private let stepsIterator: IteratesSolutionSteps
    private let presenter: AnimatedSolutionPresentationLogic
    
    init(
        solutionWithInputs: SolutionWithInputs,
        presenter: AnimatedSolutionPresentationLogic,
        stepsIterator: IteratesSolutionSteps = SolutionStepsIterator()
    ) {
        self.solutionWithInputs = solutionWithInputs
        self.stepsIterator = stepsIterator
        self.presenter = presenter
        stepsIterator.steps = solutionWithInputs.solution.steps
    }
    
    // MARK: - AnimatedSolutionBusinessLogic
    
    func requestBucketsNextState() {
        presenter.presentBuckets(
            .init(
                solutionWithInputs: solutionWithInputs,
                iteratorElement: stepsIterator.next()
            )
        )
    }
    
    func requestResetBuckets() {
        stepsIterator.reset()
        requestBucketsNextState()
    }
}
