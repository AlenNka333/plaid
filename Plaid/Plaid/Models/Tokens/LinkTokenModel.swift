//
//  LinkTokenModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct LinkTokenModel: Codable {
    let link_token: String
    let expiration: String
    let request_id: String
}
