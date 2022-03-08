//
//  AnimatedSolutionInteractor.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol AnimatedSolutionBusinessLogic: AnyObject {
}

final class AnimatedSolutionInteractor: AnimatedSolutionBusinessLogic {
    private let solution: Solution
    private let presenter: AnimatedSolutionPresentationLogic
    
    init(
        solution: Solution,
        presenter: AnimatedSolutionPresentationLogic
    ) {
        self.solution = solution
        self.presenter = presenter
    }
    
    // MARK: - AnimatedSolutionBusinessLogic
}
