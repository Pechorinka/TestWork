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
    var updates: (() -> Void)?
    
    
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
            imageView.bottomAnchor.constraint(equalTo: generateButton.topAnchor, constant: -20),
            
            
            generateButton.bottomAnchor.constraint(equalTo: favButton.topAnchor, constant: -20),
            generateButton.widthAnchor.constraint(equalToConstant: 300),
            generateButton.heightAnchor.constraint(equalToConstant: 30),
            generateButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            favButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            favButton.widthAnchor.constraint(equalToConstant: 300),
            favButton.heightAnchor.constraint(equalToConstant: 30),
            favButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    @objc func generateButtonTapped() {
        let url = getFavoritesURL()
        var tag = false
        
        guard let query = queryTextField.text, !query.isEmpty else {
            showAlert(withTitle: "Error", message: "Please enter a query")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            
            do {
                let favorites = try JSONDecoder().decode([Favorite].self, from: data)

                if favorites.count > 0 {
                    for i in 0...favorites.count-1 {
                        if favorites[i].query == query {
                            showAlert(withTitle: "Ошибка", message: "Такая картинка уже была сгенерирована и находится в избранном")
                            tag = true
                        }
                    }
                }
            } catch {
                let message = "Нет доступа к избранному: \(error.localizedDescription)"
                showAlert(withTitle: "Ошибка", message: message)
                  print(String(describing: error))
              }
        } catch {
            print("Невозможно декодировать Избранное: \(error.localizedDescription)")
        }
        
        if tag == false {
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
    }
    
    @objc func addToFavoritesButtonTapped() {
        guard let image = imageView.image, let query = queryTextField.text else {
          showAlert(withTitle: "Error", message: "Please generate an image first")
          return
        }
        
        let imageData = image.pngData()
        let url = getFavoritesURL()
        print(url)
        
        do {
          let data = try Data(contentsOf: url)

            do {
                var favorites = try JSONDecoder().decode([Favorite].self, from: data)

            if favorites.count >= Constants.maxFav {
            favorites.removeFirst()
          }
          
          let favorite = Favorite(query: query, image: imageData!)
          favorites.append(favorite)
          
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
          
          let jsonData = try encoder.encode(favorites)
                do { try jsonData.write(to: url)} catch {
                    let message = "Не получилось записать в файл: \(error.localizedDescription)"
                    showAlert(withTitle: "Error", message: message)
                }
        
          
          showAlert(withTitle: "Успех", message: "Картинка добавлена в избранное")
                self.updates?()
                
        } catch {
          let message = "Не удалось добавить картинку в избранное: \(error.localizedDescription)"
          showAlert(withTitle: "Ошибка", message: message)
            print(String(describing: error))
        }
        } catch {
            print("Error decoding favorites: \(error.localizedDescription)")
        }
      }

    
    private func showAlert(withTitle title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func getFavoritesURL() -> URL {
     //   guard let resourceURL = Bundle.main.resourceURL
        let resourceURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

        let favoritesURL = resourceURL.appendingPathComponent("favorites.json")
        return favoritesURL
    }
    
}
