//
//  TableSolutionFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

final class TableSolutionFactory: ViewControllerFactory {
    static func build(_ solution: Solution) -> TableSolutionViewController {
        let presenter = TableSolutionPresenter()
        let interactor = TableSolutionInteractor(solution: solution, presenter: presenter)
        let viewController = TableSolutionViewController(interactor: interactor)
        presenter.viewController = viewController
        return viewController
    }
}
