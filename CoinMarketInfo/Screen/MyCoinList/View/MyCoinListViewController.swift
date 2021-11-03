//
//  MyCoinListViewController.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 09.03.2021.
//

import UIKit
import Combine

class MyCoinListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private let viewModel = MyCoinListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private let coinCell = "coinCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.observCoinData()
    }
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: coinCell)
        viewModel.dataSource.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
}

extension MyCoinListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coinCell, for: indexPath) as! CoinTableViewCell
        let coin = viewModel.dataSource.value[indexPath.row]
        cell.config(coin)
        
        return cell
    }
}

extension MyCoinListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let item = viewModel.dataSource.value[indexPath.row]
            CoreDataManager.shared.deleteCoinFromMyList(item)
            tableView.reloadData()
        }
    }
}
