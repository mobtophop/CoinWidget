//
//  CoinModel.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import Foundation

// MARK: - CoinData
struct CoinData: Codable {
    let status: Status
    let data: [Datum]
}

// MARK: - Datum
struct Datum: Codable {
    let id: Int
    let name, symbol: String
    let quote: Quote
    
    enum CodingKeys: String, CodingKey {
        case id, name, symbol
        case quote
    }
}

// MARK: - Quote
struct Quote: Codable {
    let usd: Usd
    
    enum CodingKeys: String, CodingKey {
        case usd = "USD"
    }
}

// MARK: - Usd
struct Usd: Codable {
    let price, percentChange1H: Double
    
    enum CodingKeys: String, CodingKey {
        case price
        case percentChange1H = "percent_change_1h"
    }
}

// MARK: - Status
struct Status: Codable {
    let timestamp: String
    let errorCode: Int
    let errorMessage: String?
    let elapsed, creditCount: Int
    let notice: String?
    let totalCount: Int
    
    enum CodingKeys: String, CodingKey {
        case timestamp
        case errorCode = "error_code"
        case errorMessage = "error_message"
        case elapsed
        case creditCount = "credit_count"
        case notice
        case totalCount = "total_count"
    }
}
