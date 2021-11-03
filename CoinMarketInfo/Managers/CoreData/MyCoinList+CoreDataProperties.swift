//
//  MyCoinList+CoreDataProperties.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 11.03.2021.
//
//

import Foundation
import CoreData


extension MyCoinList {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MyCoinList> {
        return NSFetchRequest<MyCoinList>(entityName: "MyCoinList")
    }

    @NSManaged public var name: String?
    @NSManaged public var price: Double
    @NSManaged public var state: Int32
    @NSManaged public var symbol: String?

}

extension MyCoinList : Identifiable {

}
