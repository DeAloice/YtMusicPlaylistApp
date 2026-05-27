//
//  FeedView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI

struct FeedView: View {
    
    @State private var videos = [Video]()
    @State private var selectedVideo: Video?
    
    var body: some View {
        List(videos) { v in
            VideoRowView(video: v)
                .onTapGesture {
                    selectedVideo = v
                }
                .listRowSeparator(.hidden)
        }
        .listStyle(.plain)
        .scrollIndicators(.hidden)
        .padding(.horizontal)
        .task {
            self.videos = await DataService().getVideos()
        }
        .sheet(item: $selectedVideo) { v in
            VideoDetailView(video: v)
        }
    }
}

#Preview {
    FeedView()
}
