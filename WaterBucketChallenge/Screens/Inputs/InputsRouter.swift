//
//  InputsRouter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import UIKit

enum InputsRoute {
    case solution(Solution)
}

protocol InputsRoutingLogic {
    func navigate(to route: InputsRoute)
}

final class InputsRouter {
    weak var viewController: InputsViewController?
}

// MARK: - InputsRoutingLogic

extension InputsRouter: InputsRoutingLogic {
    func navigate(to route: InputsRoute) {
        switch route {
        case .solution(let solution):
            let solutionViewController = SolutionFactory.build(solution)
            viewController?.navigationController?.pushViewController(solutionViewController, animated: true)
        }
    }
}



