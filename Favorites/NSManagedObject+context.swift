//
//  NSManagedObject+context.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 24/07/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import UIKit
import CoreData

extension NSManagedObject {
    internal func getContext() -> NSManagedObjectContext {
        //swiftlint:disable:next force_cast
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
}
