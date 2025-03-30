import SwiftUI

struct HomeView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingDonationOptions = false
    @Binding var selectedTab: Int
    
    var body: some View {
        ZStack {
            // Background with subtle wave animation
            OceanBackgroundView()
            
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    HStack {
                        Text("Today's Vaquita Fact")
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                            .foregroundColor(.primary)
                        
                        Spacer()
                        
                        // Check-in streak indicator
                        if appState.checkInStreak > 0 {
                            HStack(spacing: 4) {
                                Image(systemName: "flame.fill")
                                    .foregroundColor(.orange)
                                Text("\(appState.checkInStreak)")
                                    .fontWeight(.semibold)
                            }
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.top)
                    
                    // Daily fact card
                    if let fact = appState.currentFact {
                        FactCardView(fact: fact)
                            .padding(.horizontal)
                    } else {
                        // Placeholder if no fact is loaded
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color(.systemGray5))
                            .frame(height: 200)
                            .padding(.horizontal)
                            .overlay(
                                Text("Loading today's fact...")
                                    .foregroundColor(.secondary)
                            )
                    }
                    
                    // Care for your Vaquita button
                    Button(action: {
                        // Navigate to avatar screen
                        selectedTab = 1
                    }) {
                        HStack {
                            Image(systemName: "heart.fill")
                                .foregroundColor(.white)
                            Text("Care for Your Vaquita")
                                .font(.headline)
                                .foregroundColor(.white)
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.tealAccent)
                        .cornerRadius(16)
                        .shadow(radius: 2)
                    }
                    .padding(.horizontal)
                    
                    // CTA buttons
                    VStack(spacing: 16) {
                        Button(action: {
                            showingDonationOptions = true
                        }) {
                            HStack {
                                Image(systemName: "heart.circle.fill")
                                    .foregroundColor(Color.coralAccent)
                                Text("Become a Guardian")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                        
                        Button(action: {
                            // Navigate to mission screen
                            selectedTab = 4
                        }) {
                            HStack {
                                Image(systemName: "info.circle.fill")
                                    .foregroundColor(Color.oceanBlue)
                                Text("Our Mission")
                                    .font(.headline)
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.system(.body, design: .rounded))
                                    .foregroundColor(.secondary)
                            }
                            .padding()
                            .background(Color(.systemBackground))
                            .cornerRadius(16)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Quick impact stats
                    ImpactStatsSummaryView()
                        .padding(.horizontal)
                        .padding(.bottom, 24)
                }
            }
        }
        .sheet(isPresented: $showingDonationOptions) {
            DonationView()
        }
        .navigationTitle("Vaquita Watch")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Ocean background with subtle wave animation
struct OceanBackgroundView: View {
    @State private var animationAmount: CGFloat = 0
    
    var body: some View {
        ZStack {
            LinearGradient(
                gradient: Gradient(colors: [
                    Color.oceanLightBlue,
                    Color.oceanDarkBlue
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .edgesIgnoringSafeArea(.all)
            
            // Wave effect
            VStack {
                Spacer()
                    .frame(height: 100)
                
                ZStack {
                    ForEach(0..<3) { i in
                        SineWave(frequency: Double(i + 1) * 0.5, amplitude: 10 - Double(i) * 2)
                            .stroke(Color.white.opacity(0.3 - Double(i) * 0.1), lineWidth: 2)
                            .offset(x: CGFloat(i * 10), y: animationAmount + CGFloat(i * 5))
                    }
                }
                .frame(height: 50)
                .mask(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.white.opacity(0.1), Color.white]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(Animation.linear(duration: 8).repeatForever(autoreverses: false)) {
                animationAmount = 360
            }
        }
    }
}

// A simple sine wave shape
struct SineWave: Shape {
    var frequency: Double
    var amplitude: Double
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath()
        
        let width = Double(rect.width)
        let height = Double(rect.height)
        let midHeight = height / 2
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        for x in stride(from: 0, through: width, by: 1) {
            let angle = 2 * .pi * x / width * frequency
            let y = sin(angle) * amplitude + midHeight
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        return Path(path.cgPath)
    }
}

// Fact card view component
struct FactCardView: View {
    let fact: VaquitaFact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Category badge
            Text(fact.category.rawValue)
                .font(.caption)
                .fontWeight(.semibold)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .background(categoryColor(fact.category).opacity(0.2))
                .foregroundColor(categoryColor(fact.category))
                .cornerRadius(8)
            
            // Title
            Text(fact.title)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            // Optional image
            if let imageAsset = fact.imageAsset {
                Image(imageAsset)
                    .resizable()
                    .scaledToFit()
                    .cornerRadius(12)
                    .padding(.vertical, 4)
            }
            
            // Content
            Text(fact.content)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Learn more link if available
            if let url = fact.learnMoreURL {
                Link(destination: url) {
                    Text("Learn more")
                        .font(.subheadline)
                        .foregroundColor(Color.tealAccent)
                }
                .padding(.top, 4)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 10)
    }
    
    // Return different colors based on fact category
    private func categoryColor(_ category: FactCategory) -> Color {
        switch category {
        case .biology:
            return Color.oceanBlue
        case .conservation:
            return Color.tealAccent
        case .habitat:
            return Color.green
        case .threats:
            return Color.coralAccent
        case .history:
            return Color.purple
        case .action:
            return Color.orange
        }
    }
}

// Quick impact stats summary
struct ImpactStatsSummaryView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Your Impact")
                .font(.headline)
            
            HStack(spacing: 20) {
                ImpactStatView(
                    icon: "heart.fill",
                    color: Color.coralAccent,
                    value: "10",
                    label: "Donations"
                )
                
                ImpactStatView(
                    icon: "star.fill",
                    color: Color.yellow,
                    value: "3",
                    label: "Challenges"
                )
                
                ImpactStatView(
                    icon: "person.2.fill",
                    color: Color.tealAccent,
                    value: "5",
                    label: "Friends"
                )
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Individual impact stat view
struct ImpactStatView: View {
    let icon: String
    let color: Color
    let value: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.system(size: 22))
                .foregroundColor(color)
            
            Text(value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            Text(label)
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

// Placeholder view for donation options
struct DonationView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    Text("Support Vaquita Conservation")
                        .font(.title2)
                        .fontWeight(.bold)
                        .multilineTextAlignment(.center)
                        .padding(.top)
                    
                    Text("Your contribution directly supports research, monitoring, and conservation efforts in the Gulf of California.")
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // Donation options will go here
                    Text("Donation options coming soon!")
                        .padding()
                }
            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}

// Preview initializer for HomeView
#if DEBUG
extension HomeView {
    init() {
        self._selectedTab = .constant(0)
    }
}
#endif 