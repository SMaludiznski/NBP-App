//
//  Rates.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import Foundation

struct Rates: Decodable {
    let currency: String
    let code: String
    let mid: Double?
    let bid: Double?
    let ask: Double?
}
