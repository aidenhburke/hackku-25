import SwiftUI

struct FirstTimeUserView: View {
    @State private var showLogin = false
    @State private var showSignUp = false
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Welcome to SafeStep")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .padding(.top, 50)
                
                Spacer()
                
                // Login Button
                Button(action: {
                    self.showLogin = true
                }) {
                    Text("Log In")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                .navigationDestination(isPresented: $showLogin) {
                    LoginView(isLoggedIn: $isLoggedIn)
                }

                // Sign Up Button
                Button(action: {
                    self.showSignUp = true
                }) {
                    Text("Sign Up")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.green)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                .navigationDestination(isPresented: $showSignUp) {
                    SignUpView(isLoggedIn: $isLoggedIn)
                }
                
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
        }
    }
}

struct LoginView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 20) {
                Text("Log In")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.top, 40)

                // Username TextField
                TextField("Username", text: $username)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .autocapitalization(.none)
                    .padding(.horizontal, 40)

                // Password SecureField
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.2))
                    .cornerRadius(10)
                    .foregroundColor(.white)
                    .padding(.horizontal, 40)

                // Log In Button
                Button(action: {
                    // Handle login action
                    print("Logging in with username: \(username) and password: \(password)")
                    isFirstTimeUser = false
                    self.isLoggedIn = true
                }) {
                    Text("Log In")
                        .font(.title2)
                        .padding()
                        .frame(maxWidth: .infinity, minHeight: 60)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .padding(.horizontal, 40)
                }
                Spacer()
            }
            .background(Color.black.ignoresSafeArea())
            .preferredColorScheme(.dark)
        }
    }
}



struct SignUpView: View {
    @State private var username: String = ""
    @State private var password: String = ""
    @State private var confirmPassword: String = ""
    @AppStorage("isFirstTimeUser") var isFirstTimeUser: Bool = true
    @Binding var isLoggedIn: Bool
    
    var body: some View {
        VStack(spacing: 20) {
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.white)
                .padding(.top, 40)

            // Username TextField
            TextField("Username", text: $username)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .autocapitalization(.none)
                .padding(.horizontal, 40)

            // Password SecureField
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 40)

            // Confirm Password SecureField
            SecureField("Confirm Password", text: $confirmPassword)
                .padding()
                .background(Color.white.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.white)
                .padding(.horizontal, 40)

            // Sign Up Button
            Button(action: {
                isFirstTimeUser = false
                self.isLoggedIn = true
                print("Signing up with username: \(username) and password: \(password)")
            }) {
                Text("Sign Up")
                    .font(.title2)
                    .padding()
                    .frame(maxWidth: .infinity, minHeight: 60)
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal, 40)
            }

            Spacer()
        }
        .background(Color.black.ignoresSafeArea())
        .preferredColorScheme(.dark)
    }
}
