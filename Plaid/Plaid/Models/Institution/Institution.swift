//
//  Institution.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct Institution: Codable {
    let institutions: [InstitutionInfo]
    let request_id: String
}
