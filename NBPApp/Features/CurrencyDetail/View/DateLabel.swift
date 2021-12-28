//
//  DateLabel.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class DateLabel: UILabel {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.font = .systemFont(ofSize: 14, weight: .bold)
        self.textAlignment = .center
        self.numberOfLines = 0
        self.textColor = .black
    }
}
