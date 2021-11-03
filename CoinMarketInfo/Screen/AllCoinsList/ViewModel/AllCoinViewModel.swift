//
//  AllCoinViewModel.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import Foundation

class AllCoinViewModel {
    
    var coinName: String
    var coinPrice: String
    var coinSymbol: String
    var state: CoinState
    
    init(model: Coin) {
        coinName = model.name ?? ""
        coinPrice = "$\(model.price.formattedWithSeparator)"
        coinSymbol = model.symbol ?? ""
        state = model.state > 0 ? .up : .down
        
    }
}
