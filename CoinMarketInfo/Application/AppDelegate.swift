//
//  AppDelegate.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import UIKit
import BackgroundTasks
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //        CoreDataManager.shared.deleteData("Coin")
        //              CoreDataManager.shared.deleteData("MyCoinList")
        
        BGTaskScheduler.shared.register(forTaskWithIdentifier: "com.malygin.fetchCoinProcessingIdentifier",
                                        using: nil) { (task) in
            self.handleAppRefreshTask(task: task as! BGAppRefreshTask)
        }
        
        return true
    }
    
    func handleAppRefreshTask(task: BGAppRefreshTask) {
        task.expirationHandler = {
          
        }
        
        Networking.getCoinList { [weak self] (coins, error) in
            guard let coins = coins else { return }
            coins.data.forEach {if #available(iOSApplicationExtension 14.0, *) {
                CoreDataManager.shared.updateMyCoinList(coin: $0)
            } else {
                // Fallback on earlier versions
            }}
            CoreDataManager.shared.saveCoins(coins)
        }
        
        scheduleBackgroundCoinFetch()
    }
    
    func scheduleBackgroundCoinFetch() {
        let coinFetchTask = BGAppRefreshTaskRequest(identifier: "com.malygin.fetchCoinProcessingIdentifier")
        coinFetchTask.earliestBeginDate = Date(timeIntervalSinceNow: 60)
        do {
            try BGTaskScheduler.shared.submit(coinFetchTask)
        } catch {
            print("Unable to submit task: \(error.localizedDescription)")
        }
    }

    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while  the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

