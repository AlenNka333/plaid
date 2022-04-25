//
//  Holding.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Holding: Codable {
    let account_id: String
    let cost_basis: Double?
    let institution_price: Double
    let institution_price_as_of: String?
    let institution_value: Double
    let iso_currency_code: String?
    let quantity: Double
    let security_id: String
    let unofficial_currency_code: String?
}
