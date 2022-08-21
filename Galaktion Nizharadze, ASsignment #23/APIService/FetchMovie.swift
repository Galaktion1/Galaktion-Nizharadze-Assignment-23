//
//  FetchMovie.swift
//  Galaktion Nizharadze, ASsignment #23
//
//  Created by Gaga Nizharadze on 21.08.22.
//

import Foundation


import Foundation

class TVShowFetch {
    
    
    
    private let baseAPIURL = "https://api.themoviedb.org/3/tv/"
    private let urlSession = URLSession.shared
    
    let parameter = ["api_key": "07b3c5721acb723e40379334a99591ef"]
    
    
    
    func fetchMovies<T: Decodable>(from endpoint: EndPoint, afterID: String?, completion: @escaping (Result<T, Error>) -> Void) {
        var urlString = baseAPIURL + endpoint.value
        
        if let afterID = afterID {
            urlString += afterID
        }
        
        var urlComponents = URLComponents(string: urlString)
        
        var queryItems = [URLQueryItem]()
        for (key, value) in parameter {
            queryItems.append(URLQueryItem(name: key, value: value))
        }
        
        urlComponents?.queryItems = queryItems
        
        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse, 200..<300 ~= httpResponse.statusCode else {
                
                print(response!)
                return
            }
            
            if let error = error {
                completion(.failure(error))
                
                print("\(error)")
            }
            
            guard let data = data else {
                return
            }
            
            do {
                let decoder = JSONDecoder()
                let jsonData = try decoder.decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(jsonData))
                }
            }
            catch  {
                completion(.failure(error))
                print(error)
                
            }
            
        }.resume()
    }
}
