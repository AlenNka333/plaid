//
//  InstitutionInfo.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct InstitutionInfo: Codable {
    let country_codes: [String]
    let institution_id: String
    let name: String
    let oauth: Bool
    let products: [String]
    let routing_numbers: [String]
}
