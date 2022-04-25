//
//  InvestmentError.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct InvestmentError: Codable {
    let error_type: String
    let error_code: String
    let error_message: String
    let display_message: String?
    let request_id: String
    let status: Int?
    let causes: [String]
    let documentation_url: String
    let suggested_action: String
}
