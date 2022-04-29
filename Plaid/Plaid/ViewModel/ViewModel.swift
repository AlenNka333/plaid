//
//  ViewModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 22.04.22.
//

import Foundation
import LinkKit

class ViewModel {
    let session: UserSession
    private let manager: PlaidAPIManager
    let linkData: LinkModel
    private var linkToken: LinkTokenModel?
    private var publicToken: PublicTokenModel?
    private var accessToken: AccessTokenModel?
    private var investmentHoldings: Accounts?
    private var robinhoodInfo: Institution?

    var configurationCreated: ((LinkTokenConfiguration?) -> Void)?
    var connectedToBank: (() -> Void)?

    init(manager: PlaidAPIManager, data: LinkModel, session: UserSession) {
        self.linkData = data
        self.manager = manager
        self.session = session
    }

    func createLinkToken() {
        let parameters: [String: Any] = [
            "client_id": linkData.clientId,
            "secret": linkData.secret,
            "user": ["client_user_id": linkData.client_user_id],
            "client_name": linkData.client_name,
            "products": linkData.products,
            "country_codes": linkData.country_codes,
            "language": linkData.language,
            "account_filters": ["investment": ["account_subtypes": linkData.account_subtypes]]
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
                self?.createLinkTokenConfiguration()
            }
        }
    }

    func createLinkTokenConfiguration() {
        guard let linkToken = linkToken?.link_token else {
            return
        }

        var linkConfiguration = LinkTokenConfiguration(token: linkToken) { success in
            print("public-token: \(success.publicToken) metadata: \(success.metadata)")
            self.session.publicToken.append(success.publicToken)
            self.session.metadata.append(success.metadata)
            self.connectedToBank?()
        }

        linkConfiguration.onExit = { exit in
            if let error = exit.error {
                print("exit with \(error)\n\(exit.metadata)")
            } else {
                print("exit with \(exit.metadata)")
            }
            self.connectedToBank?()
        }

        configurationCreated?(linkConfiguration)
    }
}
