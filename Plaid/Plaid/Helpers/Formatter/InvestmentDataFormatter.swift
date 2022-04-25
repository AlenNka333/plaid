//
//  InvestmentDataFormatter.swift
//  Plaid
//
//  Created by Alena Nesterkina on 25.04.22.
//

import Foundation

class InvestmentDataFormatter {
    static func formatData(data: Accounts) {

        var results: [String: [String: String]] = [:]
        let securityIds = data.holdings.map { $0.security_id }

        securityIds.forEach {
            results[$0] = [:]
        }

        data.holdings.forEach {
            results[$0.security_id]?["quantity"] = String($0.quantity)
            results[$0.security_id]?["institution_price"] = String($0.institution_price)
            results[$0.security_id]?["institution_value"] = String($0.institution_value)
            results[$0.security_id]?["cost_basis"] = String($0.cost_basis ?? 0)
        }

        data.securities.forEach {
            results[$0.security_id]?["close_price"] = $0.close_price.map { String($0) }
            results[$0.security_id]?["ticker_symbol"] = $0.ticker_symbol.map { String($0) }
        }

        print(results)
    }
}
