//
//  FeedView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI
import YouTubePlayerKit

struct FeedView: View {
    @State private var pageToken: String? = nil
    @State private var hasReachedEnd = false
    
    @State private var currentBatch: [Video] = []
    @State private var batchIndex:Int = 0
    
    @State private var player: YouTubePlayer?

    var body: some View {
        Group {
            if let player {
                YouTubePlayerView(player)
                    .ignoresSafeArea()
            } else {
                ProgressView("Loading...")
            }
        }
        .task {
            await loadNextBatch()
            playNext()
        }
    }
    
    // Load next 15 videos in playlist
    private func loadNextBatch() async {
        let response = await DataService().getVideos(pageToken: pageToken)
        
        pageToken = response.nextPageToken
        
        if response.items.isEmpty || response.nextPageToken == nil {
            hasReachedEnd = true
        }
        
        currentBatch = response.items.shuffled()
        batchIndex = 0
    }
    
    // Play next video
    private func playNext() {
        Task {
            if batchIndex >= currentBatch.count {
                if hasReachedEnd {
                    pageToken = nil
                    hasReachedEnd = false
                }
                
                await loadNextBatch()
            }
            
            guard batchIndex < currentBatch.count else { return }
            
            let video = currentBatch[batchIndex]
            batchIndex += 1
            
            let id = video.snippet?.resourceId?.videoId ?? ""
            
            if player == nil {
                player = YouTubePlayer(
                    source: .video(id: id),
                    configuration: .init(autoPlay: true)
                )
            } else {
                try? await player?.load(source: .video(id: id))
                try? await player?.play()
            }
            
            scheduleNext()
        }
    }
    
    private func scheduleNext() {
        Task {
            try? await Task.sleep(for: .seconds(210))

            await MainActor.run {
                playNext()
            }
        }
    }
}
