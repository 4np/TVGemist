//
//  String+i18n.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 30/06/2017.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation

extension String {
    func localized(withComment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: Bundle.main, value: "", comment: withComment)
    }
    
    static let okAlertAction = "ok".localized(withComment: "OK alert action")
}
