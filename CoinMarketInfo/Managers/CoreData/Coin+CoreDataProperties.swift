//
//  Coin+CoreDataProperties.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 11.03.2021.
//
//

import Foundation
import CoreData


extension Coin {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Coin> {
        return NSFetchRequest<Coin>(entityName: "Coin")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var state: Int32
    @NSManaged public var symbol: String?

}

extension Coin : Identifiable {

}
