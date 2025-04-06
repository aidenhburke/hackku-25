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
            
            Spacer()
            
            // Username TextField
            TextField(
                "",
                text: $username,
                prompt: Text("Username").foregroundColor(Color(hex: 0xF0ECEB))
            )
            .padding()
            
            .background(Color(hex: 0x66A7C5).opacity(0.8))
            .cornerRadius(10)
            .frame(maxWidth: .infinity, minHeight: 200)
            .foregroundColor(.white)
            .autocapitalization(.none)
            .padding(.horizontal, 40)
            
            Text("Enter Your Name In the Text Field Above")
                .font(.system(size: 25))
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: 0xEE3233))
                .padding(.top, 10)
            
            Spacer()
            
            // Proceed Button
            Button(action: {
                if username.isEmpty {
                    alertMessage = "Please enter your name."
                    showAlert = true
                } else {
                    // Save the username and mark the user as logged in
                    storedUsername = username
                }
            }) {
                Text("Proceed")
                    .font(.title2)
                    .padding()
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(username.isEmpty ? Color(hex: 0x6C7476) : Color(hex: 0x66A7C5))
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
        .background(Color(hex: 0xCEEBFB))
    }
}
