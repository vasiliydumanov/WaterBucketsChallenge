//
//  AnimatedSolutionPresenter.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

protocol AnimatedSolutionPresentationLogic: AnyObject {
}

final class AnimatedSolutionPresenter: AnimatedSolutionPresentationLogic {
    weak var viewController: AnimatedSolutionDisplayLogic?
    
    // MARK: - AnimatedSolutionPresentationLogic
}
