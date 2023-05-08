//
//  Favourite.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import Foundation
import UIKit

class Favorite: Codable {
  let query: String
  let image: Data
  
  init(query: String, image: Data) {
    self.query = query
    self.image = image
  }
}
