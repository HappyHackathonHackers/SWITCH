//
//  SplashView.swift
//  Furina
//
//  Created by Peter Subrata on 21/9/2024.
//

import SwiftUI

struct SplashView: View {
    @State private var navigateToLogin = false
    @State private var splashFinished = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color(hex: "#744CAB")
                    .edgesIgnoringSafeArea(.all) // Set the background color
                
                if !splashFinished {
                    VStack {
                        Image("logo") // Replace with the logoname image
                            .resizable()
                            .scaledToFit()
                            .frame(width: 200, height: 100)

                    }
                    .transition(.opacity)
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 3.5) {
                    withAnimation(.easeOut(duration: 1)) {
                        splashFinished = true
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        navigateToLogin = true
                    }
                }
            }
            .navigationDestination(isPresented: $navigateToLogin) {
                OnboardingView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}


#Preview {
    SplashView()
}
