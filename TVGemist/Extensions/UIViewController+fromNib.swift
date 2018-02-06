//
//  UIViewController+fromNib.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import UIKit

extension UIViewController {
    static func fromNib() -> Self {
        func fromNib<T: UIViewController>(_ viewControllerType: T.Type) -> T {
            return T.init(nibName: String(describing: T.self), bundle: nil)
        }
        
        return fromNib(self)
    }
}
