import SwiftUI

struct ContentView: View {
    @State private var isMonitoring = false
    @State private var navigateToFallDetected = false
    @StateObject private var contactStore = ContactStore()
    @EnvironmentObject var motionManager: MotionManager

    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 24) {
                Text("SafeStep")
                    .font(.system(size: 50))
                    .bold()
                    .foregroundColor(Color(hex: 0xEE3233))
                    .padding(.horizontal)

                Spacer()

                HStack {
                    Spacer()
                    Button(action: {
                        navigateToFallDetected = true
                    }) {
                        Text("I Fell")
                            .font(.system(size: 70))
                            .fontWeight(.bold)
                            .padding()
                            .frame(width: 300, height: 300)
                            .foregroundColor(.white)
                            .background(Color(hex: 0xEE3233))
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding(.bottom, 50)

                VStack(alignment: .leading, spacing: 8) {
                    Text("Last Fall Detected")
                        .font(.system(size: 30))
                        .bold()
                        .foregroundColor(.white)

                    if let date = motionManager.lastFallDate {
                        Text("Date: \(date.formatted(date: .abbreviated, time: .omitted))")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                        Text("Time: \(date.formatted(date: .omitted, time: .standard))")
                            .foregroundColor(.white)
                            .font(.system(size: 25))
                    } else {
                        Text("No falls detected yet.")
                            .foregroundColor(Color(hex: 0xF0ECEB))
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: 150, alignment: .leading)
                .background(Color(hex: 0x66A7C5))
                .cornerRadius(12)
                .padding(.horizontal)

                Spacer()
            }
            .padding(.top)
            .background(Color(hex: 0xCEEBFB))
            .preferredColorScheme(.dark)
            // 👇 This is the modern way to push to a destination
            .navigationDestination(isPresented: $navigateToFallDetected) {
                FallDetectionView(contactStore: contactStore)
                    .environmentObject(motionManager)
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    init() {
        UITabBar.appearance().backgroundColor = UIColor(red: 0.4, green: 0.655, blue: 0.773, alpha: 1)
        UITabBar.appearance().unselectedItemTintColor = UIColor(red: 0.941, green: 0.925, blue: 0.922, alpha: 1)
    }

    var body: some View {
        TabView(selection: $selectedTab) {
            ContentView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
                .tag(0)

            ContactsView()
                .tabItem {
                    Label("Contacts", systemImage: "person.2")
                }
                .tag(1)

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
                .tag(2)
        }
        .accentColor(Color(hex: 0xEE3233))
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ContentView()
    .environmentObject(MotionManager())
}
