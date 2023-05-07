//
//  FavouritesViewController.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 06.05.2023.
//

import Foundation
import UIKit


class FirstViewController: UIViewController {
    
    lazy var textField: UITextField = {
        let label = UITextField()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont(name: "Phosphate-Solid", size: 24)
        label.textColor = .white
        return label
    } ()

}
