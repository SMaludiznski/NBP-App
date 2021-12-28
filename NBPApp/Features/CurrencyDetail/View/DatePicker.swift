//
//  DatePicker.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class DatePicker: UIDatePicker {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.maximumDate = Date()
        self.minimumDate = Calendar.current.date(from: getMinimumDate())
        self.datePickerMode = .date
        self.contentHorizontalAlignment = .center
        self.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func getMinimumDate() -> DateComponents {
        var dateComponents = DateComponents()
        dateComponents.year = 2001
        dateComponents.month = 1
        dateComponents.day = 2
        
        return dateComponents
    }
}
