//
//  DataService.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import Foundation

struct PlaylistResponse: Decodable {
    let items: [Video]
    let nextPageToken: String?
}

struct DataService {
    private let apiKey = Bundle.main.infoDictionary?["API_KEY"] as? String
    
    func getVideos(pageToken: String?) async -> PlaylistResponse {
        // Check if API Key is there
        guard apiKey != nil else {
            return PlaylistResponse(items: [], nextPageToken: nil)
        }
        
        // Create the URL
        var urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL9JORvWWogAhBf-wLGJ7vcCs-ZUNNdsJR&maxResults=15&key=\(apiKey!)"
        
        if let pageToken {
            urlString += "&pageToken=\(pageToken)"
        }
        
        guard let url = URL(string: urlString) else {
            return PlaylistResponse(items: [], nextPageToken: nil)
        }
        
       
        // Send the request
        do {
            // since async method need to await
            let (data, _) = try await URLSession.shared.data(from: url)
            
            // Parse the data
            let decoder = JSONDecoder()
            
            return try decoder.decode(PlaylistResponse.self, from: data)
        }
        catch {
            print(error)
        }
       
        return PlaylistResponse(items: [], nextPageToken: nil)
    }
}
