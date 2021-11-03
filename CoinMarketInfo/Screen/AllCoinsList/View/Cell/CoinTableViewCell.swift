//
//  CoinTableViewCell.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import UIKit

class CoinTableViewCell: UITableViewCell {
    
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var symbol: UILabel!
    @IBOutlet weak var price: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    func config(_ coin: CoinViewModel) {
        name.text = coin.coinName
        symbol.text = coin.coinSymbol
        price.text = "$\(coin.coinPrice.formattedWithSeparator)"
        
        switch coin.state {
            case .down:
                price.textColor = Constant.mainRed
            case .up:
                price.textColor = Constant.mainGreen
        }
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
