//
//  VideoRowView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI

struct VideoRowView: View {
    
    var video: Video
    
    var body: some View {
        
        VStack (alignment: .leading) {
            if let url = URL(string: video.snippet?.thumbnails?.medium?.url ?? "") {
                
                AsyncImage(url: url) { image in
                    // Image that is displayed
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .clipShape(RoundedRectangle(cornerRadius: 5))
                } placeholder: {
                    ProgressView()
                }
            }
            Text(video.snippet?.title ?? "")
                .bold()
        }
        .padding(.vertical)
    }
}
