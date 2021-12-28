//
//  TableViewController.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class TableViewController: UIViewController {
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let parseDataManager: ParseDataManagerProtocol = ParseDataManager()
    
    private lazy var tableView = UITableView()
    private lazy var spinner = LoadingSpinner(style: .medium)
    
    private var currencies: [Rates] = []
    private var effectiveDate: String = ""
    private var currentTable = ""
    
    var apiURL: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        downloadCurrencies()
    }
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        setupTableView()
        
        view.backgroundColor = .white
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(downloadCurrencies))
        
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(CurrencyCell.self, forCellReuseIdentifier: CurrencyCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .white
    }
    
    @objc private func downloadCurrencies() {
        startSpinnerLoading()
        
        networkManager.downloadData(from: apiURL) { [weak self] (completion) in
            switch completion {
            case .success(let data):
                self?.generateCurrenciesFrom(data: data)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    private func generateCurrenciesFrom(data: Data) {
        do {
            let decodedData = try parseDataManager.parseData(from: data, expecting: [CurrenciesTable].self)
            reloadViewWith(decodedData)
        } catch {
            showError(error)
        }
    }
    
    private func reloadViewWith(_ data: [CurrenciesTable]) {
        guard let data = data.first else { return }
        
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            
            self.currencies = data.rates
            self.effectiveDate = data.effectiveDate
            self.currentTable = data.table
            
            self.title = "Tabela \(data.table)"
            self.tableView.reloadData()
            self.stopSpinnerLoading()
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else  { return }
            
            let alertVc = UIAlertController(title: "Błąd", message: error.localizedDescription, preferredStyle: .alert)
            alertVc.addAction(UIAlertAction(title: "Anuluj", style: .destructive, handler: { _ in
                self.stopSpinnerLoading()
            }))
            
            alertVc.addAction(UIAlertAction(title: "Ośwież", style: .default, handler: { _ in
                self.downloadCurrencies()
                self.startSpinnerLoading()
            }))
            self.present(alertVc, animated: true)
        }
    }
    
    private func startSpinnerLoading() {
        spinner.startAnimating()
        tableView.isHidden = true
    }
    
    private func stopSpinnerLoading() {
        spinner.stopAnimating()
        tableView.isHidden = false
    }
}

//MARK: - Setup TableView
extension TableViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyCell.identifier, for: indexPath) as? CurrencyCell else {
            fatalError()
        }
        
        cell.configureCellWith(currency: currencies[indexPath.row], date: effectiveDate)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = CurrencyDetailViewController()
        vc.hidesBottomBarWhenPushed = true
        vc.configureViewWith(currency: currencies[indexPath.row], table: currentTable)
        navigationController?.pushViewController(vc, animated: true)
    }
}
