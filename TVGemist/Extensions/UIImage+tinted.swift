//
//  UIImage+tinted.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 08/02/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation
import UIKit

extension UIImage {
    /// Create a tinted image
    func tint(with color: UIColor) -> UIImage {
        UIGraphicsBeginImageContext(self.size)
        
        guard let context = UIGraphicsGetCurrentContext(), let cgImage = self.cgImage else { return self }
        
        // flip the image
        context.scaleBy(x: 1.0, y: -1.0)
        context.translateBy(x: 0.0, y: -size.height)
        
        // multiply blend mode
        context.setBlendMode(.multiply)
        
        let rect = CGRect(x: 0, y: 0, width: size.width, height: size.height)
        context.clip(to: rect, mask: cgImage)
        color.setFill()
        context.fill(rect)
        
        // create uiimage
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? self
    }
}
