//
//  Video.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import Foundation

struct Video: Decodable, Identifiable {
    var id: String {
         snippet?.resourceId?.videoId ?? UUID().uuidString
     }
    
    var snippet: Snippet?
}

struct Snippet:Decodable {
    var title: String
    var description: String
    var thumbnails: Thumbnails?
    var resourceId: ResourceId?
}

struct ResourceId: Decodable {
    var videoId: String
}

struct Thumbnails: Decodable {
    var medium: ThumbnailSize?
}

struct ThumbnailSize: Decodable {
    var url: String
    var width: Int
    var height: Int
}
