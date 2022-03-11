//
//  SolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol SolutionBusinessLogic: AnyObject {
    func requestTitle()
    func requestContent()
    func requestSelectedTab(_ request: SolutionDataFlow.SelectedTab.Request)
}

final class SolutionInteractor: SolutionBusinessLogic {
    private let solutionWithInputs: SolutionWithInputs
    private let presenter: SolutionPresentationLogic
    
    init(solutionWithInputs: SolutionWithInputs, presenter: SolutionPresentationLogic) {
        self.solutionWithInputs = solutionWithInputs
        self.presenter = presenter
    }
    
    // MARK: - SolutionBusinessLogic
    
    func requestTitle() {
        presenter.presentTitle(.init(inputs: solutionWithInputs.inputs))
    }

    func requestContent() {
        presenter.presentContent(.init(solutionWithInputs: solutionWithInputs))
    }
    
    func requestSelectedTab(_ request: SolutionDataFlow.SelectedTab.Request) {
        presenter.presentSelectedTab(
            .init(
                solutionWithInputs: solutionWithInputs,
                selectedTabIndex: request.selectedTabIndex
            )
        )
    }
}
