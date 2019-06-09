//
//  DayPayments.swift
//  RTFM
//
//  Created by Евгений Богомолов on 08/06/2019.
//  Copyright © 2019 be. All rights reserved.
//

import Foundation

struct DayPayments {
    var date: Date
    var payments: [CompletedPayment]
    
    static func parsePayments(_ payments: [CompletedPayment]) -> [DayPayments] {
        guard payments.count > 0 else {
            return []
        }
        let first = payments.first!
        
        let date = Date(timeIntervalSince1970: TimeInterval(first.date))
        
        let df = DateFormatter()
        df.dateStyle = .short

        let cal = Calendar.current
        var currentDateString = df.string(from: date)
        var day = DayPayments(date: cal.startOfDay(for: date), payments: [])
        var results = [day]

        for p in payments {
            let pDate = Date(timeIntervalSince1970: TimeInterval(p.date))
            let str = df.string(from: pDate)
            
            if str == currentDateString {
                results[results.count-1].payments.append(p)
            } else {
                day = DayPayments(date: cal.startOfDay(for: pDate), payments: [p])
                currentDateString = str
                results.append(day)
            }
        }
        return results
    }
}
