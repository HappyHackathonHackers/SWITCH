 
import SwiftUI

struct MissionView: View {
    @State private var myMissions = [
        "1. Go to Auburn Lake with me.",
        "2. Get llao llao with me.",
        "3. Go to staobao beach with me."
    ]
    
    @State private var availableMission = Mission(id: 1, name: "Cassie", image: "person.circle", tasks: [
        "Play Monopoly",
        "Eat llao llao together",
        "Take a selfie with me"
    ])
    
    var body: some View {
        NavigationView {
            VStack {
                // Top Section - My Mission
                VStack(alignment: .leading) {
                    HStack {
                        Text("My Mission")
                            .font(.title)
                            .foregroundColor(.purple)
                        Spacer()
                        Button(action: {
                            // Info action
                        }) {
                            Image(systemName: "info.circle")
                                .foregroundColor(.purple)
                        }
                    }
                    .padding(.top)
                    
                    ForEach(myMissions.indices, id: \.self) { index in
                        // TextField for each mission
                        TextField("Mission \(index + 1)", text: $myMissions[index])
                            .textFieldStyle(RoundedBorderTextFieldStyle())
                            .foregroundColor(.purple)
                            .padding(.vertical, 5)
                    }
                }
                .padding()
                .background(Color.purple.opacity(0.1))
                .cornerRadius(20)
                .padding(.horizontal)
                
                Spacer()
                
                // Available Mission Section
                VStack {
                    Text("Missions Available")
                        .font(.title2)
                        .foregroundColor(.purple)
                    
                    // Mission Card
                    VStack {
                        Image(systemName: availableMission.image)
                            .resizable()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .padding(.bottom, 10)
                        
                        Text(availableMission.name)
                            .font(.title)
                            .foregroundColor(.purple)
                            .padding(.bottom)
                        
                        ForEach(availableMission.tasks.indices, id: \.self) { index in
                            Text("\(index + 1). \(availableMission.tasks[index])")
                                .padding(.vertical, 2)
                        }
                        
                        // Navigate to ChatView when accepting the mission
                        NavigationLink(destination: ChatView(userId: availableMission.id)) {
                            Text("ACCEPT MISSION")
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.purple)
                                .cornerRadius(10)
                        }
                        .padding(.top)
                    }
                    .padding()
                    .background(Color.purple.opacity(0.1))
                    .cornerRadius(20)
                    .shadow(radius: 5)
                    .padding(.horizontal)
                }
                
                Spacer()
            }
        }
    }
}

struct NavigationButton: View {
    var imageName: String
    var title: String
    
    var body: some View {
        VStack {
            Image(systemName: imageName)
            Text(title)
                .font(.footnote)
        }
        .frame(maxWidth: .infinity)
    }
}

struct Mission: Identifiable {
    let id: Int
    let name: String
    let image: String
    let tasks: [String]
}

struct MissionView_Previews: PreviewProvider {
    static var previews: some View {
        MissionView()
    }
}
