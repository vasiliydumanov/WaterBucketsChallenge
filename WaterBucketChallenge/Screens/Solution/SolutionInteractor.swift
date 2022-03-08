//
//  SolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol SolutionBusinessLogic: AnyObject {
    func requestContent()
    func requestSelectedTab(_ request: SolutionDataFlow.SelectedTab.Request)
}

final class SolutionInteractor: SolutionBusinessLogic {
    private let solution: Solution
    private let presenter: SolutionPresentationLogic
    
    init(solution: Solution, presenter: SolutionPresentationLogic) {
        self.solution = solution
        self.presenter = presenter
    }
    
    // MARK: - SolutionBusinessLogic

    func requestContent() {
        presenter.presentContent(.init(solution: solution))
    }
    
    func requestSelectedTab(_ request: SolutionDataFlow.SelectedTab.Request) {
        presenter.presentSelectedTab(.init(solution: solution, selectedTabIndex: request.selectedTabIndex))
    }
}
