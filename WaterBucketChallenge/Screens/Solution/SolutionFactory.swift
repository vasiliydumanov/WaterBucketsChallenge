//
//  SolutionFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

final class SolutionFactory: ViewControllerFactory {
    static func build(_ solution: Solution) -> SolutionViewController {
        let presenter = SolutionPresenter()
        let interactor = SolutionInteractor(inputs: solution, presenter: presenter)
        let viewController = SolutionViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
