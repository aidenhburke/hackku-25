import SwiftUI

struct FirstTimeUserView: View {
    @AppStorage("username") var storedUsername: String = ""
    @State private var username: String = ""
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to SafeStep")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: 0xEE3233))
                .padding(.top, 50)

            // Username TextField
            TextField("Enter Username", text: $username)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .padding(.horizontal, 40)

            // Proceed Button
            Button(action: {
                if username.isEmpty {
                    alertMessage = "Please enter a username."
                    showAlert = true
                } else {
                    // Save the username and mark the user as logged in
                    storedUsername = username
                }
            }) {
                Text("Proceed")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(username.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }
            .disabled(username.isEmpty)

            Spacer()
        }
        .foregroundColor(Color(hex: 0xCEEBFB))
        .preferredColorScheme(.dark)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Error"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}

#Preview {
    FirstTimeUserView()
}
