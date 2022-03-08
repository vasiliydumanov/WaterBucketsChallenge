//
//  TableSolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

protocol TableSolutionBusinessLogic: AnyObject {
    func requestSolution()
}

final class TableSolutionInteractor: TableSolutionBusinessLogic {
    private let solution: Solution
    private let presenter: TableSolutionPresentationLogic
    
    init(
        solution: Solution,
        presenter: TableSolutionPresentationLogic
    ) {
        self.solution = solution
        self.presenter = presenter
    }
}

// MARK: - TableSolutionBusinessLogic

extension TableSolutionInteractor {
    func requestSolution() {
        presenter.presentSolution(.init(solution: solution))
    }
}
