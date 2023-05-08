//
//  FavouritesViewController.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import Foundation
import UIKit

class FavoritesTableViewController: UITableViewController {
  private var favorites: [Favorite] = []
  
  override func viewDidLoad() {
    super.viewDidLoad()
    loadData()
  }
  
  private func loadData() {
    do {
      let url = getFavoritesURL()
      let data = try Data(contentsOf: url)
      let favorites = try JSONDecoder().decode([Favorite].self, from: data)
      self.favorites = favorites
      tableView.reloadData()
    } catch {
      let message = "Failed to load favorites: \(error.localizedDescription)"
      showAlert(withTitle: "Error", message: message)
    }
  }
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return favorites.count
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "FavoriteCell", for: indexPath)
    let favorite = favorites[indexPath.row]
    cell.textLabel?.text = favorite.query
 //   cell.imageView?.image = UIImage(data: favorite.image)
    return cell
  }
  
  override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    if editingStyle == .delete {
      favorites.remove(at: indexPath.row)
        do {
          let encoder = JSONEncoder()
          encoder.outputFormatting = .prettyPrinted
          
          let jsonData = try encoder.encode(favorites)
          let url = getFavoritesURL()
          try jsonData.write(to: url)
          
          tableView.deleteRows(at: [indexPath], with: .fade)
        } catch {
          let message = "Failed to delete favorite: \(error.localizedDescription)"
          showAlert(withTitle: "Error", message: message)
        }
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
      return favoritesURL
    }
  }

