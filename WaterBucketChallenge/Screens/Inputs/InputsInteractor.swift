//
//  InputsInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

protocol InputsBusinessLogic: AnyObject {
    func processUpdatedInputs(_ request: InputsDataFlow.Update.Request)
    func solve(_ request: InputsDataFlow.Solve.Request)
}

final class InputsInteractor: InputsBusinessLogic {
    private let presenter: InputsPresentationLogic
    private let solver: SolvesWaterBucketChallenge
    
    init(
        presenter: InputsPresentationLogic,
        solver: SolvesWaterBucketChallenge = WaterBucketChallengeSolver()
    ) {
        self.presenter = presenter
        self.solver = solver
    }
}

// MARK: - InputsBusinessLogic

extension InputsInteractor {
    func processUpdatedInputs(_ request: InputsDataFlow.Update.Request) {
        let isReadyToSolve = [request.x, request.y, request.z]
            .allSatisfy { !($0 ?? "").isEmpty }
        presenter.presentReadyToSolve(.init(isReadyToSolve: isReadyToSolve))
    }
    
    func solve(_ request: InputsDataFlow.Solve.Request) {
        guard
            let x = request.rawInputs.x.flatMap(UInt.init),
            let y = request.rawInputs.y.flatMap(UInt.init),
            let z = request.rawInputs.z.flatMap(UInt.init)
        else { return }
         
        let inputs = Inputs(x: x, y: y, z: z)
        let solution = solver.solve(for: inputs)
        
        presenter.presentSolution(.init(inputs: inputs, solution: solution))
    }
}
