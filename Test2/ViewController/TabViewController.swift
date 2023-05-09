//
//  ViewController.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 06.05.2023.
//

import UIKit
import Foundation

class TabViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let firstTab = MainViewController()
        firstTab.title = "Главная"
        firstTab.tabBarItem.image = UIImage(systemName: "heart")
        firstTab.tabBarItem.selectedImage = UIImage(systemName: "heart.fill")
        firstTab.tabBarItem.badgeColor = UIColor(named: "Second")
        firstTab.view.backgroundColor = UIColor(named: "First")
    
        
        let secondTab = FavoritesTableViewController()
        secondTab.title = "Избранное"
        secondTab.tabBarItem.image = UIImage(systemName: "star")
        secondTab.tabBarItem.selectedImage = UIImage(systemName: "star.fill")
        secondTab.view.backgroundColor = UIColor(named: "First")
        
        let firstNavController = UINavigationController(rootViewController: firstTab)
        let secondNavController = UINavigationController(rootViewController: secondTab)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController]
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
        
        let attributes1: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.white
        ]
        let attributes2: [NSAttributedString.Key: Any] = [
            .font: UIFont.systemFont(ofSize: 18),
            .foregroundColor: UIColor.black
        ]


        UITabBarItem.appearance().setTitleTextAttributes(attributes1, for: .selected)
        UITabBarItem.appearance().setTitleTextAttributes(attributes2, for: .normal)
        
        firstTab.updates = {
            [weak self] in
            guard self != nil else { return }
            secondTab.loadData()
        }
    }
}


