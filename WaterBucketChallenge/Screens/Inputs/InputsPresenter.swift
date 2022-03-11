//
//  InputsPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

protocol InputsPresentationLogic: AnyObject {
    func presentReadyToSolve(_ response: InputsDataFlow.Update.Response)
    func presentSolution(_ response: InputsDataFlow.Solve.Response)
}

final class InputsPresenter: InputsPresentationLogic {
    weak var viewController: InputsDisplayLogic?
}

// MARK: - InputsPresentationLogic

extension InputsPresenter {
    func presentReadyToSolve(_ response: InputsDataFlow.Update.Response) {
        viewController?.updateSolveButtonState(.init(isSolveButtonEnabled: response.isReadyToSolve))
    }
    
    func presentSolution(_ response: InputsDataFlow.Solve.Response) {
        let viewModel: InputsDataFlow.Solve.ViewModel
        
        switch response.solution {
        case .success(let solution):
            viewModel = .solved(.init(inputs: response.inputs, solution: solution))
        case .failure(let error):
            let message: String = {
                switch error {
                case .zeroInputs:
                    return L10n.Solution.Error.zeroInputs
                case .bucketsTooSmall:
                    return L10n.Solution.Error.bucketsTooSmall
                case .unsolvableInputs:
                    return L10n.Solution.Error.unsolvableInputs
                }
            }()

            viewModel = .notSolvable(message: message)
        }
        
        viewController?.showSolution(viewModel)
    }
}
