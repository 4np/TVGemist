//
//  UIImage+scaling.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 29/10/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit

// MARK: Alpha
extension UIImage {
    /// Returns whether the image contains an alpha component.
    public var containsAlphaComponent: Bool {
        let alphaInfo = cgImage?.alphaInfo
        
        return (
            alphaInfo == .first ||
                alphaInfo == .last ||
                alphaInfo == .premultipliedFirst ||
                alphaInfo == .premultipliedLast
        )
    }
    
    /// Returns whether the image is opaque.
    public var isOpaque: Bool { return !containsAlphaComponent }
}

// MARK: Scaling
extension UIImage {
    /// Returns a new version of the image scaled to the specified size.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func scaled(to size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: .zero, size: size))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fit within
    /// a specified size.
    ///
    /// The resulting image contains an alpha component used to pad the width or height with the necessary transparent
    /// pixels to fit the specified size. In high performance critical situations, this may not be the optimal approach.
    /// To maintain an opaque image, you could compute the `scaledSize` manually, then use the `af_imageScaledToSize`
    /// method in conjunction with a `.Center` content mode to achieve the same visual result.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func aspectScaled(toFit size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.width / self.size.width
        } else {
            resizeFactor = size.height / self.size.height
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
    
    /// Returns a new version of the image scaled from the center while maintaining the aspect ratio to fill a
    /// specified size. Any pixels that fall outside the specified size are clipped.
    ///
    /// - parameter size: The size to use when scaling the new image.
    ///
    /// - returns: A new image object.
    public func aspectScaled(toFill size: CGSize) -> UIImage {
        assert(size.width > 0 && size.height > 0, "You cannot safely scale an image to a zero width or height")
        
        let imageAspectRatio = self.size.width / self.size.height
        let canvasAspectRatio = size.width / size.height
        
        var resizeFactor: CGFloat
        
        if imageAspectRatio > canvasAspectRatio {
            resizeFactor = size.height / self.size.height
        } else {
            resizeFactor = size.width / self.size.width
        }
        
        let scaledSize = CGSize(width: self.size.width * resizeFactor, height: self.size.height * resizeFactor)
        let origin = CGPoint(x: (size.width - scaledSize.width) / 2.0, y: (size.height - scaledSize.height) / 2.0)
        
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        draw(in: CGRect(origin: origin, size: scaledSize))
        
        let scaledImage = UIGraphicsGetImageFromCurrentImageContext() ?? self
        UIGraphicsEndImageContext()
        
        return scaledImage
    }
}
