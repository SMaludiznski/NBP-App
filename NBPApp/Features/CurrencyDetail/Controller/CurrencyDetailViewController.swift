//
//  CurrencyDetailViewController.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class CurrencyDetailViewController: UIViewController {
    
    private lazy var tableView = UITableView()
    
    private let networkManager: NetworkManagerProtocol = NetworkManager()
    private let parseDataManager: ParseDataManagerProtocol = ParseDataManager()
    
    private var apiURL = ""
    private var currentTable = ""
    private var currency: Rates? = nil
    private var currencyValues: [CurrencyRates] = []
    
    private lazy var spinner: LoadingSpinner = LoadingSpinner(style: .medium)
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 10
        return stackView
    }()
    
    private lazy var firstDateLabel: DateLabel = DateLabel()
    private lazy var firstDatePicker: DatePicker = DatePicker()
    
    private lazy var lastDateLabel: DateLabel = DateLabel()
    private lazy var lastDatePicker: DatePicker = DatePicker()
    
    private lazy var downloadButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.layer.cornerRadius = 10
        button.setTitle("Wczytaj dane", for: .normal)
        button.addTarget(self, action: #selector(downloadCurrencyValues), for: .touchUpInside)
        return button
    }()
    
    override func loadView() {
        super.loadView()
        setupView()
    }
    
    private func setupView() {
        setupTableView()
        setupDateForm()
        
        view.backgroundColor = .white
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: #selector(downloadCurrencyValues))
        
        view.addSubview(stackView)
        stackView.addArrangedSubview(firstDateLabel)
        stackView.addArrangedSubview(firstDatePicker)
        
        stackView.addArrangedSubview(lastDateLabel)
        stackView.addArrangedSubview(lastDatePicker)
        
        view.addSubview(downloadButton)
        
        view.addSubview(tableView)
        view.addSubview(spinner)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 10),
            stackView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            
            downloadButton.topAnchor.constraint(equalTo: stackView.bottomAnchor, constant: 15),
            downloadButton.widthAnchor.constraint(equalToConstant: 160),
            downloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            tableView.topAnchor.constraint(equalTo: downloadButton.bottomAnchor, constant: 15),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 15),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -15),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            spinner.centerXAnchor.constraint(equalTo: tableView.centerXAnchor),
            spinner.centerYAnchor.constraint(equalTo: tableView.centerYAnchor)
        ])
    }
    
    private func setupTableView() {
        tableView.register(CurrencyValueCell.self, forCellReuseIdentifier: CurrencyValueCell.identifier)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.showsVerticalScrollIndicator = false
        tableView.backgroundColor = .white
    }
    
    private func setupDateForm() {
        firstDateLabel.text = "Wybierz początkową datę:"
        lastDateLabel.text = "Wybierz końcową datę:"
        
        lastDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
        firstDatePicker.addTarget(self, action: #selector(datePickerValueChanged), for: .valueChanged)
    }
    
    @objc private func datePickerValueChanged(_ sender: UIDatePicker) {
        if lastDatePicker.date < firstDatePicker.date {
            firstDatePicker.date = lastDatePicker.date
        }
    }
    
    func configureViewWith(currency: Rates, table: String) {
        self.currency = currency
        self.currentTable = table
        self.title = currency.currency.capitalized
    }
    
    @objc private func downloadCurrencyValues() {
        startSpinnerLoading()
        generateApiUrl()
        
        networkManager.downloadData(from: apiURL) { [weak self] (completion) in
            switch completion {
            case .success(let data):
                self?.generateValuesFrom(data: data)
            case .failure(let error):
                self?.showError(error)
            }
        }
    }
    
    private func generateApiUrl() {
        guard let code = currency?.code else { return }
        let firstDate = firstDatePicker.date.formatIntoString()
        let lastDate = lastDatePicker.date.formatIntoString()
        
        apiURL = "\(Constants.apiCurrencyURL)/\(currentTable)/\(code)/\(firstDate)/\(lastDate)"
    }
    
    private func generateValuesFrom(data: Data) {
        do {
            let decodedData = try parseDataManager.parseData(from: data, expecting: CurrencyValues.self)
            reloadViewWith(values: decodedData.rates)
        } catch {
            showError(error)
        }
    }
    
    private func reloadViewWith(values: [CurrencyRates]) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else  { return }
            self.currencyValues = values
            self.tableView.reloadData()
            self.stopSpinnerLoading()
        }
    }
    
    private func showError(_ error: Error) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else  { return }
            
            self.spinner.stopAnimating()
            
            let vc = UIAlertController(title: "Błąd", message: error.localizedDescription, preferredStyle: .alert)
            vc.addAction(UIAlertAction(title: "Ok", style: .default, handler: { _ in
                self.stopSpinnerLoading()
                self.currencyValues = []
                self.tableView.reloadData()
            }))
            self.present(vc, animated: true)
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
extension CurrencyDetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencyValues.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CurrencyValueCell.identifier, for: indexPath) as? CurrencyValueCell else {
            fatalError()
        }
        
        cell.configureCellWith(currencyValue: currencyValues[indexPath.row])
        return cell
    }
}

