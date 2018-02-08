//
//  UXImage.swift
//  NPOKitPackageDescription
//
//  Created by Jeroen Wesbeek on 06/02/2018.
//

import Foundation

#if os(iOS) || os(tvOS)
    import UIKit
    
    public typealias UXImage = UIImage
    
    extension UIImage {
        convenience init?(withName name: String) {
            self.init(named: name)
        }
    }
#endif

#if os(OSX)
    import Cocoa
    
    public typealias UXImage = NSImage
    
    extension NSImage {
        convenience init?(withName name: String) {
            self.init(named: NSImage.Name(name))
        }
    }
#endif
