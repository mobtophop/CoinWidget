//
//  CoinWidgetMedium.swift
//  CoinWidgetExtension
//
//  Created by Eugene Shapovalov on 28.02.2021.
//

import SwiftUI
import WidgetKit

struct CoinWidgetMedium: View {
    private var coins: [CoinViewModel]
    
    init(coins: [CoinViewModel]) {
        self.coins = coins
    }
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(coins.prefix(3), id: \.self) { item in
                CoinMediumCell(coins: item)
            }
        }
        .padding(.top, 5)
    }
}

struct CoinWidgetMedium_Previews: PreviewProvider {
    static var previews: some View {
        CoinWidgetMedium(coins: [
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC")])
            .previewContext(WidgetPreviewContext(family: .systemMedium))
    }
}
