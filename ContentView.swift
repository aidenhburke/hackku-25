import SwiftUI

struct ContentView: View {
    @State private var isMonitoring = false
    @State private var lastFallDate: Date? = nil
    @State private var responseTime: TimeInterval? = nil

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Title
            Text("SafeStep")
                .font(.largeTitle)
                .bold()
                .foregroundColor(.purple)
                .padding(.horizontal)

            // Monitoring Status
            HStack {
                Text(isMonitoring ? "Monitoring Active" : "Monitoring Paused")
                    .font(.headline)
                    .foregroundColor(.white)
                Circle()
                    .fill(isMonitoring ? Color.green : Color.red)
                    .frame(width: 12, height: 12)
            }
            .padding(.horizontal)

            // Monitoring Toggle
            Toggle(isOn: $isMonitoring) {
                Text("Fall Detection Monitor")
                    .font(.headline)
                    .foregroundColor(.white)
            }
            .toggleStyle(SwitchToggleStyle(tint: .green))
            .padding(.horizontal)
            .frame(maxWidth: .infinity, alignment: .leading)

            // Last Fall Info
            VStack(alignment: .leading, spacing: 8) {
                Text("Last Fall Detected")
                    .font(.subheadline)
                    .bold()
                    .foregroundColor(.white)
                if let date = lastFallDate {
                    Text("Date: \(date.formatted(date: .abbreviated, time: .standard))")
                        .foregroundColor(.white)
                    if let response = responseTime {
                        Text("Response Time: \(Int(response)) seconds")
                            .foregroundColor(.white)
                    }
                } else {
                    Text("No falls detected yet.")
                        .foregroundColor(.gray)
                }
            }
            .padding()
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(Color(.systemGray5))
            .cornerRadius(12)
            .padding(.horizontal)

            Spacer()
        }
        .padding(.top)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

struct SettingsView: View {
    var body: some View {
        VStack {
            Text("Settings Page")
                .foregroundColor(.white)
                .font(.title)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

struct ContactsView: View {
    var body: some View {
        VStack {
            Text("Contacts Page")
                .foregroundColor(.white)
                .font(.title)
                .padding()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    init() {
        UITabBar.appearance().backgroundColor = UIColor.darkGray
        UITabBar.appearance().barTintColor = UIColor.black
        UITabBar.appearance().unselectedItemTintColor = UIColor.lightGray
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
        .accentColor(.purple)
        .preferredColorScheme(.dark)
    }
}
