import SwiftUI

// Local wrapper for the SkinOptionView defined elsewhere
private struct SkinOptionViewLocal: View {
    let title: String
    let isSelected: Bool
    let isLocked: Bool
    
    private var imageName: String {
        "Vaquitas/vaquita_\(title.lowercased().replacingOccurrences(of: " ", with: "_"))"
    }
    
    var body: some View {
        VStack {
            Circle()
                .fill(isLocked ? Color.gray.opacity(0.3) : Color.oceanBlue.opacity(0.1))
                .frame(width: 80, height: 80)
                .overlay(
                    Group {
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                        } else {
                            Image(imageName)
                                .resizable()
                                .scaledToFit()
                                .padding(12)
                        }
                    }
                )
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
                )
            
            Text(title)
                .font(.caption)
                .foregroundColor(isLocked ? .gray : .primary)
        }
    }
}

// Local wrapper for the AccessoryOptionView defined elsewhere
private struct AccessoryOptionViewLocal: View {
    let title: String
    let isSelected: Bool
    let isLocked: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(isLocked ? Color.gray.opacity(0.3) : Color.tealAccent.opacity(0.5))
                .frame(width: 80, height: 80)
                .overlay(
                    Group {
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                        } else {
                            Text("✨")
                                .font(.system(size: 30))
                        }
                    }
                )
                .overlay(
                    Circle()
                        .strokeBorder(isSelected ? Color.yellow : Color.clear, lineWidth: 3)
                )
            
            Text(title)
                .font(.caption)
                .foregroundColor(isLocked ? .gray : .primary)
        }
    }
}

struct VaquitaAvatarView: View {
    @EnvironmentObject var appState: AppState
    @State private var showingCustomizationSheet = false
    @State private var showingAdoptionSheet = false
    @State private var showingCertificateSheet = false
    @State private var isBreathing = false
    @State private var showingBubbles = false
    
    private let timer = Timer.publish(every: 3, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            // Background for the entire screen
            Color.oceanDeepBlue
                .edgesIgnoringSafeArea(.all)
            
            // Ocean background
            VStack {
                // Upper part with vaquita
                ZStack {
                    // Background gradient for the ocean scene
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.oceanDarkBlue.opacity(0.8),
                            Color.oceanDeepBlue
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .edgesIgnoringSafeArea(.top)
                    
                    // Bubble effects
                    if showingBubbles {
                        BubbleEffectView()
                    }
                    
                    // Vaquita avatar
                    VStack {
                        Spacer()
                        
                        VaquitaImageView(
                            skin: appState.userVaquita.skin,
                            accessory: appState.userVaquita.accessory,
                            isBreathing: isBreathing
                        )
                        .scaleEffect(isBreathing ? 1.05 : 1.0)
                        .animation(
                            Animation.easeInOut(duration: 2.0).repeatForever(autoreverses: true),
                            value: isBreathing
                        )
                        .frame(width: 240, height: 240)
                        .padding(.bottom, 20)
                        
                        Spacer()
                    }
                }
                .frame(height: 400)
                
                // Lower part with stats and options
                ScrollView {
                    VStack(spacing: 24) {
                        // Avatar name and happiness level
                        VStack(spacing: 12) {
                            Text(appState.userVaquita.name)
                                .font(.system(.title, design: .rounded))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                            
                            HappinessLevelView(level: appState.userVaquita.happinessLevel)
                        }
                        .padding(.top, 20)
                        
                        // Status and action buttons
                        HStack(spacing: 20) {
                            ActionButton(
                                icon: "hand.tap.fill",
                                label: "Pet",
                                action: {
                                    var updatedVaquita = appState.userVaquita
                                    updatedVaquita.interact()
                                    appState.userVaquita = updatedVaquita
                                    
                                    // Show bubbles briefly
                                    showingBubbles = true
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                        showingBubbles = false
                                    }
                                }
                            )
                            
                            if appState.userVaquita.isAdopted {
                                ActionButton(
                                    icon: "shuffle",
                                    label: "Customize",
                                    action: { showingCustomizationSheet = true }
                                )
                                
                                ActionButton(
                                    icon: "doc.fill",
                                    label: "Certificate",
                                    action: { showingCertificateSheet = true }
                                )
                            } else {
                                ActionButton(
                                    icon: "heart.fill",
                                    label: "Adopt",
                                    action: { showingAdoptionSheet = true }
                                )
                            }
                        }
                        .padding(.horizontal)
                        
                        // Adoption call-to-action if not adopted
                        if !appState.userVaquita.isAdopted {
                            AdoptionCallToActionView(action: { showingAdoptionSheet = true })
                                .padding(.horizontal)
                                .padding(.vertical, 10)
                        }
                        
                        // Fun facts about your vaquita
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About Vaquitas")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            VStack(alignment: .leading, spacing: 12) {
                                FactRow(icon: "ruler", text: "Vaquitas grow to be about 5 feet long")
                                FactRow(icon: "scalemass", text: "They weigh around 120 pounds")
                                FactRow(icon: "location", text: "Only found in the Gulf of California")
                                FactRow(icon: "water.waves", text: "Prefer shallow waters (less than 50m deep)")
                                FactRow(icon: "clock", text: "Can hold their breath for several minutes")
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        
                        // Conservation status
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Conservation Status")
                                .font(.headline)
                                .foregroundColor(.white)
                            
                            HStack(alignment: .top, spacing: 16) {
                                Image(systemName: "exclamationmark.triangle.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.coralAccent)
                                
                                VStack(alignment: .leading, spacing: 8) {
                                    Text("Critically Endangered")
                                        .font(.system(.title3, design: .rounded))
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.coralAccent)
                                    
                                    Text("Fewer than 10 individuals remain in the wild. They are the most endangered marine mammal in the world.")
                                        .foregroundColor(.white.opacity(0.8))
                                }
                            }
                            
                            // Vaquita in the wild gallery
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Vaquitas in the Wild")
                                    .font(.system(.subheadline, design: .rounded))
                                    .fontWeight(.medium)
                                    .foregroundColor(.white)
                                    .padding(.top, 10)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 15) {
                                        // Gallery images (placeholders for now)
                                        ForEach(0..<4) { index in
                                            WildVaquitaImageView(index: index)
                                        }
                                    }
                                    .padding(.horizontal, 5)
                                    .padding(.vertical, 8)
                                }
                            }
                        }
                        .padding()
                        .background(Color.white.opacity(0.1))
                        .cornerRadius(16)
                        .padding(.horizontal)
                        .padding(.bottom, 30)
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color.oceanDeepBlue)
                        .edgesIgnoringSafeArea(.bottom)
                )
            }
        }
        .sheet(isPresented: $showingCustomizationSheet) {
            if appState.userVaquita.isAdopted {
                CustomizationView(vaquita: $appState.userVaquita)
            } else {
                // Fallback to adoption view if somehow accessed without adoption
                AdoptionView(vaquita: $appState.userVaquita)
            }
        }
        .sheet(isPresented: $showingAdoptionSheet) {
            AdoptionView(vaquita: $appState.userVaquita)
        }
        .sheet(isPresented: $showingCertificateSheet) {
            AdoptionCertificateView(vaquita: appState.userVaquita)
        }
        .onAppear {
            isBreathing = true
            // Show initial bubbles
            showingBubbles = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                showingBubbles = false
            }
        }
        .onReceive(timer) { _ in
            // Occasionally show bubbles
            if Int.random(in: 1...5) == 1 {
                showingBubbles = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    showingBubbles = false
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name("ShowVaquitaCertificate"))) { _ in
            if appState.userVaquita.isAdopted {
                showingCertificateSheet = true
            }
        }
    }
}

// Vaquita image view with animation
struct VaquitaImageView: View {
    let skin: String
    let accessory: String
    var isBreathing: Bool
    
    private func getVaquitaImageName() -> String {
        // Convert the skin name to a valid asset name format
        let baseName = skin.lowercased().replacingOccurrences(of: " ", with: "_")
        return "Vaquitas/vaquita_\(baseName)"
    }
    
    private func getAccessoryImageName() -> String {
        if accessory == VaquitaAccessory.none.rawValue {
            return ""
        }
        // Convert the accessory name to a valid asset name format
        let baseName = accessory.lowercased().replacingOccurrences(of: " ", with: "_")
        return "Accessories/\(baseName)_accessory"
    }
    
    var body: some View {
        ZStack {
            // The vaquita character image
            if let _ = UIImage(named: getVaquitaImageName()) {
                // Use the actual image if available
                Image(getVaquitaImageName())
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .scaleEffect(isBreathing ? 1.05 : 1.0)
            } else {
                // Fallback to placeholder if image not found
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 220, height: 220)
                    .overlay(
                        Image(systemName: "figure.wave")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .foregroundColor(.white)
                    )
                    .overlay(
                        Circle()
                            .strokeBorder(Color.white.opacity(0.3), lineWidth: 4)
                    )
            }
            
            // Accessory overlay
            if accessory != VaquitaAccessory.none.rawValue {
                if let _ = UIImage(named: getAccessoryImageName()) {
                    // Use the actual accessory image if available
                    Image(getAccessoryImageName())
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .scaleEffect(isBreathing ? 1.05 : 1.0)
                } else {
                    // Fallback to emoji for missing accessories
                    Text("✨")
                        .font(.system(size: 40))
                        .offset(y: -60)
                }
            }
        }
    }
}

// Happiness level indicator
struct HappinessLevelView: View {
    let level: Int
    
    var body: some View {
        VStack(spacing: 8) {
            Text(moodLabel)
                .font(.headline)
                .foregroundColor(moodColor)
            
            HStack(spacing: 2) {
                ForEach(1...10, id: \.self) { index in
                    RoundedRectangle(cornerRadius: 2)
                        .fill(index <= level ? moodColor : Color.white.opacity(0.2))
                        .frame(height: 8)
                }
            }
            .frame(width: 180)
        }
    }
    
    var moodLabel: String {
        switch level {
        case 1...3:
            return "Needs Attention"
        case 4...6:
            return "Content"
        case 7...9:
            return "Happy"
        case 10:
            return "Thriving!"
        default:
            return "Unknown"
        }
    }
    
    var moodColor: Color {
        switch level {
        case 1...3:
            return Color.coralAccent
        case 4...6:
            return Color.yellow
        case 7...9:
            return Color.tealAccent
        case 10:
            return Color.green
        default:
            return Color.gray
        }
    }
}

// Action button
struct ActionButton: View {
    let icon: String
    let label: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 24))
                    .foregroundColor(.white)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.white)
            }
            .frame(width: 70, height: 70)
            .background(Color.white.opacity(0.2))
            .cornerRadius(16)
        }
    }
}

// Fact row for info section
struct FactRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.tealAccent)
                .frame(width: 20)
            
            Text(text)
                .foregroundColor(.white.opacity(0.8))
        }
    }
}

// Bubble effect animation
struct BubbleEffectView: View {
    let bubbleCount = 12
    
    var body: some View {
        ZStack {
            ForEach(0..<bubbleCount, id: \.self) { index in
                Bubble(
                    delay: Double(index) * 0.2,
                    size: CGFloat.random(in: 6...24),
                    xOffset: CGFloat.random(in: -100...100)
                )
            }
        }
    }
}

struct Bubble: View {
    let delay: Double
    let size: CGFloat
    let xOffset: CGFloat
    
    @State private var isAnimating = false
    
    var body: some View {
        Circle()
            .fill(Color.white.opacity(0.3))
            .frame(width: size, height: size)
            .offset(x: xOffset, y: isAnimating ? -400 : 0)
            .opacity(isAnimating ? 0 : 0.8)
            .onAppear {
                withAnimation(Animation.easeOut(duration: 3.0).delay(delay)) {
                    isAnimating = true
                }
            }
    }
}

// Adoption Call to Action view
struct AdoptionCallToActionView: View {
    var action: () -> Void
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Adopt Your Vaquita")
                .font(.headline)
                .foregroundColor(.white)
            
            Text("Adopt for $3.99 to unlock customization, naming, and more while helping vaquita conservation efforts.")
                .font(.subheadline)
                .multilineTextAlignment(.center)
                .foregroundColor(.white.opacity(0.9))
            
            Button(action: action) {
                HStack {
                    Image(systemName: "heart.fill")
                    Text("Adopt Now - $3.99")
                        .fontWeight(.bold)
                }
                .foregroundColor(.white)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.coralAccent)
                .cornerRadius(12)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 16)
                .fill(Color.white.opacity(0.1))
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .strokeBorder(Color.coralAccent.opacity(0.6), lineWidth: 2)
                )
        )
    }
}

// Customization sheet view
struct CustomizationView: View {
    @Binding var vaquita: VaquitaAvatar
    @Environment(\.presentationMode) var presentationMode
    @State private var name: String
    @State private var selectedSkin: String
    @State private var selectedAccessory: String
    @State private var selectedBackground: String
    @State private var showingPremiumDialog = false
    @State private var selectedPremiumItem = ""
    
    init(vaquita: Binding<VaquitaAvatar>) {
        self._vaquita = vaquita
        self._name = State(initialValue: vaquita.wrappedValue.name)
        self._selectedSkin = State(initialValue: vaquita.wrappedValue.skin)
        self._selectedAccessory = State(initialValue: vaquita.wrappedValue.accessory)
        self._selectedBackground = State(initialValue: vaquita.wrappedValue.background)
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Preview of vaquita with current customizations
                    ZStack {
                        Circle()
                            .fill(Color.oceanDarkBlue)
                            .frame(width: 180, height: 180)
                        
                        VaquitaImageView(
                            skin: selectedSkin,
                            accessory: selectedAccessory,
                            isBreathing: true
                        )
                        .frame(width: 180, height: 180)
                    }
                    .padding(.top, 16)
                    
                    // Name field
                    VStack(alignment: .leading) {
                        Text("Name")
                            .font(.headline)
                        
                        TextField("Vaquita's name", text: $name)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                    }
                    .padding(.horizontal)
                    
                    // Skin selection
                    VStack(alignment: .leading) {
                        Text("Choose Appearance")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(VaquitaSkin.allCases) { skin in
                                    SkinOptionViewLocal(
                                        title: skin.rawValue,
                                        isSelected: selectedSkin == skin.rawValue,
                                        isLocked: skin != .classic && !isUnlocked(skin.rawValue)
                                    )
                                    .onTapGesture {
                                        if isUnlocked(skin.rawValue) || skin == .classic {
                                            selectedSkin = skin.rawValue
                                        } else {
                                            // Show premium customization info
                                            selectedPremiumItem = skin.rawValue
                                            showingPremiumDialog = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    // Accessory selection
                    VStack(alignment: .leading) {
                        Text("Choose Accessory")
                            .font(.headline)
                        
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 16) {
                                ForEach(VaquitaAccessory.allCases) { accessory in
                                    AccessoryOptionViewLocal(
                                        title: accessory.rawValue,
                                        isSelected: selectedAccessory == accessory.rawValue,
                                        isLocked: accessory != .none && !isUnlocked(accessory.rawValue)
                                    )
                                    .onTapGesture {
                                        if isUnlocked(accessory.rawValue) || accessory == .none {
                                            selectedAccessory = accessory.rawValue
                                        } else {
                                            // Show premium customization info
                                            selectedPremiumItem = accessory.rawValue
                                            showingPremiumDialog = true
                                        }
                                    }
                                }
                            }
                            .padding(.horizontal)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                }
            }
            .navigationTitle("Customize Your Vaquita")
            .navigationBarItems(
                leading: Button("Cancel") {
                    presentationMode.wrappedValue.dismiss()
                },
                trailing: Button("Save") {
                    vaquita.name = name
                    vaquita.skin = selectedSkin
                    vaquita.accessory = selectedAccessory
                    vaquita.background = selectedBackground
                    presentationMode.wrappedValue.dismiss()
                }
            )
            .alert(isPresented: $showingPremiumDialog) {
                Alert(
                    title: Text("Premium Item"),
                    message: Text("\(selectedPremiumItem) is a premium item. Unlock it for just $0.99 to further support vaquita conservation efforts."),
                    primaryButton: .default(Text("Unlock for $0.99")) {
                        // In a real app, this would trigger the in-app purchase
                        var updatedVaquita = vaquita
                        updatedVaquita.unlockPremiumItem(selectedPremiumItem)
                        vaquita = updatedVaquita
                        
                        // Update selection if a skin was just unlocked
                        if VaquitaSkin.allCases.map(\.rawValue).contains(selectedPremiumItem) {
                            selectedSkin = selectedPremiumItem
                        } else if VaquitaAccessory.allCases.map(\.rawValue).contains(selectedPremiumItem) {
                            selectedAccessory = selectedPremiumItem
                        }
                    },
                    secondaryButton: .cancel()
                )
            }
        }
    }
    
    // Function to check if customization is unlocked
    private func isUnlocked(_ itemId: String) -> Bool {
        // Basic items are available with adoption, premium items need to be specifically unlocked
        let premiumItems = ["Golden Sunset", "Night Glow", "Ocean Glow", "Coral Companion"]
        
        if premiumItems.contains(itemId) {
            return vaquita.isAdopted && vaquita.unlockedPremiumItems.contains(itemId)
        }
        
        return vaquita.isAdopted
    }
}

// Adoption view
struct AdoptionView: View {
    @Binding var vaquita: VaquitaAvatar
    @Environment(\.presentationMode) var presentationMode
    @State private var showingThankYou = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    Image(systemName: "heart.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 80, height: 80)
                        .foregroundColor(Color.coralAccent)
                        .padding(.top, 30)
                    
                    Text("Adopt \(vaquita.name)")
                        .font(.system(.title, design: .rounded))
                        .fontWeight(.bold)
                    
                    Text("Your one-time adoption donation of $3.99 helps fund vaquita conservation efforts. You'll receive a digital adoption certificate and unlock customization options!")
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Divider()
                        .padding(.vertical)
                    
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Your adoption includes:")
                            .font(.headline)
                        
                        AdoptionBenefitRow(icon: "checkmark.circle.fill", text: "Digital adoption certificate")
                        AdoptionBenefitRow(icon: "checkmark.circle.fill", text: "Ability to name your vaquita")
                        AdoptionBenefitRow(icon: "checkmark.circle.fill", text: "Basic vaquita appearance options")
                        AdoptionBenefitRow(icon: "checkmark.circle.fill", text: "Basic accessories")
                        AdoptionBenefitRow(icon: "checkmark.circle.fill", text: "Certificate sharing on social media")
                    }
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    Button(action: {
                        // In a real app, this would trigger the in-app purchase
                        vaquita.isAdopted = true
                        vaquita.adoptionDate = Date()
                        showingThankYou = true
                    }) {
                        Text("Adopt for $3.99")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.coralAccent)
                            .cornerRadius(16)
                    }
                    .padding()
                }
            }
            .navigationBarItems(leading: Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            })
            .alert(isPresented: $showingThankYou) {
                Alert(
                    title: Text("Thank You!"),
                    message: Text("You've successfully adopted \(vaquita.name)! Your contribution helps protect the vaquita in the wild."),
                    dismissButton: .default(Text("View Certificate")) {
                        presentationMode.wrappedValue.dismiss()
                        // We'll need to show the certificate after dismissal
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                            NotificationCenter.default.post(name: Notification.Name("ShowAdoptionCertificate"), object: nil)
                        }
                    }
                )
            }
        }
    }
}

// Adoption Certificate View
struct AdoptionCertificateView: View {
    let vaquita: VaquitaAvatar
    @Environment(\.presentationMode) var presentationMode
    @State private var isShareSheetShowing = false
    
    var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack {
                    // Certificate Container
                    VStack(spacing: 20) {
                        // Certificate Header with decorative elements
                        VStack(spacing: 10) {
                            // Decorative wave pattern at top
                            Image(systemName: "waveform")
                                .font(.system(size: 40))
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.6))
                                .padding(.top, 30)
                            
                            Text("OFFICIAL")
                                .font(.system(.caption, design: .serif))
                                .kerning(3)
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.8))
                            
                            Text("Certificate of Adoption")
                                .font(.system(.largeTitle, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(Color.oceanDarkBlue)
                                .padding(.top, 5)
                            
                            // Decorative divider
                            HStack(spacing: 15) {
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.oceanDarkBlue.opacity(0.4))
                                
                                Image(systemName: "seal.fill")
                                    .foregroundColor(Color.coralAccent)
                                
                                Rectangle()
                                    .frame(height: 1)
                                    .foregroundColor(Color.oceanDarkBlue.opacity(0.4))
                            }
                            .padding(.horizontal, 20)
                            .padding(.top, 10)
                        }
                        
                        // Decorative corners (like an official certificate)
                        ZStack {
                            // Vaquita Image
                            ZStack {
                                // Water-like circular background
                                Circle()
                                    .fill(
                                        LinearGradient(
                                            gradient: Gradient(colors: [
                                                Color.oceanDarkBlue.opacity(0.1),
                                                Color.tealAccent.opacity(0.2)
                                            ]),
                                            startPoint: .topLeading,
                                            endPoint: .bottomTrailing
                                        )
                                    )
                                    .frame(width: 200, height: 200)
                                
                                // Light beams effect
                                ZStack {
                                    ForEach(0..<8) { i in
                                        Rectangle()
                                            .fill(Color.white.opacity(0.4))
                                            .frame(width: 100, height: 2)
                                            .rotationEffect(.degrees(Double(i) * 22.5))
                                    }
                                }
                                
                                VaquitaImageView(
                                    skin: vaquita.skin,
                                    accessory: vaquita.accessory,
                                    isBreathing: true
                                )
                                .frame(width: 160, height: 160)
                            }
                            .padding()
                            
                            // Decorative corner ornaments
                            VStack {
                                HStack {
                                    CornerOrnament()
                                        .rotationEffect(.degrees(0))
                                    Spacer()
                                    CornerOrnament()
                                        .rotationEffect(.degrees(90))
                                }
                                Spacer()
                                HStack {
                                    CornerOrnament()
                                        .rotationEffect(.degrees(270))
                                    Spacer()
                                    CornerOrnament()
                                        .rotationEffect(.degrees(180))
                                }
                            }
                            .padding(20)
                        }
                        .frame(height: 260)
                        
                        // Certificate Text
                        VStack(spacing: 15) {
                            Text("This certifies that")
                                .font(.system(.subheadline, design: .serif))
                                .italic()
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.8))
                            
                            Text(vaquita.name)
                                .font(.system(.title, design: .serif))
                                .fontWeight(.bold)
                                .foregroundColor(Color.oceanDarkBlue)
                                .padding(.horizontal, 20)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            
                            Text("has been officially adopted on")
                                .font(.system(.subheadline, design: .serif))
                                .italic()
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.8))
                            
                            Text(dateFormatter.string(from: vaquita.adoptionDate ?? Date()))
                                .font(.system(.title3, design: .serif))
                                .fontWeight(.semibold)
                                .foregroundColor(Color.oceanDarkBlue)
                            
                            Text("through the Vaquita Watch Conservation Initiative")
                                .font(.system(.footnote, design: .serif))
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.7))
                        }
                        .padding(.bottom, 10)
                        
                        // Official Seal
                        HStack(spacing: 30) {
                            // Digital signature
                            VStack {
                                Text("_________________")
                                    .font(.system(.footnote))
                                    .foregroundColor(Color.oceanDarkBlue)
                                    
                                Text("Conservation Director")
                                    .font(.system(.caption, design: .serif))
                                    .foregroundColor(Color.oceanDarkBlue.opacity(0.7))
                            }
                            
                            // Official Seal
                            ZStack {
                                Circle()
                                    .stroke(Color.coralAccent, lineWidth: 2)
                                    .frame(width: 70, height: 70)
                                
                                Circle()
                                    .fill(Color.coralAccent.opacity(0.1))
                                    .frame(width: 65, height: 65)
                                
                                Image(systemName: "seal.fill")
                                    .font(.system(size: 24))
                                    .foregroundColor(Color.coralAccent)
                                    
                                Text("OFFICIAL")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundColor(Color.coralAccent)
                                    .offset(y: -18)
                                
                                Text("VERIFIED")
                                    .font(.system(size: 6, weight: .bold))
                                    .foregroundColor(Color.coralAccent)
                                    .offset(y: 18)
                            }
                        }
                        .padding(.top, 10)
                        .padding(.bottom, 30)
                        
                        // Message about conservation efforts
                        VStack(spacing: 10) {
                            Text("Your adoption directly supports conservation efforts to protect the critically endangered vaquita in its natural habitat.")
                                .font(.system(.footnote, design: .serif))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.oceanDarkBlue.opacity(0.7))
                                .padding(.horizontal)
                            
                            Text("With fewer than 10 individuals remaining in the wild, every contribution makes a difference.")
                                .font(.system(.caption, design: .serif))
                                .multilineTextAlignment(.center)
                                .foregroundColor(Color.coralAccent)
                                .padding(.horizontal)
                        }
                        .padding(.bottom, 20)
                        
                        // Share button
                        Button(action: {
                            isShareSheetShowing = true
                        }) {
                            HStack {
                                Image(systemName: "square.and.arrow.up")
                                Text("Share Certificate")
                            }
                            .padding(.horizontal, 25)
                            .padding(.vertical, 12)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [Color.oceanDarkBlue, Color.tealAccent]),
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .foregroundColor(.white)
                            .cornerRadius(25)
                            .shadow(color: Color.black.opacity(0.2), radius: 5, x: 0, y: 2)
                        }
                        .padding(.bottom, 25)
                    }
                    .padding(.horizontal)
                    .background(
                        ZStack {
                            // Parchment-like texture
                            Color(UIColor.systemBackground)
                            
                            // Very subtle pattern overlay
                            Rectangle()
                                .fill(Color.oceanDarkBlue.opacity(0.03))
                                
                            // Subtle wave pattern at low opacity for texture
                            VStack {
                                ForEach(0..<20) { i in
                                    Spacer()
                                    ZigzagPattern()
                                        .stroke(Color.oceanDarkBlue.opacity(0.03), lineWidth: 1)
                                        .frame(height: 10)
                                }
                                Spacer()
                            }
                        }
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 25))
                    .overlay(
                        RoundedRectangle(cornerRadius: 25)
                            .strokeBorder(
                                LinearGradient(
                                    gradient: Gradient(colors: [
                                        Color.oceanDarkBlue.opacity(0.6),
                                        Color.tealAccent.opacity(0.6),
                                        Color.oceanDarkBlue.opacity(0.6)
                                    ]),
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                ),
                                lineWidth: 2
                            )
                    )
                    .shadow(color: Color.black.opacity(0.15), radius: 10, x: 0, y: 5)
                    .padding()
                }
                .padding(.vertical)
            }
            .background(Color.oceanDeepBlue.opacity(0.05))
            .navigationBarItems(
                trailing: Button("Done") {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
        .sheet(isPresented: $isShareSheetShowing) {
            // In a real implementation, this would be the actual image of the certificate
            // For simplicity, we're sharing a text
            let textToShare = "I just adopted \(vaquita.name) the vaquita in the Vaquita Watch app! Join me in helping protect this endangered species: [App Download Link]"
            ActivityViewController(activityItems: [textToShare])
        }
    }
}

// Decorative corner ornament for certificate
struct CornerOrnament: View {
    var body: some View {
        ZStack {
            Path { path in
                path.move(to: CGPoint(x: 0, y: 0))
                path.addLine(to: CGPoint(x: 15, y: 0))
                path.addLine(to: CGPoint(x: 15, y: 2))
                path.addLine(to: CGPoint(x: 2, y: 2))
                path.addLine(to: CGPoint(x: 2, y: 15))
                path.addLine(to: CGPoint(x: 0, y: 15))
                path.closeSubpath()
            }
            .fill(Color.oceanDarkBlue.opacity(0.6))
            
            Path { path in
                path.move(to: CGPoint(x: 5, y: 0))
                path.addLine(to: CGPoint(x: 20, y: 0))
                path.addLine(to: CGPoint(x: 20, y: 2))
                path.addLine(to: CGPoint(x: 7, y: 2))
                path.addLine(to: CGPoint(x: 7, y: 15))
                path.addLine(to: CGPoint(x: 5, y: 15))
                path.closeSubpath()
            }
            .fill(Color.tealAccent.opacity(0.4))
        }
        .frame(width: 25, height: 25)
    }
}

// Zigzag pattern for certificate background
struct ZigzagPattern: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        let midHeight = height / 2
        let waveWidth: CGFloat = 10
        
        path.move(to: CGPoint(x: 0, y: midHeight))
        
        var x: CGFloat = 0
        while x < width {
            path.addLine(to: CGPoint(x: x + waveWidth / 2, y: midHeight + height / 4))
            path.addLine(to: CGPoint(x: x + waveWidth, y: midHeight))
            x += waveWidth
        }
        
        return path
    }
}

// Helper view for sharing content
struct ActivityViewController: UIViewControllerRepresentable {
    let activityItems: [Any]
    let applicationActivities: [UIActivity]? = nil
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: activityItems,
            applicationActivities: applicationActivities
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}

// Adoption benefit row
struct AdoptionBenefitRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(Color.tealAccent)
                .frame(width: 20)
            
            Text(text)
                .foregroundColor(.primary)
        }
    }
}

// Wild Vaquita Image View for gallery
struct WildVaquitaImageView: View {
    let index: Int
    @State private var showingDetail = false
    
    var body: some View {
        Button(action: {
            showingDetail = true
        }) {
            ZStack {
                // Placeholder image - in real app, would use actual images
                RoundedRectangle(cornerRadius: 12)
                    .fill(
                        LinearGradient(
                            gradient: Gradient(colors: [
                                Color.oceanDarkBlue.opacity(0.6),
                                Color.oceanDeepBlue.opacity(0.9)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: 120, height: 90)
                    .overlay(
                        ZStack {
                            // Wave overlay to simulate ocean
                            WaveShape()
                                .fill(Color.white.opacity(0.2))
                                .frame(height: 40)
                                .offset(y: 20)
                                .mask(
                                    RoundedRectangle(cornerRadius: 12)
                                        .frame(width: 120, height: 90)
                                )
                            
                            // Simple vaquita silhouette - this would be an actual image in the real app
                            Image(systemName: ["fish.fill", "wave.3.forward", "figure.open.water", "drop.fill"][index % 4])
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .foregroundColor(.white.opacity(0.85))
                                .offset(y: -5)
                            
                            // Location and year text
                            VStack {
                                Spacer()
                                HStack {
                                    Text(["Gulf of California", "Marine Reserve", "San Felipe", "Protected Waters"][index % 4])
                                        .font(.system(size: 8))
                                        .foregroundColor(.white)
                                        .padding(.horizontal, 6)
                                        .padding(.vertical, 2)
                                        .background(Color.black.opacity(0.3))
                                        .cornerRadius(4)
                                }
                                .padding(.bottom, 6)
                            }
                        }
                    )
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.white.opacity(0.3), lineWidth: 1)
                    )
            }
        }
        .buttonStyle(PlainButtonStyle())
        .sheet(isPresented: $showingDetail) {
            VaquitaDetailView(index: index)
        }
    }
}

// Wave shape for the water effect in gallery images
struct WaveShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        let width = rect.width
        let height = rect.height
        
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        // Create a simple wave pattern
        for x in stride(from: 0, to: width, by: 5) {
            let relativeX = x / width
            let y = sin(relativeX * .pi * 4) * 5 + height * 0.5
            path.addLine(to: CGPoint(x: x, y: y))
        }
        
        path.addLine(to: CGPoint(x: width, y: height))
        path.addLine(to: CGPoint(x: 0, y: height))
        path.closeSubpath()
        
        return path
    }
}

// Detail view when user taps on a gallery image
struct VaquitaDetailView: View {
    let index: Int
    @Environment(\.presentationMode) var presentationMode
    
    var titles = [
        "Rare Vaquita Sighting",
        "Mother and Calf",
        "Vaquita Surfacing",
        "Conservation Area"
    ]
    
    var descriptions = [
        "One of the few documented sightings of a vaquita in its natural habitat. Vaquitas are extremely elusive and rarely photographed in the wild.",
        "A mother and calf pair, a rare and precious sight. Vaquitas typically give birth to one calf every two years, making their population recovery extremely slow.",
        "A vaquita briefly surfaces for air. They typically remain submerged and are difficult to spot, making conservation efforts challenging.",
        "The protected marine reserve where conservation efforts are focused. Illegal fishing in these waters remains the biggest threat to vaquita survival."
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Header with close button
                HStack {
                    Spacer()
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 28))
                            .foregroundColor(Color.oceanDarkBlue.opacity(0.7))
                    }
                    .padding(.top, 20)
                    .padding(.trailing, 20)
                }
                
                // Placeholder for full image
                ZStack {
                    Rectangle()
                        .fill(
                            LinearGradient(
                                gradient: Gradient(colors: [
                                    Color.oceanDarkBlue.opacity(0.7),
                                    Color.oceanDeepBlue.opacity(0.9)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .aspectRatio(4/3, contentMode: .fit)
                    
                    // Placeholder icon - in real app would be actual image
                    Image(systemName: ["fish.fill", "wave.3.forward", "figure.open.water", "drop.fill"][index % 4])
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(.white.opacity(0.85))
                }
                .padding(.horizontal)
                
                // Image title and description
                VStack(alignment: .leading, spacing: 16) {
                    Text(titles[index % 4])
                        .font(.system(.title2, design: .rounded))
                        .fontWeight(.bold)
                        .foregroundColor(Color.oceanDarkBlue)
                    
                    Text(descriptions[index % 4])
                        .font(.body)
                        .foregroundColor(.primary.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    HStack {
                        Label("Gulf of California", systemImage: "mappin.and.ellipse")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                        
                        Spacer()
                        
                        Label("2023", systemImage: "calendar")
                            .font(.footnote)
                            .foregroundColor(.secondary)
                    }
                    
                    Divider()
                        .padding(.vertical, 5)
                    
                    Text("About Vaquita Photography")
                        .font(.headline)
                        .foregroundColor(Color.oceanDarkBlue)
                        .padding(.top, 5)
                    
                    Text("Capturing images of vaquitas is extremely difficult due to their rarity and elusive nature. Most documentation efforts are conducted through careful conservation monitoring to minimize disturbance to these critically endangered animals.")
                        .font(.subheadline)
                        .foregroundColor(.primary.opacity(0.8))
                        .fixedSize(horizontal: false, vertical: true)
                    
                    Button(action: {
                        // Would link to conservation efforts in a real app
                    }) {
                        Text("Learn More About Conservation Efforts")
                            .font(.subheadline)
                            .foregroundColor(.white)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 10)
                            .background(Color.tealAccent)
                            .cornerRadius(8)
                    }
                    .padding(.top, 10)
                }
                .padding()
                
                Spacer(minLength: 40)
            }
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.bottom)
    }
} 