//
//  OnboardingView.swift
//  Furina
//
//  Created by Peter Subrata on 21/9/2024.
//

import SwiftUI

struct OnboardingView: View {
    @State private var showingSignIn = true
    @State private var isLoggedIn = false

    var body: some View {
        if isLoggedIn {
            TabsView()
        } else {
            if showingSignIn {
                LoginView(showingSignIn: $showingSignIn, isLoggedIn: $isLoggedIn)
            } else {
                CreateAccountView(showingSignIn: $showingSignIn)
            }
        }
    }
}

struct CreateAccountView: View {
    @Binding var showingSignIn: Bool
    @State private var email = ""
    @State private var password = ""

    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Create your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "CE4711"))
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Email")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "CE4711"))
                
                TextField("Email", text: $email)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
            }
            .padding(.horizontal)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("Password")
                    .font(.subheadline)
                    .fontWeight(.bold)
                    .foregroundColor(Color(hex: "CE4711"))
                
                SecureField("Password", text: $password)
                    .padding()
                    .background(Color.white.opacity(0.7))
                    .cornerRadius(10)
            }
            .padding(.horizontal)
            
            Button(action: {
            }) {
                Text("SIGN UP")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex: "CE4711"))
                    .cornerRadius(10)
                    .foregroundColor(.white)
            }
            .padding(.horizontal)
            
            Text("or sign up with")
            foregroundColor(Color(hex: "CE4711"))
            
            HStack {
                
                Text("Already a user?")
                    .foregroundColor(Color(hex: "#CE4711"))
                Button(action: {
                    withAnimation {
                        showingSignIn = true
                    }
                }) {
                    Text("LOGIN")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "#CE4711"))
                }
            }
            .padding(.top, 70)
            
            Spacer()
        }
        .background(Color(hex: "FCB814"))
        .edgesIgnoringSafeArea(.all)
    }
}


struct LoginView: View {
    @Binding var showingSignIn: Bool
    @State private var email = ""
    @State private var password = ""
    @Binding var isLoggedIn: Bool
    
    private let dummyEmail = "user01"
    private let dummyPassword = "user01"
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            Text("Sign in your account")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color(hex: "#CE4711"))
            
            
            TextField("Email", text: $email)
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .keyboardType(.emailAddress)
                .autocapitalization(.none)
                .padding(.horizontal)
            
            SecureField("Password", text: $password)
                .padding()
                .background(Color.white.opacity(0.7))
                .cornerRadius(10)
                .padding(.horizontal)
            
            Button(action: {
                if email == dummyEmail && password == dummyPassword {
                    withAnimation {
                        isLoggedIn = true
                    }
                } else {
                    print("Invalid credentials")
                }
            }) {
                Text("SIGN IN")
                    .fontWeight(.bold)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(hex:"#CE4711"))
                    .cornerRadius(10)
                    .foregroundColor(Color(hex:"#ffffff"))
            }
            .padding(.horizontal)
            
            Text("or sign in with")
                .foregroundColor(Color(hex:"#CE4711"))
                .padding(.top, 10)
            
            HStack(spacing: 20) {
                
                Button(action: {
                    
                }) {
                    Image(systemName: "globe")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "#40E0D0"))
                        .cornerRadius(10)
                }
                
                Button(action: {
                }) {
                    Image(systemName: "f.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "#40E0D0"))
                        .cornerRadius(10)
                }
                
                Button(action: {
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .background(Color(hex: "#40E0D0"))
                        .cornerRadius(10)
                }
            }
            .padding(.top, 20)
            
            
            Spacer()
            
            HStack {
                Text("Need an account?")
                    .foregroundColor(Color(hex: "CE4711"))
                Button(action: {
                    withAnimation {
                        showingSignIn = false
                    }
                }) {
                    Text("SIGN UP")
                        .fontWeight(.bold)
                        .foregroundColor(Color(hex: "CE4711"))
                }
            }
            .padding(.bottom, 30)
        }
        .background(Color(hex: "#744CAB"))
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    OnboardingView()
}
