//
//  CoinViewModel.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import Foundation

class CoinViewModel {
    var coinName: String
    var coinPrice: Double
    var coinSymbol: String
    var state: CoinState
    
    init(model: Coin) {
        coinName = model.name ?? ""
        coinPrice = model.price
        coinSymbol = model.symbol ?? ""
        state = model.state > 0 ? .up : .down
        
    }
    
    init(model: MyCoinList) {
        coinName = model.name ?? ""
        coinPrice = model.price
        coinSymbol = model.symbol ?? ""
        state = model.state > 0 ? .up : .down
        
    }
}
