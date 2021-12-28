//
//  LoadingSpinner.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class LoadingSpinner: UIActivityIndicatorView {
    
    override init(style: UIActivityIndicatorView.Style) {
        super.init(style: style)
        setupView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupView() {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.hidesWhenStopped = true
        self.isHidden = true
    }
}
