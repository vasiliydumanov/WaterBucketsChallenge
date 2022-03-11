//
//  InputsRouter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import UIKit

enum InputsRoute {
    case solution(SolutionWithInputs)
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
        case .solution(let solutionWithInputs):
            let solutionViewController = SolutionFactory.build(solutionWithInputs)
            viewController?.navigationController?.pushViewController(solutionViewController, animated: true)
        }
    }
}



