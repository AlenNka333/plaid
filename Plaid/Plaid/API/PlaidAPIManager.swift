//
//  PlaidAPI.swift
//  Plaid
//
//  Created by Alena Nesterkina on 23.04.22.
//

import Foundation
import LinkKit

class PlaidAPIManager {
    enum RequestType {
        case createLinkToken
        case findInstitution
        case createPublicToken
        case getAccessToken
        case getInstitutionData

        var url: URL? {
            var url = "https://sandbox.plaid.com/"

            switch self {
            case .createLinkToken:
                url.append("link/token/create")
            case .findInstitution:
                url.append("institutions/search")
            case .createPublicToken:
                url.append("sandbox/public_token/create")
            case .getAccessToken:
                url.append("item/public_token/exchange")
            case .getInstitutionData:
                url.append("investments/holdings/get")
            }

            return URL(string: url)
        }
    }

    enum Institutions {
        case robinhood
        case eTrade
        case charles

        var name: String {
            switch self {
            case .robinhood:
                return "Robinhood"
            case .eTrade:
                return "E-Trade"
            case .charles:
                return "Charles Swchab"
            }
        }
    }

    private let decoder: JSONDecoder = {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }()
    private let api: API = API()

    func makeRequest<Response: Codable>(type: RequestType, parameters: [String: Any], completion: @escaping ((Result<Response?, Error>) -> Void)) {
        let url = type.url
        guard let url = url else {
            return
        }

        api.requestData(url: url, parameters: parameters) { result in
            switch result {
            case let .failure(error):
                completion(.failure(error))
            case let .success(data):
                guard let data = data else {
                    completion(.success(nil))
                    return
                }
                do {
                    if let jsonParsed = try? self.decoder.decode(Response.self, from: data) {
                        completion(.success(jsonParsed))
                    } else {
                        print("data maybe corrupted or in wrong format")
                        throw URLError(.badServerResponse)
                    }
                } catch let error {
                    print(error.localizedDescription)
                }
            }
        }
    }
}
