//
//  MainViewControlle.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import UIKit

class MainViewController: UIViewController {
    
    let queryTextField = UITextField()
    let imageView = UIImageView()
    let generateButton = UIButton()
    let favButton = UIButton()
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        queryTextField.borderStyle = .roundedRect
        queryTextField.placeholder = "Введите Ваш запрос"
        queryTextField.backgroundColor = .white
        queryTextField.translatesAutoresizingMaskIntoConstraints = false
        
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
       
        generateButton.setTitle("Сгенерировать", for: .normal)
        generateButton.translatesAutoresizingMaskIntoConstraints = false
        generateButton.backgroundColor = UIColor(named: "Second")
        generateButton.layer.cornerRadius = 10
        generateButton.clipsToBounds = true
        generateButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        generateButton.setTitleColor(UIColor.black, for: .normal)
        generateButton.addTarget(self, action: #selector(generateButtonTapped), for: .touchUpInside)
        
        favButton.setTitle("Добавить в избранное", for: .normal)
        favButton.translatesAutoresizingMaskIntoConstraints = false
        favButton.backgroundColor = UIColor(named: "Second")
        favButton.layer.cornerRadius = 10
        favButton.clipsToBounds = true
        favButton.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        favButton.setTitleColor(UIColor.black, for: .normal)
        favButton.addTarget(self, action: #selector(addToFavoritesButtonTapped), for: .touchUpInside)
        
        view.addSubview(queryTextField)
        view.addSubview(imageView)
        view.addSubview(generateButton)
        view.addSubview(favButton)
        
        NSLayoutConstraint.activate([
            queryTextField.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            queryTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            queryTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            queryTextField.heightAnchor.constraint(equalToConstant: 40),
            
            imageView.topAnchor.constraint(equalTo: queryTextField.bottomAnchor, constant: 20),
            imageView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            imageView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            imageView.bottomAnchor.constraint(equalTo: favButton.topAnchor, constant: -20),
            
            
            favButton.bottomAnchor.constraint(equalTo: generateButton.topAnchor, constant: -20),
            favButton.widthAnchor.constraint(equalToConstant: 300),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            favButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            generateButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            generateButton.widthAnchor.constraint(equalToConstant: 300),
            generateButton.heightAnchor.constraint(equalToConstant: 30),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func generateButtonTapped() {
        guard let query = queryTextField.text, !query.isEmpty else {
            showAlert(withTitle: "Error", message: "Please enter a query")
            return
        }
        
        ImageService.shared.getImage(forQuery: query) { [weak self] (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self?.imageView.image = image
                    self?.imageView.isHidden = false
                case .failure(let error):
                    self?.showAlert(withTitle: "Error", message: error.localizedDescription)
                }
            }
        }
    }
    
    @objc func addToFavoritesButtonTapped() {
        guard let image = imageView.image, let query = queryTextField.text else {
          showAlert(withTitle: "Error", message: "Please generate an image first")
          return
        }
        
        let imageData = image.pngData()
        let url = getFavoritesURL()
        
        do {
          let data = try Data(contentsOf: url)
          var favorites = try JSONDecoder().decode([Favorite].self, from: data)
          
          if favorites.count >= 5 {
            favorites.removeFirst()
          }
          
          let favorite = Favorite(query: query, image: imageData!)
          favorites.append(favorite)
          
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
          
          let jsonData = try encoder.encode(favorites)
          try jsonData.write(to: url)
          
          showAlert(withTitle: "Success", message: "Image added to favorites")
        } catch {
          let message = "Failed to add image to favorites: \(error.localizedDescription)"
          showAlert(withTitle: "Error", message: message)
        }
      }

    
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func getFavoritesURL() -> URL {
      let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
      let favoritesURL = documentsDirectory.appendingPathComponent("favorites.json")
        print(documentsDirectory.path)

      return favoritesURL
    }
    
}
