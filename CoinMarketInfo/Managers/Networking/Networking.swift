//
//  Networking.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import Foundation
import Alamofire

class Networking {
    
    static func getCoinList(completion: @escaping ((CoinData?, Error?) -> ())) {
        let headers: HTTPHeaders = [
            "X-CMC_PRO_API_KEY": "f1ccce76-6bc3-4b60-9340-34f79ceea5c3",
            "Accept": "application/json"
        ]
        AF.request("https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest", method: .get, headers: headers).responseJSON { response in
//            debugPrint(response)
            
            if let error = response.error {
                completion(nil, error)
            }
            
            if let data = response.data {
                let decodeData = try? JSONDecoder().decode(CoinData.self, from: data)
                completion(decodeData, nil)
            }
        }
    }
}
