//
//  VideoDetailView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI

struct VideoDetailView: View {
    
    var video: Video
    
    var body: some View {
        
        VStack (alignment: .leading) {
            
            // Video Player
            
            
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
