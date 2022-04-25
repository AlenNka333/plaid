//
//  Accounts.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Accounts: Codable {
    let accounts: [AccountInfo]
    let holdings: [Holding]
    let item: Item
    let request_id: String
    let securities: [Security]
}
