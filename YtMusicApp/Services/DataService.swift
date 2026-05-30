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
        var urlString = "https://www.googleapis.com/youtube/v3/playlistItems?part=snippet&playlistId=PL9JORvWWogAhBf-wLGJ7vcCs-ZUNNdsJR&maxResults=50&key=\(apiKey!)"
        
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
    
    func getVidDuration(vidId: String) async -> Int {
        // check apiKey is there
        guard let apiKey else {
            return 30
        }
        
        // Create url
        let urlString =
            "https://www.googleapis.com/youtube/v3/videos?part=contentDetails&id=\(vidId)&key=\(apiKey)"
        
        guard let url = URL(string: urlString) else {
            return 30
        }
        
        // send the request
        do {
            // Parse data and return successful duration int
            let (data, _) = try await URLSession.shared.data(from: url)
            
            let response = try JSONDecoder().decode(VideoDetailsResponse.self, from: data)
            guard let durationString = response.items.first?.contentDetails.duration else {
                return 30
            }
            
            return parseDuration(durationString)
        }
        catch {
            print(error)
            return 30
        }
    }
    
    func parseDuration(_ iso: String) -> Int {
        var total = 0
        var number = ""
        
        for char in iso {
            if char.isNumber {
                number.append(char)
            } else {
                let value = Int(number) ?? 0
                switch char {
                case "H":
                    total += value * 3600
                case "M":
                    total += value * 60
                case "S":
                    total += value
                default:
                    break
                }
                
                number = ""
            }
        }
        
        return total
    }
}
