//
//  VideoDetailsResponse.swift
//  YtMusicApp
//
//  Created by Alice Liu on 30/5/2026.
//

import Foundation

struct VideoDetailsResponse: Decodable {
    let items: [VideoDetails]
}

struct VideoDetails: Decodable {
    let contentDetails: ContentDetails
}

struct ContentDetails: Decodable {
    let duration: String
}
