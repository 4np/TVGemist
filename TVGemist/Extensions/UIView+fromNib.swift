//
//  UIView+fromNib.swift
//  NPO
//
//  Created by Jeroen Wesbeek on 27/10/2017.
//  Copyright © 2017 Jeroen Wesbeek. All rights reserved.
//

import UIKit

extension UIView {
    class func fromNib<T: UIView>() -> T {
        //swiftlint:disable:next force_unwrapping force_cast
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
}
