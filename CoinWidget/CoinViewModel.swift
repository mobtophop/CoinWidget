//
//  CoinViewModel.swift
//  CoinWidgetExtension
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import Foundation

enum CoinState: Int {
    case down
    case up
}

struct CoinViewModel: Hashable {
    var id = UUID()
    var coinName: String
    var coinPrice: Double
    var coinSymbol: String
    var state: CoinState

    
    init(model: MyCoinList) {
        coinName = model.name ?? ""
        coinPrice = model.price
        coinSymbol = model.symbol ?? ""
        state = model.state > 0 ? .up : .down
        
    }

    init(coinName: String, coinPrice: String, coinSymbol: String) {
        self.coinName = coinName
        self.coinPrice = Double(coinPrice) ?? 0.0
        self.coinSymbol = coinSymbol
        self.state = .up
    }

}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.groupingSeparator = " "
        return formatter
    }()
}

extension Numeric {
    var formattedWithSeparator: String { Formatter.withSeparator.string(for: self) ?? "" }
}
