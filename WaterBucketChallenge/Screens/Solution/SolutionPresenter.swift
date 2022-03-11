//
//  SolutionPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol SolutionPresentationLogic: AnyObject {
    func presentTitle(_ response: SolutionDataFlow.Title.Response)
    func presentContent(_ response: SolutionDataFlow.Content.Response)
    func presentSelectedTab(_ response: SolutionDataFlow.SelectedTab.Response)
}

final class SolutionPresenter: SolutionPresentationLogic {
    weak var viewController: SolutionDisplayLogic?
    
    // MARK: - SolutionPresentationLogic
    
    func presentTitle(_ response: SolutionDataFlow.Title.Response) {
        let title = "X = \(response.inputs.x), Y = \(response.inputs.y), Z = \(response.inputs.z)"
        viewController?.showTitle(.init(title: title))
    }
    
    func presentContent(_ response: SolutionDataFlow.Content.Response) {
        viewController?.showContent(
            .init(
                solutionWithInputs: response.solutionWithInputs,
                tabNames: [
                    L10n.Screen.Solution.Tabs.animated,
                    L10n.Screen.Solution.Tabs.table
                ],
                selectedTab: .animated,
                selectedTabIndex: 0
            )
        )
    }
    
    func presentSelectedTab(_ response: SolutionDataFlow.SelectedTab.Response) {
        guard let selectedTab = SolutionRoute.Tab.init(rawValue: response.selectedTabIndex) else { return }
        viewController?.showSelectedTab(
            .init(
                solutionWithInputs: response.solutionWithInputs,
                selectedTab: selectedTab
            )
        )
    }
}
