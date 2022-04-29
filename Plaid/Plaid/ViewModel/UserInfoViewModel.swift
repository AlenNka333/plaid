//
//  UserInfoViewModel.swift
//  Plaid
//
//  Created by Alena Nesterkina on 26.04.22.
//

import Foundation
import LinkKit

class UserInfoViewModel {
    let session: UserSession
    let manager: PlaidAPIManager
    let linkData: LinkModel

    var configurationCreated: ((LinkTokenConfiguration?) -> Void)?
    var connectedToBank: ((Bool) -> Void)?

    init(manager: PlaidAPIManager, data: LinkModel, session: UserSession) {
        self.linkData = data
        self.manager = manager
        self.session = session
    }

    func getPublicToken(indexPath: IndexPath) -> String {
        session.publicToken[indexPath.row]
    }

    func getListOfInstitutions() -> [String] {
        session.metadata.map {
            return $0.institution.name
        }
    }

    func getDataFor(indexPath: IndexPath) -> SuccessMetadata {
        return session.metadata[indexPath.row]
    }
}
