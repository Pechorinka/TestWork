//
//  ImageService.swift
//  Test2
//
//  Created by Tatyana Sidoryuk on 07.05.2023.
//

import Foundation
import UIKit

class ImageService {
  static let shared = ImageService()
  
  private let baseURL = URL(string: "https://dummyimage.com/")!
  
  func getImage(forQuery query: String, completion: @escaping (Result<UIImage, Error>) -> Void) {
    let size = "500x500"
    let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    let urlString = "\(baseURL)\(size)&text=\(text)"
    let url = URL(string: urlString)!
    
    let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
      if let error = error {
        completion(.failure(error))
        return
      }
      
      guard let data = data else {
        completion(.failure(NSError(domain: "ImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Empty response"])))
        return
      }
      
      if let image = UIImage(data: data) {
        completion(.success(image))
      } else {
        completion(.failure(NSError(domain: "ImageService", code: 0, userInfo: [NSLocalizedDescriptionKey: "Failed to decode image"])))
      }
    }
    
    task.resume()
  }
}

