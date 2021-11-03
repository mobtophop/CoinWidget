//
//  CoreDataManager.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import Foundation
import CoreData
import Combine
import WidgetKit

class CoreDataManager {
    static let shared = CoreDataManager()
    
    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    // MARK: - Core Data stack
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoinModel")
        let storeURL = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.malygin.coinMarketInfo")!.appendingPathComponent("CoinModel.sqlite")
        
        var defaultURL: URL?
        if let storeDescription = container.persistentStoreDescriptions.first, let url = storeDescription.url {
            defaultURL = FileManager.default.fileExists(atPath: url.path) ? url : nil
        }
        
        if defaultURL == nil {
            container.persistentStoreDescriptions = [NSPersistentStoreDescription(url: storeURL)]
        }
        container.loadPersistentStores(completionHandler: { [unowned container] (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
            
            if let url = defaultURL, url.absoluteString != storeURL.absoluteString {
                let coordinator = container.persistentStoreCoordinator
                if let oldStore = coordinator.persistentStore(for: url) {
                    do {
                        try coordinator.migratePersistentStore(oldStore, to: storeURL, options: nil, withType: NSSQLiteStoreType)
                    } catch {
                        print(error.localizedDescription)
                    }
                    
                    // delete old store
                    let fileCoordinator = NSFileCoordinator(filePresenter: nil)
                    fileCoordinator.coordinate(writingItemAt: url, options: .forDeleting, error: nil, byAccessor: { url in
                        do {
                            try FileManager.default.removeItem(at: url)
                        } catch {
                            print(error.localizedDescription)
                        }
                    })
                }
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
}

extension CoreDataManager {
    func saveCoins(_ coins: CoinData) {
        coins.data.forEach{self.saveOrUpdateCoin($0)}
        saveContext()
    }
    
    func saveMyCoinList(_ coin: CoinViewModel) {
        let myCoinList = MyCoinList(context: context)
        myCoinList.name = coin.coinName
        myCoinList.price = coin.coinPrice
        myCoinList.symbol = coin.coinSymbol
        myCoinList.state = Int32(coin.state.rawValue) 
        saveContext()
    }
 
    func saveOrUpdateCoin(_ coins: Datum) {
        if !updateCoin(coins) {
            makeManadgedObjectCoin(coins)
        }
    }
    
    func deleteData(_ entityName: String) {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        do {
            try context.persistentStoreCoordinator?.execute(deleteRequest, with: context)
        } catch {
            
        }
    }
    
    func deleteCoinFromMyList(_ coin: CoinViewModel) {
        let fetchRequest = NSFetchRequest<MyCoinList>(entityName: "MyCoinList")
        
        let predicate = NSPredicate(format: "name = %@", coin.coinName)
        fetchRequest.predicate = predicate
        
        guard let coin = try? context.fetch(fetchRequest).first else { return }
        context.delete(coin)
        saveContext()
        
    }
    
    func updateCoin(_ coinData: Datum) -> Bool {
        
        let fetchRequest = NSFetchRequest<Coin>(entityName: "Coin")
        
        let predicate = NSPredicate(format: "name = %@", coinData.name)
        fetchRequest.predicate = predicate
        
        guard let coin = try? context.fetch(fetchRequest).first else { return false }
        
        coin.name = coinData.name
        coin.symbol = coinData.symbol
        coin.price = coinData.quote.usd.price
        coin.state = Int32(coinData.quote.usd.percentChange1H)
        
        return true
    }
    
    @available(iOSApplicationExtension 14.0, *)
    func updateMyCoinList(coin: Datum) {
        
        let fetchRequest = NSFetchRequest<MyCoinList>(entityName: "MyCoinList")
        
        let predicate = NSPredicate(format: "name = %@", coin.name)
        fetchRequest.predicate = predicate
        
        guard let myCoin = try? context.fetch(fetchRequest).first else { return }
        
        myCoin.name = coin.name
        myCoin.symbol = coin.symbol
        myCoin.price = coin.quote.usd.price
        myCoin.state = Int32(coin.quote.usd.percentChange1H)
        WidgetCenter.shared.reloadAllTimelines()
    }
    
    @discardableResult func makeManadgedObjectCoin(_ coins: Datum) -> NSManagedObject {
    let coin = Coin(context: context)
        coin.name = coins.name
        coin.price = coins.quote.usd.price
        coin.symbol = coins.symbol
        coin.state = Int32(coins.quote.usd.percentChange1H)
        return coin
    }
}
