//
//  AnimatedSolutionFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

final class AnimatedSolutionFactory: ViewControllerFactory {
    static func build(_ solutionWithInputs: SolutionWithInputs) -> AnimatedSolutionViewController {
        let presenter = AnimatedSolutionPresenter()
        let interactor = AnimatedSolutionInteractor(
            solutionWithInputs: solutionWithInputs,
            presenter: presenter
        )
        let viewController = AnimatedSolutionViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}

