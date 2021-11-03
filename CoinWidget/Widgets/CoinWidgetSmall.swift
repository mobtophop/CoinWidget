//
//  CoinWidgetSmall.swift
//  CoinWidgetExtension
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import SwiftUI
import WidgetKit

struct CoinWidgetSmall: View {
    private var coins: [CoinViewModel]
    
    init(coins: [CoinViewModel]) {
        self.coins = coins
    }
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(coins.prefix(3), id: \.self) { item in
                CoinSmallCell(coins: item)
            }
        }
    }
}

struct CoinWidgetSmall_Previews: PreviewProvider {
    static var previews: some View {
        CoinWidgetSmall(coins: [
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC")])
        .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
