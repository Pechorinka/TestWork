//
//  MainViewControlle.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import Foundation
import UIKit

class MainViewController: UIViewController {
  
  private let queryTextField: UITextField = {
    let textField = UITextField()
    textField.borderStyle = .roundedRect
    textField.placeholder = "Enter query"
    textField.translatesAutoresizingMaskIntoConstraints = false
    return textField
  }()
  
  private let generateButton: UIButton = {
    let button = UIButton(type: .system)
    button.setTitle("Generate", for: .normal)
    button.translatesAutoresizingMaskIntoConstraints = false
    return button
  }()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        title = "Image Search"
        setupViews()
      }

    private func setupViews() {
      view.addSubview(queryTextField)
      view.addSubview(generateButton)
      
      NSLayoutConstraint.activate([
        queryTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
        queryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
        queryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
        queryTextField.heightAnchor.constraint(equalToConstant: 40),
        
        generateButton.topAnchor.constraint(equalTo: queryTextField.bottomAnchor, constant: 16),
        generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        generateButton.heightAnchor.constraint(equalToConstant: 40)
      ])
    }
    
    private func generateImage(query: String, completion: @escaping (UIImage?, Error?) -> Void) {
      let imageSize = UserDefaults.standard.string(forKey: "imageSize") ?? "500x500"
      let urlString = "https://dummyimage.com/\(imageSize)&text=\(query)"
      let url = URL(string: urlString)!
      let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
        if let error = error {
          completion(nil, error)
          return
        }
        if let data = data, let image = UIImage(data: data) {
          completion(image, nil)
        } else {
          completion(nil, NSError(domain: "ImageSearch", code: 1, userInfo: nil))
        }
      }
      task.resume()
    }


}

