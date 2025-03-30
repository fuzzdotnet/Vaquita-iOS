import SwiftUI

struct MissionView: View {
    @EnvironmentObject var appState: AppState
    
    // Sample partners for prototype
    private let partners = [
        Partner(
            id: "partner1",
            name: "Sea Shepherd Conservation Society",
            tagline: "Removing illegal fishing nets daily",
            description: "Sea Shepherd works with the Mexican government to patrol the vaquita habitat and remove illegal fishing nets that threaten the world's most endangered marine mammal.",
            logoAsset: "logo_seashepherd",
            websiteURL: URL(string: "https://seashepherd.org/"),
            impactSummary: "Removed hundreds of illegal fishing nets from vaquita habitat",
            focusAreas: ["Patrol", "Net removal", "Enforcement"]
        ),
        Partner(
            id: "partner2",
            name: "World Wildlife Fund",
            tagline: "Working with communities for sustainable solutions",
            description: "WWF partners with local communities to develop alternative, sustainable fishing methods that don't harm vaquitas. They also work on policy and governmental engagement.",
            logoAsset: "logo_wwf",
            websiteURL: URL(string: "https://worldwildlife.org/"),
            impactSummary: "Supported development of vaquita-safe fishing gear",
            focusAreas: ["Community engagement", "Policy", "Research"]
        ),
        Partner(
            id: "partner3",
            name: "VIVA Vaquita",
            tagline: "Scientific research and public awareness",
            description: "VIVA Vaquita is dedicated to preventing the extinction of the vaquita through research, public awareness and education.",
            logoAsset: "logo_vivavaquita",
            websiteURL: URL(string: "https://vivavaquita.org/"),
            impactSummary: "Leading scientific research on vaquita population and conservation",
            focusAreas: ["Research", "Education", "Awareness"]
        ),
        Partner(
            id: "partner4",
            name: "International Committee for the Recovery of the Vaquita (CIRVA)",
            tagline: "Scientific advisory committee for vaquita recovery",
            description: "CIRVA is the international scientific advisory committee that makes recommendations to the Mexican government on how to save the vaquita from extinction.",
            logoAsset: "logo_cirva",
            websiteURL: nil,
            impactSummary: "Provides critical scientific guidance for vaquita recovery efforts",
            focusAreas: ["Scientific advisory", "Research", "Conservation planning"]
        )
    ]
    
    // Impact statistics
    private let impactStats = [
        ImpactStat(id: "1", title: "Fishing Nets Removed", value: "over 1,200", icon: "link.circle.fill"),
        ImpactStat(id: "2", title: "Patrol Hours", value: "34,000+", icon: "clock.fill"),
        ImpactStat(id: "3", title: "Community Members Engaged", value: "500+", icon: "person.3.fill")
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Hero section
                VStack(spacing: 16) {
                    Text("Our Mission")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("Vaquita Watch brings together leading conservation organizations to save the world's most endangered marine mammal from extinction.")
                        .font(.subheadline)
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    // Vaquita image would go here
                    ZStack {
                        Rectangle()
                            .fill(Color("oceanLightBlue").opacity(0.3))
                            .frame(height: 200)
                            .cornerRadius(16)
                        
                        Text("Vaquita Image")
                            .foregroundColor(Color("oceanBlue"))
                    }
                    .padding(.horizontal)
                }
                
                // Impact summary
                VStack(spacing: 16) {
                    Text("Impact Summary")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("Your support directly enables these conservation efforts")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    HStack(spacing: 16) {
                        ForEach(impactStats) { stat in
                            ImpactStatBox(stat: stat)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Partner organizations
                VStack(spacing: 20) {
                    Text("Partner Organizations")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                    
                    VStack(spacing: 16) {
                        ForEach(partners) { partner in
                            PartnerCard(partner: partner)
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Stay Engaged section (previously How You Can Help)
                VStack(alignment: .leading, spacing: 16) {
                    Text("Stay Engaged")
                        .font(.system(.title3, design: .rounded))
                        .fontWeight(.bold)
                    
                    EngagementOptionCard(
                        title: "Get Our Newsletter",
                        description: "Get M/W/F updates about conservation around the world in our newsletter at Fuzz.net.",
                        icon: "envelope.fill",
                        color: Color("tealAccent"),
                        url: URL(string: "http://www.fuzz.net")
                    )
                    
                    EngagementOptionCard(
                        title: "Follow Us on Instagram",
                        description: "Join our Instagram community of vaquita lovers and get pictures and footage from the field.",
                        icon: "camera.fill",
                        color: Color.purple,
                        url: URL(string: "https://www.instagram.com/vaquitawatch")
                    )
                }
                .padding(.horizontal)
                .padding(.bottom, 30)
                
                // FUZZ Logo Section
                VStack(spacing: 8) {
                    Text("Proudly created by")
                        .font(.footnote)
                        .foregroundColor(.secondary)
                    
                    // FUZZ logo as image
                    Link(destination: URL(string: "http://www.fuzz.net")!) {
                        Image("fuzz_logo")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 120, height: 60)
                            .shadow(color: Color.black.opacity(0.05), radius: 5)
                    }
                }
                .padding(.bottom, 40)
            }
            .padding(.top)
        }
        .navigationTitle("Our Mission")
        .navigationBarTitleDisplayMode(.inline)
    }
}

// Partner card component
struct PartnerCard: View {
    let partner: Partner
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(alignment: .top) {
                // Logo placeholder
                ZStack {
                    Circle()
                        .fill(Color(.systemGray6))
                        .frame(width: 60, height: 60)
                    
                    Text(String(partner.name.prefix(1)))
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color("oceanBlue"))
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(partner.name)
                        .font(.headline)
                    
                    Text(partner.tagline)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }
            
            Text(partner.description)
                .font(.body)
                .foregroundColor(.secondary)
            
            // Focus areas
            HStack {
                ForEach(partner.focusAreas, id: \.self) { area in
                    Text(area)
                        .font(.caption)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 5)
                        .background(Color("oceanBlue").opacity(0.1))
                        .foregroundColor(Color("oceanBlue"))
                        .cornerRadius(8)
                }
            }
            
            if let website = partner.websiteURL {
                Link(destination: website) {
                    HStack {
                        Text("Learn More")
                            .font(.subheadline)
                            .fontWeight(.medium)
                        
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                    }
                    .foregroundColor(Color("tealAccent"))
                }
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Impact stat model
struct ImpactStat: Identifiable {
    var id: String
    var title: String
    var value: String
    var icon: String
}

// Impact stat box component
struct ImpactStatBox: View {
    let stat: ImpactStat
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: stat.icon)
                .font(.system(size: 28))
                .foregroundColor(Color("oceanBlue"))
            
            Text(stat.value)
                .font(.system(.title3, design: .rounded))
                .fontWeight(.bold)
            
            Text(stat.title)
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: Color.black.opacity(0.05), radius: 5)
    }
}

// Help option card component
struct HelpOptionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 16) {
                // Icon with background
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .foregroundColor(.secondary)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
    }
}

// Engagement option card component for external links
struct EngagementOptionCard: View {
    let title: String
    let description: String
    let icon: String
    let color: Color
    let url: URL?
    
    var body: some View {
        if let url = url {
            Link(destination: url) {
                HStack(alignment: .center, spacing: 16) {
                    // Icon with background
                    ZStack {
                        Circle()
                            .fill(color.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        Image(systemName: icon)
                            .font(.system(size: 22))
                            .foregroundColor(color)
                    }
                    
                    VStack(alignment: .leading, spacing: 4) {
                        Text(title)
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        Text(description)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.leading)
                    }
                    
                    Spacer()
                    
                    Image(systemName: "arrow.up.right.square")
                        .foregroundColor(.secondary)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.05), radius: 5)
            }
        } else {
            // Fallback for nil URL
            HStack(alignment: .center, spacing: 16) {
                ZStack {
                    Circle()
                        .fill(color.opacity(0.2))
                        .frame(width: 50, height: 50)
                    
                    Image(systemName: icon)
                        .font(.system(size: 22))
                        .foregroundColor(color)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.leading)
                }
                
                Spacer()
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(color: Color.black.opacity(0.05), radius: 5)
        }
    }
} 