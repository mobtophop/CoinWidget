//
//  CoinWidgetLarge.swift
//  CoinWidgetExtension
//
//  Created by Eugene Shapovalov on 28.02.2021.
//

import SwiftUI
import WidgetKit

struct CoinWidgetLarge: View {
    
    private var coins: [CoinViewModel]
    
    init(coins: [CoinViewModel]) {
        self.coins = coins
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(coins.prefix(7), id: \.self) { item in
                CoinLargeCell(coins: item)
            }
            Spacer()
        }
        .padding(.top, 10)
    }
}

struct CoinWidgetLarge_Previews: PreviewProvider {
    static var previews: some View {
        CoinWidgetLarge(coins: [
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC"),
                            CoinViewModel(coinName: "Bitcoin", coinPrice: "$45 000.0", coinSymbol: "BTC")])
            .previewContext(WidgetPreviewContext(family: .systemLarge))
    }
}
