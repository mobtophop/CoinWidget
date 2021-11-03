//
//  Networking.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import Foundation
import Alamofire

class Networking {
    
    let headers: HTTPHeaders = [
        "X-CMC_PRO_API_KEY": "f1ccce76-6bc3-4b60-9340-34f79ceea5c3",
        "Accept": "application/json"
    ]
    
    func getCoinList() {
        AF.request("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", method: .get, headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }
    
}
