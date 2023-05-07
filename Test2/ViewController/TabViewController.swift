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
        
        let firstTab = UIViewController()
        firstTab.title = "Первый"
        firstTab.view.backgroundColor = .cyan
        
        let secondTab = UIViewController()
        secondTab.title = "Второй"
        secondTab.view.backgroundColor = .gray
        
        let firstNavController = UINavigationController(rootViewController: firstTab)
        let secondNavController = UINavigationController(rootViewController: secondTab)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [firstNavController, secondNavController]
        
        addChild(tabBarController)
        view.addSubview(tabBarController.view)
        tabBarController.didMove(toParent: self)
    }
}


