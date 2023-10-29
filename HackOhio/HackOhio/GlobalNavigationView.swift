//
//  GlobalNavigationView.swift
//  HackOhio
//
//  Created by Tyler Mox on 10/28/23.
//
import SwiftUI
import Charts

struct GlobalNavigationView: View {
    var body: some View {
        NavigationView {
            TabView {
                NavigationView {
                    ActivationView()
                }
                .tabItem {
                    Label("Activate", systemImage: "1.circle.fill")
                }
                .tag(0)

                NavigationView {
                    StatsView()
                }
                .tabItem {
                    Label("Statistics", systemImage: "2.circle.fill")
                }
                .tag(1)

                NavigationView {
                    CalibrateView()
                }
                .tabItem {
                    Label("Calibrate", systemImage: "3.circle.fill")
                }
                .tag(2)

                NavigationView {
                    AccountView()
                }
                .tabItem {
                    Label("Account", systemImage: "4.circle.fill")
                }
                .tag(3)
            }
        }
    }
}

struct ActivationView: View {
    @State private var showAlert = false
    @State private var isOn = false
    
    func makeRequest(to endpoint: String) {
            guard let url = URL(string: "http://localhost:3000/\(endpoint)") else {
                print("Invalid URL")
                return
            }
            
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("Error: \(error)")
                } else if let httpResponse = response as? HTTPURLResponse {
                    print("Response status code: \(httpResponse.statusCode)")
                }
            }.resume()
        }
    
    var body: some View {
        ZStack {
            Image("dog")
                .resizable()
                .frame(width: 875, height: 875)
            
            VStack {
                Text("Welcome, User")
                    .font(.system(size: 30, weight: .bold))
                    .padding(.top, 100)
                    .padding(.trailing, 150)
                
                Spacer()
                
                // Add back-end functionality for button here
                Button(action: {
                    isOn = !isOn
                    showAlert = true
                    if !isOn {
                        makeRequest(to: "turn-on")
                    } else {
                        makeRequest(to: "turn-off")
                    }
                }) {
                    Circle()
                        .frame(width: 130, height: 130)
                        .foregroundColor(.darkgreen)
                        .overlay(
                            Image("power-button")
                                .resizable()
                                .frame(width: 85, height: 85)
                        )
                }
                .offset(y: 150)
                Spacer()
                
                Rectangle()
                    .frame(height: 90)
                    .foregroundColor(.tan)
            }
            .alert(isPresented: $showAlert) {
                if isOn {
                    return Alert(
                        title: Text("Device Activated"),
                        message: Text("The Device has been Activated Successfully!"),
                        dismissButton: .default(Text("OK"))
                    )
                } else {
                    return Alert(
                        title: Text("Device Deactivated"),
                        message: Text("The Device has been Deactivated Successfully!"),
                        dismissButton: .default(Text("OK"))
                    )
                }
            }
        }
    }
}

struct StatsView: View {
    var body: some View {
        Text("Statistic View Content Goes Here")
    }
}

struct AccountView: View {
    var body: some View {
        NavigationView {
            VStack {
                Image("user-avatar") // Replace with your user's avatar image
                    .resizable()
                    .frame(width: 100, height: 100)
                    .clipShape(Circle())
                    .padding(.top, 20)

                Text("John Doe")
                    .font(.title)
                    .padding(.top, 10)

                Text("john.doe@example.com")
                    .font(.subheadline)
                    .foregroundColor(.gray)

                Spacer()

                VStack {
                    NavigationLink(destination: EditProfileView()) {
                        Text("Edit Profile")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 10)

                    NavigationLink(destination: ChangePasswordView()) {
                        Text("Change Password")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 10)
                }

                Spacer()

                Button(action: {
                    // BACK END SIGN OUT
                }) {
                    Text("Sign Out")
                        .foregroundColor(.red)
                        .font(.title)
                }
                .padding(.bottom, 20)
            }
            .padding(20)
            .navigationBarTitle("Account")
        }
    }
}

struct EditProfileView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var newPassword = ""
    @State private var isForgotPasswordActive = false

    var body: some View {
        VStack {
            Text("Edit Profile")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)


            // Button to reset password
            Button(action: {
                isForgotPasswordActive = true
            }) {
                Text("Forgot Password?")
                    .font(.subheadline)
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 20)

            Button(action: {
                // Handle profile update logic
            }) {
                Text("Update Profile")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)

        }
        .padding()
        .fullScreenCover(isPresented: $isForgotPasswordActive) {
            ForgotPasswordView()
        }
    }
}

struct ForgotPasswordView: View {
    @State private var username = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showErrorAlert = false
    @State private var isPasswordResetSuccessful = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            VStack {
                Form {
                    Section(header: Text("Username")) {
                        SecureField("Username", text: $username)
                    }
                    Section(header: Text("New Password")) {
                        SecureField("New Password", text: $newPassword)
                    }
                    Section(header: Text("Confirm Password")) {
                        SecureField("Confirm Password", text: $confirmPassword)
                    }

                    // Button to submit
                    Section {
                        Button(action: {
                            if newPassword == confirmPassword {
                                // Perform password reset logic in the backend
                                // You can add your backend logic here
                                isPasswordResetSuccessful = true
                            } else {
                                showErrorAlert = true
                            }
                        }) {
                            Text("Change Password")
                        }
                    }
                }
            }
            .padding(20)
            .navigationBarTitle("Change Password")
            .alert(isPresented: $showErrorAlert) {
                Alert(title: Text("Password Mismatch"), message: Text("New passwords do not match."), dismissButton: .default(Text("OK")))
            }
            .navigationBarItems(leading: Button("Back") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}







struct ChangePasswordView: View {
    @State private var currentPassword = ""
    @State private var newPassword = ""
    @State private var confirmPassword = ""
    @State private var showErrorAlert = false

    var body: some View {
        VStack {
            Form {
                // Field for the Current password of the user
                Section(header: Text("Current Password")) {
                    SecureField("Current Password", text: $currentPassword)
                }
                
                // Field for the new password and confirm new
                Section(header: Text("New Password")) {
                    SecureField("New Password", text: $newPassword)
                    SecureField("Confirm New Password", text: $confirmPassword)
                }
                
                // Button to submit
                Section {
                    Button(action: {
                        if newPassword == confirmPassword {
                            // UPDATE IN BACKEND
                        } else {
                            showErrorAlert = true
                        }
                    }) {
                        Text("Change Password")
                    }
                }
            }
        }
        .padding(20)
        .navigationBarTitle("Change Password")
        .alert(isPresented: $showErrorAlert) {
            Alert(title: Text("Password Mismatch"), message: Text("New passwords do not match."), dismissButton: .default(Text("OK")))
        }
    }
}

struct LoginView: View {
    @State private var username = ""
    @State private var password = ""
    @State private var isSignUpActive = false

    var body: some View {
        NavigationView {
            VStack {
                Image("logo")
                    .resizable()
                    .frame(width: 100, height: 100)
                    .padding(.bottom, 30)
                
                Text("Login")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 20)

                TextField("Username", text: $username)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 10)

                SecureField("Password", text: $password)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)

                Button(action: {
                    // Handle login logic
                }) {
                    Text("Login")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)

                Spacer()

                NavigationLink(
                    destination: SignUpView(),
                    isActive: $isSignUpActive
                ) {
                    EmptyView()
                }
                
                Button(action: {
                    isSignUpActive = true
                }) {
                    Text("Don't have an account? Sign Up")
                        .font(.subheadline)
                        .foregroundColor(.blue)
                }
            }
            .padding()
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
    }
}

struct SignUpView: View {
    @State private var username = ""
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack {
            Text("Sign Up")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)

            TextField("Username", text: $username)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            TextField("Email", text: $email)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal, 20)
                .padding(.bottom, 10)

            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 20)
                .padding(.bottom, 20)

            Button(action: {
                // Handle sign-up logic
            }) {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.horizontal, 20)
        }
        .padding()
    }
}

struct CalibrateView: View {
    @State private var isPressing = false
    @State private var progress: Double = 0.0
    @State private var timer: Timer?

    var body: some View {
        VStack {
            Text("Calibrate")
                .font(.largeTitle)
                .bold()
                .padding(.bottom, 20)
            
            Button(action: {
                if isPressing {
                    stopTimer()
                } else {
                    startTimer()
                }
                isPressing.toggle()
            }) {
                Text("Press and Hold")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 150, height: 150)
                    .background(isPressing ? Color.green : Color.blue)
                    .cornerRadius(75)
            }
            
            Text("Progress: \(Int(progress)) seconds")
            
            Spacer()
        }
        .padding()
    }

    func startTimer() {
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if progress < 15.0 {
                progress += 1.0
                if progress == 15.0 {
                    isPressing.toggle()
                }
            } else {
                stopTimer()
            }
        }
    }

    func stopTimer() {
        timer?.invalidate()
        timer = nil
        progress = 0.0
    }
}


#Preview {
    GlobalNavigationView()
}
