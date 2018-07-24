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
    
    static let okAlertAction = "Ok".localized(withComment: "OK alert action")
    static let cancelAlertAction = "Cancel".localized(withComment: "Cancel alert action")
    
    // player
    static let continueWatchingTitleText = "Continue watching".localized(withComment: "Continue Watching alert title")
    static let continueWatchingMessageText = "You have already partially watched this episode. Would you like to continue where you left off, or do you want to start watching from the start?".localized(withComment: "Continue Watching alert message")
    static let continueWatchingFromActionText = "Continue watching from %@".localized(withComment: "Continue watching from hh:min:ss alert action")
    static let watchFromStartActionText = "Watch from the start".localized(withComment: "Watch from the start alert action")
    
    // duration
    static let durationInWeeksText = "%d w".localized(withComment: "Duration in weeks")
    static let durationInDaysText = "%d d".localized(withComment: "Duration in days")
    static let durationInHoursText = "%d h".localized(withComment: "Duration in hours")
    static let durationInMinutesText = "%d min".localized(withComment: "Duration in minutes")
    static let durationInSecondsText = "%d sec".localized(withComment: "Duration in seconds")
}
