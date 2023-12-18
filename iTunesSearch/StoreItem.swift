//
//  StoreItem.swift
//  iTunesSearch
//
//  Created by Lars Dansie on 12/6/23.
//

import Foundation

struct StoreItem: Codable {
    var name: String
    var artist: String
    var kind: String
    var artworkURL: URL
    var description: String
    
    enum CodingKeys: String, CodingKey {
        case name = "trackName"
        case artist = "artistName"
        case kind
        case artworkURL = "artworkUrl30"
        case description
    }
   
    enum AdditionalKeys: String, CodingKey {
          case longDescription
      }
      
      init(from decoder: Decoder) throws {
          let valueContainer = try decoder.container(keyedBy: CodingKeys.self)
          self.name = try valueContainer.decode(String.self, forKey: CodingKeys.name)
          self.artist = try valueContainer.decode(String.self, forKey: CodingKeys.artist)
          self.kind = try valueContainer.decode(String.self, forKey: CodingKeys.kind)
          self.artworkURL = try valueContainer.decode(URL.self, forKey: CodingKeys.artworkURL)
          
          if let description = try? valueContainer.decode(String.self, forKey: CodingKeys.description) {
              self.description = description
          } else {
              let additionalValues = try decoder.container(keyedBy: AdditionalKeys.self)
              self.description = (try? additionalValues.decode(String.self, forKey: AdditionalKeys.longDescription)) ?? ""
          }
      }
  }

struct SearchResponse: Codable {
    let results: [StoreItem]
}
