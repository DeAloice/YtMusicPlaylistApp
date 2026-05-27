//
//  VideoDetailView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI
import YouTubePlayerKit

struct VideoDetailView: View {
    
    var video: Video
    
    var body: some View {
        
        GeometryReader { proxy in
            VStack (alignment: .leading) {
                // Configure video player
                let youtubePlayer = YouTubePlayer(
                    source: .video(id: video.snippet?.resourceId?.videoId ?? ""),
                    configuration: .init(autoPlay: true)
                )
                
                // Video Player
                YouTubePlayerView(youtubePlayer)
                    .frame(width: proxy.size.width, height: proxy.size.width/1.77778)
                
                // Title and Description
                ScrollView {
                    VStack (alignment: .leading, spacing: 30) {
                        Text(video.snippet?.title ?? "")
                            .font(.headline)
                            .bold()
                        Text(video.snippet?.description ?? "")
                    }
                }
                .scrollIndicators(.hidden)
                .padding()
            }
        }
        
        
    }
}
