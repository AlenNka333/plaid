//
//  Security.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Security: Codable {
    let close_price: Double?
    let close_price_as_of: String?
    let cusip: String?
    let institution_id: String?
    let institution_security_id: String?
    let is_cash_equivalent: Bool?
    let isin: String?
    let iso_currency_code: String?
    let name: String?
    let proxy_security_id: String?
    let security_id: String
    let sedol: String?
    let ticker_symbol: String?
    let type: String?
    let unofficial_currency_code: String?
}
