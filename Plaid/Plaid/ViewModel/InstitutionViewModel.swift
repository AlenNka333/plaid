//
//  InstitutionViewModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 28.04.22.
//

import Foundation
import LinkKit

class InstitutionViewModel {
    let session: UserSession
    let manager: PlaidAPIManager
    let linkData: LinkModel

    var dataReceived: (() -> Void)?

    init(manager: PlaidAPIManager, data: LinkModel, session: UserSession, publicToken: String) {
        self.linkData = data
        self.manager = manager
        self.session = session

        exchangePublicToAccessToken(publicToken: publicToken)
    }

    func exchangePublicToAccessToken(publicToken: String) {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "public_token": publicToken
        ]

        manager.makeRequest(type: .getAccessToken, parameters: parameters) { [weak self] (result: (Result<AccessTokenModel?, Error>)) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(data):
                guard let data = data else {
                    print("Data is empty")
                    return
                }

                self?.session.accessToken.append(data.access_token)
                self?.getInvestmentHoldings(accessToken: data.access_token)
            }
        }
    }

    func getInvestmentHoldings(accessToken: String) {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "access_token": accessToken
        ]

        manager.makeRequest(type: .getInstitutionData, parameters: parameters) { [weak self] (result: (Result<Accounts?, Error>)) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(data):
                guard let data = data else {
                    print("Data is empty")
                    return
                }

                self?.session.investmentHoldings[data.item.institution_id ?? accessToken] = data
                print("Success")
                self?.dataReceived?()
            }
        }
    }

    func getNumberOfAccounts() -> Int {
        session.investmentHoldings.count
    }

    func getAccountName(indexPath: IndexPath) -> String {
        let institutionId = session.metadata[indexPath.row].institution.id
        return session.investmentHoldings[institutionId]?.accounts[indexPath.row].official_name ?? ""
    }

    func getAccountBalance(indexPath: IndexPath) -> Double? {
        let institutionId = session.metadata[indexPath.row].institution.id
        return session.investmentHoldings[institutionId]?.accounts[indexPath.row].balances.current
    }

    func getTicker(indexPath: IndexPath) -> (String, String) {
        let institutionId = session.metadata[indexPath.row].institution.id
        guard let investment = session.investmentHoldings[institutionId] else {
            return ("none", "no name")
        }
        let accountId = investment.accounts[indexPath.row].account_id
        let securityId = investment.holdings.first(where: { $0.account_id == accountId })?.security_id

        let ticker = investment.securities.first(where: { $0.security_id == securityId })?.ticker_symbol ?? "none"
        let tickerName = investment.securities.first(where: { $0.security_id == securityId })?.name ?? "no name"

        return (ticker, tickerName)
    }

    func getCostBasisData(indexPath: IndexPath) -> Double? {
        let institutionId = session.metadata[indexPath.row].institution.id
        guard let investment = session.investmentHoldings[institutionId] else {
            return 0.0
        }
        let accountId = investment.accounts[indexPath.row].account_id
        return investment.holdings.first(where: { $0.account_id == accountId })?.cost_basis
    }

    func getQuantity(indexPath: IndexPath) -> Double? {
        let institutionId = session.metadata[indexPath.row].institution.id
        guard let investment = session.investmentHoldings[institutionId] else {
            return 0.0
        }
        let accountId = investment.accounts[indexPath.row].account_id
        return investment.holdings.first(where: { $0.account_id == accountId })?.quantity
    }
}
