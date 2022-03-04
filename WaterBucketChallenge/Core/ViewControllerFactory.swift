//
//  ViewControllerFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 03.03.2022.
//

import UIKit

protocol ViewControllerFactory: AnyObject {
    associatedtype Context
    associatedtype ViewController: UIViewController
    
    static func build(_ context: Context) -> ViewController
}

extension ViewControllerFactory where Context == Void {
    static func build() -> ViewController {
        build(())
    }
}
