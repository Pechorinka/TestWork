//
//  FavouritesViewController.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import Foundation
import UIKit

class FavoritesViewController: UIViewController {
  
  private var favorites: [Favorite] = []
  
  private let tableView: UITableView = {
    let tableView = UITableView()
    tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    tableView.translatesAutoresizingMaskIntoConstraints = false
    return tableView
  }()
  
    override func viewDidLoad() {
      super.viewDidLoad()
      view.backgroundColor = .white
      title = "Favorites"
      setupViews()
    }
    private func setupViews() {
      view.addSubview(tableView)
      
      NSLayoutConstraint.activate([
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
      ])
      
      tableView.delegate = self
      tableView.dataSource = self
    }

}
extension FavoritesViewController: UITableViewDelegate, UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
    let favorite = favorites[indexPath.row]
    cell.textLabel?.text = favorite.query
    cell.imageView?.image = favorite.image
    return cell
  }
  
  func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      favorites.remove(at: indexPath.row)
      tableView.deleteRows(at: [indexPath], with: .fade)
    }
  }
}
