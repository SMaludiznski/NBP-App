//
//  CurrencyValueCell.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class CurrencyValueCell: UITableViewCell {
    
    static let identifier: String = "CurrencyValueCell"
    
    private lazy var cellContainer: UIView = {
        let cellContainer = UIView()
        cellContainer.translatesAutoresizingMaskIntoConstraints = false
        cellContainer.layer.borderColor = UIColor.darkGray.cgColor
        cellContainer.layer.borderWidth = 0.5
        cellContainer.layer.cornerRadius = 10
        return cellContainer
    }()
    
    private lazy var informationLabel: StandardLabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 14, weight: .light)
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.selectionStyle = .none
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(cellContainer)
        cellContainer.addSubview(informationLabel)
        
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            cellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            
            informationLabel.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 10),
            informationLabel.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 10),
            informationLabel.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -10),
            informationLabel.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -10),
        ])
    }
    
    func configureCellWith(currencyValue currency: CurrencyRates) {
        if let mid = currency.mid {
            let midValue = String(format: "%.2f", mid)
            informationLabel.text = "Wartość kursu w dniu \(currency.effectiveDate) wynosiła \(midValue) PLN"
        }
        
        if let bid = currency.bid, let ask = currency.ask {
            let bidValue = String(format: "%.2f", bid)
            let askValue = String(format: "%.2f", ask)
            informationLabel.text = "Wartość kursu kupna w dniu \(currency.effectiveDate) wynosiła \(bidValue) PLN, a sprzedaży \(askValue) PLN"
        }
    }
}
