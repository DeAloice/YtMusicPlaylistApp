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
    
    @State private var playbackTask: Task<Void, Never>?
    @State private var currentDuration: Int = 0
    @State private var totalDuration: Int = 0

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
                await loadNextBatch()
            }
            
            guard batchIndex < currentBatch.count else { return }
            
            let video = currentBatch[batchIndex]
            batchIndex += 1
            
            let id = video.snippet?.resourceId?.videoId ?? ""
            
            let duration = await DataService().getVidDuration(vidId: id)
            currentDuration = duration
            totalDuration = duration
            
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
        
        playbackTask?.cancel()
        
        playbackTask = Task {
            while !Task.isCancelled {
                try? await Task.sleep(for: .seconds(1))
                
                guard let player else { continue }
                
                do {
                    let currentTime = try await player.getCurrentTime()
                    
                    if currentTime.value >= Double(currentDuration - 1) || currentTime.value >= Double(totalDuration) {
                        await MainActor.run {
                            playNext()
                        }
                        
                        return
                    }
                } catch {
                    print("problem scheduling next song: ", error)
                }
            }
        }
    }
}
