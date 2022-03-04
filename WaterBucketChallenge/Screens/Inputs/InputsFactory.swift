//
//  InputsFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

final class InputsFactory: ViewControllerFactory {
    static func build(_: Void) -> InputsViewController {
        let presenter = InputsPresenter()
        let interactor = InputsInteractor(presenter: presenter)
        let router = InputsRouter()
        let viewController = InputsViewController(interactor: interactor, router: router)
        presenter.viewController = viewController
        router.viewController = viewController
        return viewController
    }
}
