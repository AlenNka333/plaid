//
//  LinkModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation

struct LinkModel {
    let clientId = "626041fdfcaeb8001411f88b"
    let secret = "317390e7918e5f251a91678b380105"
    let client_user_id = "test-12345"
    let client_name = "Plaid"
    let products: [String] = ["investments"]
    let country_codes: [String] = ["US"]
    let language = "en"
    let account_subtypes = ["brokerage"]
    let institutions = ["Robinhood"]
    let testUserName = "custom_test_institutions"
    let testPassword = "test1!Test"
}
