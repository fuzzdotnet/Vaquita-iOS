import SwiftUI
import MapKit

struct MapView: View {
    @EnvironmentObject var appState: AppState
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 31.0, longitude: -114.5), // Gulf of California
        span: MKCoordinateSpan(latitudeDelta: 8, longitudeDelta: 8)
    )
    
    @State private var selectedLocation: MapLocation?
    @State private var showingLocationDetail = false
    @State private var mapLocations: [MapLocation] = []
    
    var body: some View {
        ZStack {
            // Map background
            Map(coordinateRegion: $region, annotationItems: mapLocations) { location in
                MapAnnotation(coordinate: location.coordinate) {
                    MapPinView(location: location, isSelected: selectedLocation?.id == location.id)
                        .onTapGesture {
                            selectedLocation = location
                            showingLocationDetail = true
                        }
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            // Map overlay with title and filters
            VStack {
                // Title card
                VStack(spacing: 8) {
                    Text("Map of Hope")
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("See vaquita conservation efforts around the world")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .multilineTextAlignment(.center)
                    
                    // Filter buttons
                    HStack(spacing: 16) {
                        FilterButton(
                            title: "All",
                            isSelected: true,
                            action: { /* Filter map */ }
                        )
                        
                        FilterButton(
                            title: "Partners",
                            isSelected: false,
                            action: { /* Filter map */ }
                        )
                        
                        FilterButton(
                            title: "Supporters",
                            isSelected: false,
                            action: { /* Filter map */ }
                        )
                    }
                    .padding(.top, 8)
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding()
                
                Spacer()
                
                // Info box about vaquita territory
                VStack(alignment: .leading, spacing: 12) {
                    Text("Vaquita Territory")
                        .font(.headline)
                    
                    Text("Vaquitas are found only in a small area in the northern Gulf of California, Mexico. This region highlighted on the map shows their natural habitat.")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                    
                    Button(action: {
                        // Center map on vaquita territory
                        withAnimation {
                            region = MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 31.0, longitude: -114.5),
                                span: MKCoordinateSpan(latitudeDelta: 2, longitudeDelta: 2)
                            )
                        }
                    }) {
                        HStack {
                            Text("Zoom to Habitat")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            
                            Image(systemName: "location.magnifyingglass")
                        }
                        .foregroundColor(Color("oceanBlue"))
                        .padding(.vertical, 4)
                    }
                }
                .padding()
                .background(Color(.systemBackground))
                .cornerRadius(16)
                .shadow(color: Color.black.opacity(0.1), radius: 5)
                .padding()
            }
        }
        .sheet(isPresented: $showingLocationDetail) {
            if let location = selectedLocation {
                LocationDetailView(location: location)
            }
        }
        .onAppear {
            // Load sample map data
            loadSampleMapData()
        }
    }
    
    private func loadSampleMapData() {
        // Sample data points - in a real app this would come from a backend
        let sampleLocations = [
            // Vaquita habitat
            MapLocation(
                id: "habitat",
                title: "Vaquita Refuge",
                subtitle: "Protected Marine Area",
                description: "This is the core habitat of the vaquita, a protected area where fishing with gillnets is prohibited.",
                type: .habitat,
                coordinate: CLLocationCoordinate2D(latitude: 31.0, longitude: -114.5)
            ),
            
            // Conservation partners
            MapLocation(
                id: "partner1",
                title: "Sea Shepherd",
                subtitle: "Conservation Society",
                description: "Sea Shepherd works with the Mexican government to patrol the waters and remove illegal fishing nets that threaten vaquitas.",
                type: .partner,
                coordinate: CLLocationCoordinate2D(latitude: 31.2, longitude: -114.8)
            ),
            MapLocation(
                id: "partner2",
                title: "WWF Mexico",
                subtitle: "Conservation Organization",
                description: "World Wildlife Fund works on policy and community engagement to protect the vaquita porpoise.",
                type: .partner,
                coordinate: CLLocationCoordinate2D(latitude: 19.4, longitude: -99.1) // Mexico City
            ),
            
            // Sample supporters
            MapLocation(
                id: "supporter1",
                title: "Supporter Group",
                subtitle: "New York",
                description: "A community of supporters who raise awareness and funds for vaquita conservation.",
                type: .supporter,
                coordinate: CLLocationCoordinate2D(latitude: 40.7, longitude: -74.0)
            ),
            MapLocation(
                id: "supporter2",
                title: "Supporter Group",
                subtitle: "London",
                description: "European supporters helping with global awareness campaigns.",
                type: .supporter,
                coordinate: CLLocationCoordinate2D(latitude: 51.5, longitude: -0.1)
            ),
            MapLocation(
                id: "supporter3",
                title: "Supporter Group",
                subtitle: "Tokyo",
                description: "Asian supporters partnering with fishing industry to promote sustainable practices.",
                type: .supporter,
                coordinate: CLLocationCoordinate2D(latitude: 35.7, longitude: 139.8)
            )
        ]
        
        mapLocations = sampleLocations
    }
}

// Map location model
struct MapLocation: Identifiable {
    var id: String
    var title: String
    var subtitle: String
    var description: String
    var type: LocationType
    var coordinate: CLLocationCoordinate2D
    var imageAsset: String?
    
    enum LocationType {
        case habitat
        case partner
        case supporter
    }
}

// Custom map pin view
struct MapPinView: View {
    let location: MapLocation
    let isSelected: Bool
    
    var body: some View {
        ZStack {
            // Pin background
            Circle()
                .fill(pinColor)
                .frame(width: isSelected ? 44 : 36, height: isSelected ? 44 : 36)
                .shadow(radius: isSelected ? 3 : 1)
            
            // Pin icon
            Image(systemName: pinIcon)
                .font(.system(size: isSelected ? 20 : 16))
                .foregroundColor(.white)
        }
    }
    
    private var pinColor: Color {
        switch location.type {
        case .habitat:
            return Color("oceanBlue")
        case .partner:
            return Color("tealAccent")
        case .supporter:
            return Color("coralAccent")
        }
    }
    
    private var pinIcon: String {
        switch location.type {
        case .habitat:
            return "water.waves"
        case .partner:
            return "building.2.fill"
        case .supporter:
            return "person.fill"
        }
    }
}

// Filter button
struct FilterButton: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.subheadline)
                .fontWeight(isSelected ? .semibold : .regular)
                .padding(.horizontal, 16)
                .padding(.vertical, 8)
                .background(isSelected ? Color("oceanBlue").opacity(0.2) : Color(.systemGray6))
                .foregroundColor(isSelected ? Color("oceanBlue") : .primary)
                .cornerRadius(20)
        }
    }
}

// Location detail sheet
struct LocationDetailView: View {
    let location: MapLocation
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Header with type badge
                    HStack {
                        Text(typeText)
                            .font(.caption)
                            .fontWeight(.semibold)
                            .padding(.horizontal, 10)
                            .padding(.vertical, 5)
                            .background(typeColor.opacity(0.2))
                            .foregroundColor(typeColor)
                            .cornerRadius(8)
                        
                        Spacer()
                    }
                    
                    // Title and subtitle
                    VStack(alignment: .leading, spacing: 4) {
                        Text(location.title)
                            .font(.system(.title2, design: .rounded))
                            .fontWeight(.bold)
                        
                        Text(location.subtitle)
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                    
                    // Optional image
                    if let imageAsset = location.imageAsset {
                        Image(imageAsset)
                            .resizable()
                            .scaledToFit()
                            .cornerRadius(12)
                    } else {
                        // Placeholder image with icon
                        ZStack {
                            Rectangle()
                                .fill(typeColor.opacity(0.1))
                                .frame(height: 180)
                                .cornerRadius(12)
                            
                            Image(systemName: pinIcon)
                                .font(.system(size: 40))
                                .foregroundColor(typeColor.opacity(0.5))
                        }
                    }
                    
                    // Description
                    Text(location.description)
                        .font(.body)
                    
                    // Action buttons
                    if location.type == .partner {
                        Button(action: {
                            // Open partner website
                        }) {
                            HStack {
                                Text("Visit Website")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Image(systemName: "arrow.up.right.square")
                            }
                            .padding()
                            .background(Color("tealAccent").opacity(0.2))
                            .foregroundColor(Color("tealAccent"))
                            .cornerRadius(12)
                        }
                    } else if location.type == .supporter {
                        Button(action: {
                            // Connect with supporters
                        }) {
                            HStack {
                                Text("Connect")
                                    .font(.headline)
                                
                                Spacer()
                                
                                Image(systemName: "person.crop.circle.badge.plus")
                            }
                            .padding()
                            .background(Color("coralAccent").opacity(0.2))
                            .foregroundColor(Color("coralAccent"))
                            .cornerRadius(12)
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationBarItems(trailing: Button("Close") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
    
    private var typeText: String {
        switch location.type {
        case .habitat:
            return "Vaquita Habitat"
        case .partner:
            return "Conservation Partner"
        case .supporter:
            return "Supporter Community"
        }
    }
    
    private var typeColor: Color {
        switch location.type {
        case .habitat:
            return Color("oceanBlue")
        case .partner:
            return Color("tealAccent")
        case .supporter:
            return Color("coralAccent")
        }
    }
    
    private var pinIcon: String {
        switch location.type {
        case .habitat:
            return "water.waves"
        case .partner:
            return "building.2.fill"
        case .supporter:
            return "person.fill"
        }
    }
} 