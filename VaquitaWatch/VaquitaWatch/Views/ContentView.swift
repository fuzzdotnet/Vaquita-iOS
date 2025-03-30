import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab = 0
    
    var body: some View {
        TabView(selection: $selectedTab) {
            HomeView(selectedTab: $selectedTab)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(0)
            
            VaquitaAvatarView()
                .tabItem {
                    Label("Your Vaquita", systemImage: "sparkles")
                }
                .tag(1)
            
            ChallengesView()
                .tabItem {
                    Label("Challenges", systemImage: "star.fill")
                }
                .tag(2)
            
            MapView()
                .tabItem {
                    Label("Map", systemImage: "map.fill")
                }
                .tag(3)
            
            MissionView()
                .tabItem {
                    Label("Mission", systemImage: "info.circle.fill")
                }
                .tag(4)
        }
        .accentColor(Color("tealAccent"))
        .onAppear {
            // When app appears, update vaquita happiness
            var updatedVaquita = appState.userVaquita
            updatedVaquita.updateHappiness()
            appState.userVaquita = updatedVaquita
            
            // Check if we need to get a new daily fact
            if appState.currentFact == nil {
                appState.setDailyFact()
            }
        }
    }
} 