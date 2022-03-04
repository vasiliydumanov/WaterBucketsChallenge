//
//  SolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

protocol SolutionBusinessLogic: AnyObject {
    func requestSolution()
}

final class SolutionInteractor: SolutionBusinessLogic {
    private let solution: Solution
    private let presenter: SolutionPresentationLogic
    
    init(
        inputs: Solution,
        presenter: SolutionPresentationLogic
    ) {
        self.solution = inputs
        self.presenter = presenter
    }
}

// MARK: - SolutionBusinessLogic

extension SolutionInteractor {
    func requestSolution() {
        presenter.presentSolution(.init(solution: solution))
    }
}
