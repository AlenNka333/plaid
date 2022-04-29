//
//  UserSession.swift
//  Plaid
//
//  Created by Alena Nesterkina on 26.04.22.
//

import Foundation
import LinkKit

class UserSession {
    var publicToken: [String] = []
    var metadata: [SuccessMetadata] = []
    var accessToken: [String] = []
    var investmentHoldings: [String: Accounts] = [:]
}
