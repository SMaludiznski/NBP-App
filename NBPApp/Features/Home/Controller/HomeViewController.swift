//
//  HomeViewController.swift
//  NBPApp
//
//  Created by Sebastian Maludziński on 27/12/2021.
//

import UIKit

final class HomeViewController: UIViewController {
    
    private lazy var tabBarVc = UITabBarController()
    private lazy var vc1 = TableViewController()
    private lazy var vc2 = TableViewController()
    private lazy var vc3 = TableViewController()
    
    override func loadView() {
        super.loadView()
        setupTabBar()
    }
    
    private func setupTabBar() {
        setupTabViews()
        
        tabBarVc.setViewControllers([UINavigationController(rootViewController: vc1),
                                     UINavigationController(rootViewController: vc2),
                                     UINavigationController(rootViewController: vc3)],
                                    animated: false)
        
        tabBarVc.tabBar.tintColor = .systemBlue.withAlphaComponent(0.8)
        tabBarVc.modalPresentationStyle = .fullScreen
        present(tabBarVc, animated: false)
    }
    
    private func setupTabViews() {
        vc1.title = "Tabela A"
        vc1.apiURL = Constants.tableA
        
        vc2.title = "Tabela B"
        vc2.apiURL = Constants.tableB
        
        vc3.title = "Tabela C"
        vc3.apiURL = Constants.tableC
    }
}
