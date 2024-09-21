import SwiftUI

// Profile model
struct Profile: Identifiable, Codable {
    let id: Int
    let name: String
    let age: Int
    let university: String
    let major: String
    let country: String
    let interests: [String]
}

struct HomeView: View {
    @State private var profiles: [Profile] = []
    @State private var isLoading = true
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            // Top Section for Points
            VStack {
                Text("My Points")
                    .font(.title)
                    .padding(.top)
                
                Text("0 Friendship points")
                Text("0 Charisma points")
                
                HStack(spacing: 20) {
                    Button("STORE") {
                        // Action for store button
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    
                    Button("MY COUPONS") {
                        // Action for coupons button
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.purple)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
            }
            .padding()
            .background(Color.purple.opacity(0.1))
            .cornerRadius(20)
            
            Spacer()
            
            if isLoading {
                ProgressView()
                    .padding()
            } else if let errorMessage = errorMessage {
                Text("Error: \(errorMessage)")
                    .foregroundColor(.red)
                    .padding()
            } else {
                // Carousel Section
                TabView {
                    ForEach(profiles) { profile in
                        ProfileCard(profile: profile)
                    }
                }
                .frame(height: 450) // Adjusted height
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
            }

            Spacer()
        }
        .padding()
        .onAppear {
            fetchProfiles()
        }
    }
    
    // Fetch profiles from the API
    private func fetchProfiles() {
        guard let url = URL(string: "http://localhost:8000/users") else {
            errorMessage = "Invalid URL"
            isLoading = false
            return
        }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    errorMessage = error.localizedDescription
                    isLoading = false
                }
                return
            }

            guard let data = data else {
                DispatchQueue.main.async {
                    errorMessage = "No data received"
                    isLoading = false
                }
                return
            }

            do {
                let decodedProfiles = try JSONDecoder().decode([Profile].self, from: data)
                DispatchQueue.main.async {
                    profiles = decodedProfiles
                    isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    errorMessage = "Failed to decode data: \(error.localizedDescription)"
                    isLoading = false
                }
            }
        }.resume()
    }
}

struct ProfileCard: View {
    let profile: Profile
    
    var body: some View {
        VStack(spacing: 15) {
            // Profile image placeholder
            Image(systemName: "person.circle")
                .resizable()
                .frame(width: 100, height: 100)
                .clipShape(Circle())
                .padding(.bottom, 10)
            
            Text("\(profile.name), \(profile.age)")
                .font(.title)
                .foregroundColor(.purple)
            
            Text(profile.university)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(profile.major)
                .font(.subheadline)
                .foregroundColor(.gray)
            Text(profile.country)
                .font(.subheadline)
                .foregroundColor(.gray)
            
            HStack {
                ForEach(profile.interests, id: \.self) { interest in
                    Text(interest)
                        .padding(5)
                        .background(Color.purple.opacity(0.2))
                        .cornerRadius(5)
                }
            }
            .padding(.top, 5)
            
            // Add Friend button
            Button(action: {
                // Action for add friend
            }) {
                Text("Add Friend")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.green)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .padding(.top, 10)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.purple.opacity(0.1))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

struct CustomPlaceholderTextField: View {
    var placeholder: Text
    @Binding var text: String
    var editingChanged: (Bool) -> Void = { _ in }
    var commit: () -> Void = { }

    var body: some View {
        ZStack(alignment: .leading) {
            if text.isEmpty { placeholder }
            TextField("", text: $text, onEditingChanged: editingChanged, onCommit: commit)
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
