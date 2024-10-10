//
//  UpdateManager.swift
//  Puff
//
//  Created by Никита Куприянов on 03.10.2024.
//

import Foundation

final class UpdateManager {

    private let session: URLSession
    private let jsonDecoder: JSONDecoder

    init(session: URLSession = .shared, jsonDecoder: JSONDecoder = .init()) {
        self.session = session
        self.jsonDecoder = jsonDecoder
    }

    func getLatestAvailableVersion() async throws -> LatestAppStoreVersion? {
        let url = URL(string: "http://itunes.apple.com/lookup?bundleId=com.quitvapingteam.quitvaping")!
        let request = URLRequest(url: url)
        do {
            let (data, _) = try await session.data(for: request)
            let response = try jsonDecoder.decode(LookUpResponse.self, from: data)

            return response.results.first.map {
                .init(
                    version: $0.version,
                    minimumOsVersion: $0.minimumOsVersion,
                    upgradeURL: $0.trackViewUrl
                )
            }
        } catch {
            CrashlyticsManager.log(error.localizedDescription)

            return nil
        }
    }
}

extension UpdateManager {
    struct LatestAppStoreVersion {
        let version: String
        let minimumOsVersion: String
        let upgradeURL: URL
    }
}


private extension UpdateManager {
    struct LookUpResponse: Decodable {
        let results: [LookUpResult]

        struct LookUpResult: Decodable {
            let version: String
            let minimumOsVersion: String
            let trackViewUrl: URL
        }
    }
}
