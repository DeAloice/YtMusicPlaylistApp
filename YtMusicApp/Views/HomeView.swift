//
//  HomeView.swift
//  YtMusicApp
//
//  Created by Alice Liu on 27/5/2026.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        TabView {
            FeedView()
        }
        .padding()
    }
}

#Preview {
    HomeView()
}
