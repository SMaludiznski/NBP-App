//
//  Date.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import Foundation

extension Date {
    func formatIntoString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY-MM-dd"
        return formatter.string(from: self)
    }
}
