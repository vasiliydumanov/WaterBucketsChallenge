//
//  AnimatedSolutionViewController.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 08.03.2022.
//

import UIKit

protocol AnimatedSolutionDisplayLogic: AnyObject {
}

final class AnimatedSolutionViewController: UIViewController, AnimatedSolutionDisplayLogic {
    // MARK: - Properties
    
    private let interactor: AnimatedSolutionBusinessLogic
    
    // MARK: - Lifecycle
    
    init(interactor: AnimatedSolutionBusinessLogic) {
        self.interactor = interactor
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - AnimatedSolutionDisplayLogic
}
