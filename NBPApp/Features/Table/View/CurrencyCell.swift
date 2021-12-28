//
//  CurrencyCell.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class CurrencyCell: UITableViewCell {
    
    static let identifier = "CurrencyCell"
    
    private lazy var cellContainer: UIView = {
        let vc = UIView()
        vc.translatesAutoresizingMaskIntoConstraints = false
        vc.backgroundColor = .white
        vc.layer.cornerRadius = 10
        vc.layer.shadowRadius = 4
        vc.layer.shadowColor = UIColor.black.cgColor
        vc.layer.shadowOpacity = 0.15
        vc.layer.shadowOffset = CGSize(width: 2, height: 2)
        return vc
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.spacing = 6
        return stackView
    }()
    
    private lazy var nameLabel = StandardLabel()
    
    private lazy var dateLabel: StandardLabel = {
        let label = StandardLabel()
        label.font = .systemFont(ofSize: 12)
        return label
    }()
    
    private lazy var currencyValue: StandardLabel = {
        let label = StandardLabel()
        label.textColor = .darkGray
        label.font = .systemFont(ofSize: 12, weight: .light)
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
        
        cellContainer.addSubview(stackView)
        stackView.addArrangedSubview(nameLabel)
        stackView.addArrangedSubview(dateLabel)
        stackView.addArrangedSubview(currencyValue)
        
        NSLayoutConstraint.activate([
            cellContainer.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            cellContainer.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 5),
            cellContainer.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -5),
            cellContainer.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            
            stackView.topAnchor.constraint(equalTo: cellContainer.topAnchor, constant: 5),
            stackView.leadingAnchor.constraint(equalTo: cellContainer.leadingAnchor, constant: 5),
            stackView.trailingAnchor.constraint(equalTo: cellContainer.trailingAnchor, constant: -5),
            stackView.bottomAnchor.constraint(equalTo: cellContainer.bottomAnchor, constant: -5),
        ])
    }
    
    func configureCellWith(currency: Rates, date: String) {
        nameLabel.text = currency.currency.capitalized + " - " + currency.code
        dateLabel.text = date
        
        if let mid = currency.mid {
            let midValue = String(format: "%.2f", mid)
            currencyValue.text = "Średnia watość kursu wynosi: \(midValue) PLN"
        }
        
        if let bid = currency.bid, let ask = currency.ask {
            let bidValue = String(format: "%.2f", bid)
            let askValue = String(format: "%.2f", ask)
            currencyValue.text = "Wartość kupna wynosi: \(bidValue) PLN, a wartość sprzedaży: \(askValue) PLN"
        }
    }
}

