//
//  UIImage+faceAwareScaling.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 31/10/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import CoreImage

extension UIImage {
    public func faceAwareAspectScaled(toFill size: CGSize) -> UIImage? {
        // resize to the same width
        let scaledSize = CGSize(width: size.width, height: (size.width / self.size.width) * self.size.height)
        let scaledImage = self.scaled(to: scaledSize)

        // detect faces
        guard let facesRect = scaledImage.detectFaces() else {
            // no faces, scale the default way
            return scaledImage.aspectScaled(toFill: size)
        }

        // crop the image to prioritize the faces and make them float to the top
        let padding = (size.height - facesRect.height) / 5
        var faceY = facesRect.origin.y - padding
        faceY = (faceY < 0) ? 0 : faceY
        let cropRect = CGRect(x: 0, y: faceY, width: size.width, height: size.height)
        
        guard let croppedImage = scaledImage.cgImage?.cropping(to: cropRect) else {
            return scaledImage.aspectScaled(toFill: size)
        }

        return UIImage(cgImage: croppedImage)
    }
    
    private func render(rectangle: CGRect) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, isOpaque, 0.0)
        
        //swiftlint:disable:next force_unwrapping
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.saveGState()
        draw(at: CGPoint(x: 0, y: 0))
        ctx.setStrokeColor(UIColor.red.cgColor)
        ctx.stroke(rectangle)
        ctx.restoreGState()
        let img = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return img
    }
    
    private func detectFaces() -> CGRect? {
        guard let ciImage = CIImage(image: self) else { return nil }
        
        var minX: CGFloat = size.width
        var minY: CGFloat = size.height
        var maxX: CGFloat = 0
        var maxY: CGFloat = 0
        
        let transformScale = CGAffineTransform(scaleX: 1, y: -1)
        let transform = transformScale.translatedBy(x: 0, y: -size.height)
        
        // detect faces
        let accuracy = [CIDetectorAccuracy: CIDetectorAccuracyHigh]
        guard let faceDetector = CIDetector(ofType: CIDetectorTypeFace, context: nil, options: accuracy) else { return nil }
        let faces = faceDetector.features(in: ciImage)

        // make sure we have any faces
        guard faces.count > 0 else { return nil }

        // get the positions of these faces
        for face in faces {
            let faceRect = face.bounds.applying(transform)
            //DDLogDebug("face: \(face.bounds) -> \(faceRect)")

            minX = min(minX, faceRect.origin.x)
            maxX = max(maxX, faceRect.origin.x + faceRect.width)
            
            minY = min(minY, faceRect.origin.y)
            maxY = max(maxY, faceRect.origin.y + faceRect.height)
        }
        
        // return the min and maximum y for these faces
        return CGRect(x: minX, y: minY, width: maxX-minX, height: maxY-minY)
    }
}
