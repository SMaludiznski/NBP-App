//
//  CurrencyRates.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import Foundation

struct CurrencyRates: Decodable {
    let effectiveDate: String
    let mid: Double?
    let bid: Double?
    let ask: Double?
}
