//
//  MyCoinListViewModel.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import Foundation
import Combine
import CoreData

class MyCoinListViewModel {
    
    var dataSource = CurrentValueSubject<[CoinViewModel], Never>([CoinViewModel]())
    private var subscriptions = Set<AnyCancellable>()
    
    func observCoinData() {
        let request: NSFetchRequest<MyCoinList> = MyCoinList.fetchRequest()
        
        let sortDescriptor = NSSortDescriptor(key: "name", ascending: true)
        request.sortDescriptors = [sortDescriptor]
        
        ObservableCoreData(request: request,
                           context: CoreDataManager.shared.context)
            .map {$0}
            .removeDuplicates()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: {completion in
                if case let .failure(error) = completion {
                    debugPrint("Error get coins", error)
                }
            }, receiveValue: { [weak self] coins in
                self?.dataSource.send(coins.map({CoinViewModel(model: $0)}))
            })
            .store(in: &self.subscriptions)
    }
    
}
