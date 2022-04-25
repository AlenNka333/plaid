//
//  AccessTokenModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct AccessTokenModel: Codable {
    let access_token: String
    let item_id: String
    let request_id: String
}
