//
//  Date.swift
//  ToDoList
//
//  Created by Matúš Mištrik on 18/05/2022.
//

import Foundation

extension Date {
    /// Funkcia, ktora z hodnot ziskanych v parametri vrati Datum
    /// - Parameters:
    ///   - year: Rok pozadovaneho datumu
    ///   - month: Mesiac pozadovaneho datumu
    ///   - day: Den pozadovaneho datumu
    /// - Returns: Naformatovany datum
    static func from(_ year: Int, _ month: Int, _ day: Int) -> Date?
        {
            let gregorianCalendar = Calendar(identifier: .gregorian)
            let dateComponents = DateComponents(calendar: gregorianCalendar, year: year, month: month, day: day)
            return gregorianCalendar.date(from: dateComponents)
        }
}
