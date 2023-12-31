//
//  StoreItemController.swift
//  iTunesSearch
//
//  Created by Lars Dansie on 12/6/23.
//

import Foundation

class StoreItemController {
    
    enum StoreItemError: Error, LocalizedError {
        case itemsNotFound
    }
    
    func fetchItems(matching query: [String: String]) async throws -> [StoreItem] {
        var urlComponents = URLComponents(string: "https://itunes.apple.com/search")!
        urlComponents.queryItems = query.map { URLQueryItem(name: $0.key,
               value: $0.value) }
            let (data, response) = try await URLSession.shared.data(from:
               urlComponents.url!)
                guard let httpResponse = response as? HTTPURLResponse,
                   httpResponse.statusCode == 200 else {
                throw StoreItemError.itemsNotFound
            }
        
            let decoder = JSONDecoder()
            let searchResponse = try decoder.decode(SearchResponse.self,
               from: data)
        
            return searchResponse.results
        }
    func fetchArtwork(for item: StoreItem) async throws -> Data {
            let url = item.artworkURL

            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                return data
            } catch {
                throw error
            }
        }
}
