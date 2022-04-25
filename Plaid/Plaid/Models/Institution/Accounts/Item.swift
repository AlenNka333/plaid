//
//  Item.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Item: Codable {
    let available_products: [String]
    let billed_products: [String]
    let consent_expiration_time: String?
    let error: InvestmentError?
    let institution_id: String?
    let item_id: String
    let products: [String]
    let update_type: String
    let webhook: String?
}
