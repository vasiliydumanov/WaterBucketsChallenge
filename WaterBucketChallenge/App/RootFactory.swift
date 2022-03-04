//
//  RootFactory.swift
//  WaterBucketChallenge
//
//  Created by Vasiliy Dumanov on 04.03.2022.
//

import UIKit

final class RootFactory: ViewControllerFactory {
    static func build(_:Void) -> UINavigationController {
        UINavigationController(rootViewController: InputsFactory.build())
    }
}
