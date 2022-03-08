//
//  SolutionPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol SolutionPresentationLogic: AnyObject {
    func presentContent(_ response: SolutionDataFlow.Content.Response)
    func presentSelectedTab(_ response: SolutionDataFlow.SelectedTab.Response)
}

final class SolutionPresenter: SolutionPresentationLogic {
    weak var viewController: SolutionDisplayLogic?
    
    // MARK: - SolutionPresentationLogic
    
    func presentContent(_ response: SolutionDataFlow.Content.Response) {
        viewController?.showContent(
            .init(
                solution: response.solution,
                tabNames: [
                    L10n.Screen.Solution.Tabs.table,
                    L10n.Screen.Solution.Tabs.animated
                ],
                selectedTab: .table,
                selectedTabIndex: 0
            )
        )
    }
    
    func presentSelectedTab(_ response: SolutionDataFlow.SelectedTab.Response) {
        guard let selectedTab = SolutionRoute.Tab.init(rawValue: response.selectedTabIndex) else { return }
        viewController?.showSelectedTab(.init(solution: response.solution, selectedTab: selectedTab))
    }
}
