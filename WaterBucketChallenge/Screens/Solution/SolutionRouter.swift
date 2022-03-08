//
//  SolutionRouter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

import UIKit

enum SolutionRoute {
    case tab(Tab, solution: Solution, tabsContainer: UIView)
    
    enum Tab: Int {
        case table
        case animated
    }
}

protocol SolutionRoutingLogic {
    func navigate(to route: SolutionRoute)
}

final class SolutionRouter {
    weak var viewController: SolutionViewController?
    
    private var tabContentViewControllers: [SolutionRoute.Tab: UIViewController] = [:]
    private var displayedTabContentViewController: UIViewController?
}

// MARK: - InputsRoutingLogic

extension SolutionRouter: SolutionRoutingLogic {
    func navigate(to route: SolutionRoute) {
        guard let viewController = viewController else { return }
        
        switch route {
        case let .tab(tab, solution, tabsContainer):
            displayedTabContentViewController?.willMove(toParent: nil)
            displayedTabContentViewController?.view.removeFromSuperview()
            displayedTabContentViewController?.removeFromParent()
            
            let tabContentViewController: UIViewController = tabContentViewControllers[tab, default: {
                switch tab {
                case .table:
                    return TableSolutionFactory.build(solution)
                case .animated:
                    return AnimatedSolutionFactory.build(solution)
                }
            }()]
            tabContentViewControllers[tab] = tabContentViewController
            
            viewController.addChild(tabContentViewController)
            tabsContainer.addSubview(tabContentViewController.view)
            tabContentViewController.view.snp.makeConstraints { make in
                make.edges.equalToSuperview()
            }
            tabContentViewController.didMove(toParent: viewController)
            displayedTabContentViewController = tabContentViewController
        }
    }
}

