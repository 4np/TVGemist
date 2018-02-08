//
//  UIViewController+fromStoryboard.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit

extension UIViewController {
    static func fromStoryboard() -> Self {
        func fromStoryboard<T: UIViewController>(_ viewControllerType: T.Type) -> T {
            let storyboard = UIStoryboard(name: String(describing: T.self), bundle: nil)
            //swiftlint:disable:next force_cast
            return storyboard.instantiateInitialViewController() as! T
        }
        
        return fromStoryboard(self)
    }
}
