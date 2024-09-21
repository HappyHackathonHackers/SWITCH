import SwiftUI

struct FriendsPage: View {
    // Sample friend data
    @State private var friends = [
        Friend(id: 12, name: "Jocelin", isRequest: false),
        Friend(id: 2, name: "Alex", isRequest: false)
    ]
    
    @State private var friendRequests = [
        Friend(id: 3, name: "Maria", isRequest: true),
        Friend(id: 4, name: "John", isRequest: true)
    ]
    
    @State private var selectedFriend: Friend? = nil
    
    var body: some View {
        NavigationView {
            List {
                // Friends List Section
                Section(header: Text("Friends")) {
                    ForEach(friends) { friend in
                        NavigationLink(
                            destination: ChatView(userId: friend.id), // Pass friend.id as userId
                            label: {
                                FriendRow(friend: friend)
                            }
                        )
                    }
                }
                
                // Friend Requests Section
                Section(header: Text("Friend Requests")) {
                    ForEach(friendRequests) { request in
                        HStack {
                            FriendRow(friend: request)
                            
                            Spacer()
                            
                            Button("Accept") {
                                acceptFriendRequest(request: request)
                            }
                            .padding(5)
                            .background(Color.green)
                            .foregroundColor(.white)
                            .cornerRadius(5)
                        }
                    }
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Friends")
        }
    }
    
    // Function to handle friend request acceptance
    private func acceptFriendRequest(request: Friend) {
        if let index = friendRequests.firstIndex(where: { $0.id == request.id }) {
            friendRequests.remove(at: index)
            friends.append(request)
        }
    }
}

// FriendRow displays individual friend or request in the list
struct FriendRow: View {
    let friend: Friend
    
    var body: some View {
        HStack {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
            
            VStack(alignment: .leading) {
                Text(friend.name)
                    .font(.headline)
                
                Text(friend.isRequest ? "Friend Request" : "Friend")
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

// Friend model
struct Friend: Identifiable {
    let id: Int
    let name: String
    let isRequest: Bool
}

// Preview
struct FriendsPage_Previews: PreviewProvider {
    static var previews: some View {
        FriendsPage()
    }
}
