//
//  TabsView.swift
//  Furina
//
//  Created by Peter Subrata on 21/9/2024.
//

import SwiftUI

struct TabsView: View {
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house")
                    Text("Home")
                }
            
            FriendsPage()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("Search")
                }
            
            MissionView()
                .tabItem {
                    Image(systemName: "bell")
                    Text("Notifications")
                }
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person")
                    Text("Profile")
                }
        }
    }
}
