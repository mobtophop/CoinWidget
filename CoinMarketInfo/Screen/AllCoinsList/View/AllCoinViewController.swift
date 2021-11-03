//
//  AllCoinViewController.swift
//  CoinMarketInfo
//
//  Created by Eugene Shapovalov on 21.02.2021.
//

import UIKit
import Combine

class AllCoinViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    private var viewModel = AllCoinListViewModel()
    private var subscriptions = Set<AnyCancellable>()
    private var coinCell = "coinCell"
    let searchController = UISearchController(searchResultsController: nil)
    var filteredCoin: [CoinViewModel] = []
    var isSearchBarEmpty: Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    var isFiltering: Bool {
        return searchController.isActive && !isSearchBarEmpty
    }
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewModel.getAllCurrency()
    }
    
    private func setupTableView() {
        tableView.refreshControl = refreshControl
        refreshControl.addTarget(self, action: #selector(refreshWeatherData(_:)), for: .valueChanged)
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "CoinTableViewCell", bundle: nil), forCellReuseIdentifier: coinCell)
        viewModel.dataSource.sink { [unowned self] _ in
            self.tableView.reloadData()
        }.store(in: &subscriptions)
    }
    
    private func setupSearchBar() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Search"
        navigationItem.searchController = searchController
        definesPresentationContext = true
    }
    
    func registerForNotifications() {
        NotificationCenter.default.addObserver(
            forName: Notification.Name("com.andyibanez.newPokemonFetched"),
            object: nil,
            queue: nil) { (notification) in
            print("notification received")
           
        }
    }
    
    func filterContentForSearchText(_ searchText: String,
                                    category: Coin? = nil) {
        filteredCoin = viewModel.dataSource.value.filter { (user: CoinViewModel) -> Bool in
            return (user.coinName.lowercased().contains(searchText.lowercased()) )
        }
        
        tableView.reloadData()
    }
    
    @objc private func refreshWeatherData(_ sender: Any) {
        viewModel.getAllCurrency()
        tableView.reloadData()
        refreshControl.endRefreshing()
    }
    
}

extension AllCoinViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering ? filteredCoin.count : viewModel.dataSource.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: coinCell, for: indexPath) as! CoinTableViewCell
        let coin = isFiltering ? self.filteredCoin[indexPath.row] : viewModel.dataSource.value[indexPath.row]
        cell.config(coin)
        
        return cell
    }
}

extension AllCoinViewController: UITableViewDelegate {

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let leftAction = UIContextualAction(style: .normal, title:  "Add coin", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            
            let selectCoin = self.isFiltering ? self.filteredCoin[indexPath.row] : self.viewModel.dataSource.value[indexPath.row]
            CoreDataManager.shared.saveMyCoinList(selectCoin)
            Alert.presentAlert(title: "", message: "Coin added in your list", vc: self)
            success(true)
        })
        
        leftAction.backgroundColor = Constant.mainGreen
        
        return UISwipeActionsConfiguration(actions: [leftAction])
    }
}

extension AllCoinViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        let searchBar = searchController.searchBar
        filterContentForSearchText(searchBar.text!)
    }
}
