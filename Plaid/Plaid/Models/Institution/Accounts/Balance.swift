//
//  Balance.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Balance: Codable {
    let available: Double?
    let current: Double?
    let iso_currency_code: String?
    let limit: Double?
    let unofficial_currency_code: String?
}
