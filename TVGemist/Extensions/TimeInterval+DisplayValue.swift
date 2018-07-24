//
//  TimeInterval+DisplayValue.swift
//  TVGemist
//
//  Created by Jeroen Wesbeek on 24/07/2018.
//  Copyright © 2018 Jeroen Wesbeek. All rights reserved.
//

import Foundation

extension TimeInterval {
    private var time: (weeks: Int, days: Int, hours: Int, minutes: Int, seconds: Int) {
        return (
            weeks: Int(self) / (3600 * 24 * 7),
            days: Int(self) / (3600 * 24),
            hours: Int(self) / 3600,
            minutes: (Int(self) % 3600) / 60,
            seconds: (Int(self) % 3600) % 60
        )
    }
    
    private func getTimeDisplayValue(forValue value: Int, withFormat format: String) -> String? {
        guard value > 0 else {
            return nil
        }
        
        return String.localizedStringWithFormat(format, value)
    }
    
    public var timeDisplayValue: String {
        let time = self.time
        var components = [String]()
        
        if let weeks = self.getTimeDisplayValue(forValue: time.weeks, withFormat: String.durationInWeeksText) {
            components.append(weeks)
        }
        
        if let days = self.getTimeDisplayValue(forValue: time.days, withFormat: String.durationInDaysText) {
            components.append(days)
        }
        
        if let hours = self.getTimeDisplayValue(forValue: time.hours, withFormat: String.durationInHoursText) {
            components.append(hours)
        }
        
        if let minutes = self.getTimeDisplayValue(forValue: time.minutes, withFormat: String.durationInMinutesText) {
            components.append(minutes)
        }
        
        //if let seconds = self.getTimeDisplayValue(forValue: time.seconds, withFormat: String.durationInSecondsText) {
        //    components.append(seconds)
        //}
        
        return components.joined(separator: ", ")
    }
}
