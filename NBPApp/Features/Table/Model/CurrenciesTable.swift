//
//  CurrenciesTable.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import Foundation

struct CurrenciesTable: Decodable {
    let table: String
    let effectiveDate: String
    let rates: [Rates]
}
