//
//  DataService.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import Foundation

struct DataService {
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func getVideos() async -> [Video] {
        // Check if API Key is there
        guard apiKey != nil else {
            return [Video]()
        }
        
        // Create the URL
        let urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL9JORvWWogAhBf-wLGJ7vcCs-ZUNNdsJR&maxResults=15&key=\(apiKey!)"
        let url = URL(string: urlString)
        
        if let url = url {
            // Create the request
            let request = URLRequest(url: url)
            let session = URLSession.shared
            
            // Send the request
            do {
                // since async method need to await
                let (data, _) = try await session.data(for: request)
                
                // Parse the data
                let decoder = JSONDecoder()
                let playlist = try decoder.decode(Playlist.self, from: data)
                
                return playlist.items
            }
            catch {
                print(error)
            }
        }
       
        return [Video]()
    }
}
