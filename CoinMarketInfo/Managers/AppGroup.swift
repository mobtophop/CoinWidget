//
//  AppGroup.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 11.03.2021.
//

import Foundation

public enum AppGroup: String {
    case facts = "group.malygin.coinMarketInfo"
    
    public var containerURL: URL {
        switch self {
            case .facts:
                return FileManager.default.containerURL(
                    forSecurityApplicationGroupIdentifier: self.rawValue)!
        }
    }
}

let storeURL = AppGroup.facts.containerURL.appendingPathComponent("Info.plist")
