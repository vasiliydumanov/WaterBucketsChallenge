//
//  SolutionFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

final class SolutionFactory: ViewControllerFactory {
    static func build(_ solution: Solution) -> SolutionViewController {
        let presenter = SolutionPresenter()
        let interactor = SolutionInteractor(solution: solution, presenter: presenter)
        let router = SolutionRouter()
        let viewController = SolutionViewController(interactor: interactor, router: router)
        presenter.viewController = viewController
        router.viewController = viewController
        return viewController
    }
}
