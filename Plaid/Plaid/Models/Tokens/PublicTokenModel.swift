//
//  PublicTokenModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct PublicTokenModel: Codable {
    let public_token: String
    let request_id: String
}
