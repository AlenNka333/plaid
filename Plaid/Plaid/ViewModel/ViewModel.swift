//
//  ViewModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation
import LinkKit

class ViewModel {
    private let manager: PlaidAPIManager
    private let linkData: LinkModel
    private var linkToken: LinkTokenModel?
    private var publicToken: PublicTokenModel?
    private var accessToken: AccessTokenModel?
    private var investmentHoldings: Accounts?
    private var robinhoodInfo: Institution?

    init(manager: PlaidAPIManager, data: LinkModel) {
        self.linkData = data
        self.manager = manager
    }

    func createLinkToken() {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "user": ["client_user_id": linkData.client_user_id],
            "client_name": linkData.client_name,
            "products": linkData.products,
            "country_codes": linkData.country_codes,
            "language": linkData.language
        ]

        manager.makeRequest(type: .createLinkToken, parameters: parameters) { [weak self] (result: (Result<LinkTokenModel?, Error>)) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(data):
                guard let data = data else {
                    print("Data is empty")
                    return
                }

                self?.linkToken = data
                self?.getRobinhoodInstituteInfo()
            }
        }
    }

    func createLinkTokenConfiguration() -> LinkTokenConfiguration? {
        guard let linkToken = linkToken?.link_token else {
            return nil
        }

        var linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
            print("public-token: \(success.publicToken) metadata: \(success.metadata)")
        }

        linkConfiguration.onEvent = { event in
            print("\(event.metadata.errorMessage)")
        }

        linkConfiguration.onExit = { exit in
            if let error = exit.error {
                print("exit with \(error)\n\(exit.metadata)")
            } else {
                print("exit with \(exit.metadata)")
            }
        }
        return linkConfiguration
    }

    func getRobinhoodInstituteInfo() {
        let parameters: [String: Any] = [
            "query": linkData.institutions[0],
            "products": linkData.products,
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "country_codes": linkData.country_codes
        ]

        manager.makeRequest(type: .findInstitution, parameters: parameters) { [weak self] (result: (Result<Institution?, Error>)) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(data):
                guard let data = data else {
                    print("Data is empty")
                    return
                }

                self?.robinhoodInfo = data
                self?.createPublicToken()
            }
        }
    }

    func createPublicToken() {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "institution_id": robinhoodInfo?.institutions[0].institution_id,
            "initial_products": linkData.products
        ]

        manager.makeRequest(type: .createPublicToken, parameters: parameters) { [weak self] (result: (Result<PublicTokenModel?, Error>)) in
            switch result {
            case let .failure(error):
                print(error.localizedDescription)
            case let .success(data):
                guard let data = data else {
                    print("Data is empty")
                    return
                }

                self?.publicToken = data
                self?.exchangePublicToAccessToken()
            }
        }
    }

    func exchangePublicToAccessToken() {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "public_token": publicToken?.public_token
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

                self?.accessToken = data
                self?.getInvestmentHoldings()
            }
        }
    }

    func getInvestmentHoldings() {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "access_token": accessToken?.access_token
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

                self?.investmentHoldings = data
                print("Success")
                InvestmentDataFormatter.formatData(data: data)
            }
        }
    }
}
