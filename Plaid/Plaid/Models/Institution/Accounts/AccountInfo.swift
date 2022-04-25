//
//  AccountInfo.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct AccountInfo: Codable {
    let account_id: String
    let balances: Balance
    let mask: String?
    let name: String
    let official_name: String?
    let subtype: String?
    let type: String
}
