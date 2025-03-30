import SwiftUI

// Local wrapper for the SkinOptionView defined elsewhere
private struct SkinOptionViewLocal: View {
    let title: String
    let isSelected: Bool
    let isLocked: Bool
    
    var body: some View {
        VStack {
            Circle()
                .fill(isLocked ? Color.gray.opacity(0.3) : Color.oceanBlue.opacity(0.7))
                .frame(width: 80, height: 80)
                .overlay(
                    Group {
                        if isLocked {
                            Image(systemName: "lock.fill")
                                .foregroundColor(.white)
                        } else {
                            Image(systemName: "figure.wave")
                                .font(.system(size: 30))
                                .foregroundColor(.white)
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
    
    var body: some View {
        ZStack {
            // For now, we'll use a placeholder circle
            // In a real app, this would be replaced with actual vaquita assets
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
            
            // Accessory overlay
            if accessory != VaquitaAccessory.none.rawValue {
                Text("✨")
                    .font(.system(size: 40))
                    .offset(y: -60)
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
                VStack(spacing: 30) {
                    Text("Certificate of Adoption")
                        .font(.system(.largeTitle, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(.primary)
                        .padding(.top, 40)
                    
                    Text("This certifies that")
                        .font(.system(.body, design: .serif))
                        .italic()
                    
                    Text(vaquita.name)
                        .font(.system(.title, design: .serif))
                        .fontWeight(.bold)
                        .foregroundColor(Color.oceanDarkBlue)
                    
                    ZStack {
                        Circle()
                            .fill(Color.oceanDarkBlue.opacity(0.2))
                            .frame(width: 180, height: 180)
                        
                        VaquitaImageView(
                            skin: vaquita.skin,
                            accessory: vaquita.accessory,
                            isBreathing: true
                        )
                        .frame(width: 180, height: 180)
                    }
                    .padding()
                    
                    Text("has been adopted on")
                        .font(.system(.body, design: .serif))
                        .italic()
                    
                    Text(dateFormatter.string(from: vaquita.adoptionDate ?? Date()))
                        .font(.system(.title3, design: .serif))
                        .fontWeight(.semibold)
                    
                    Text("Thank you for your contribution to vaquita conservation.")
                        .font(.system(.body, design: .serif))
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                    
                    Text("Your adoption helps protect one of the most endangered marine mammals on the planet.")
                        .font(.system(.body, design: .serif))
                        .multilineTextAlignment(.center)
                        .foregroundColor(.secondary)
                        .padding(.horizontal)
                    
                    Button(action: {
                        isShareSheetShowing = true
                    }) {
                        HStack {
                            Image(systemName: "square.and.arrow.up")
                            Text("Share Certificate")
                        }
                        .padding()
                        .background(Color.oceanDarkBlue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .padding(.top, 20)
                }
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 25)
                        .fill(Color.white)
                        .shadow(radius: 5)
                        .padding()
                )
            }
            .background(Color.oceanDeepBlue.opacity(0.1))
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