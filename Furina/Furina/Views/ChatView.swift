import SwiftUI
import Combine

struct ChatView: View {
    @ObservedObject var chatViewModel: ChatViewModel
    @State private var newMessage: String = ""

    init(userId: Int) {
        // Initialize the view model with the userId
        chatViewModel = ChatViewModel(userId: userId)
    }

    var body: some View {
        VStack {
            // Top bar with back button and progress bar
            HStack {
                Button(action: {
                    // Back button action
                }) {
                    Image(systemName: "arrow.left")
                        .foregroundColor(.purple)
                }
                Spacer()
                
                // Progress bar
                VStack {
                    Text("Mission Progress Bar")
                        .font(.caption)
                        .foregroundColor(.purple)
                }
            }
            .padding(.horizontal)
            
            // Chat area
            ScrollView {
                VStack(alignment: .leading, spacing: 10) {
                    ForEach(chatViewModel.messages, id: \.id) { message in
                        MessageBubble(message: message)
                    }
                }
                .padding()
            }
            .background(Color.white)
            
            // Message input field
            HStack {
                TextField("Type a message", text: $newMessage)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minHeight: 30)
                
                Button(action: {
                    chatViewModel.handleMessage(text: newMessage)
                    newMessage = ""
                }) {
                    Image(systemName: "paperplane.fill")
                        .foregroundColor(.purple)
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
        }
        .onAppear {
            chatViewModel.connect()
        }
        .onDisappear {
            chatViewModel.disconnect()
        }
    }
}

struct MessageBubble: View {
    let message: ChatMessage
    
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            if message.isSentByCurrentUser {
                Spacer()
                Text(message.text)
                    .padding()
                    .background(Color.purple.opacity(0.2))
                    .cornerRadius(20)
                    .foregroundColor(.purple)
            } else {
                VStack(alignment: .leading) {
                    Text(message.sender)
                        .font(.caption)
                        .foregroundColor(.purple)
                    Text(message.text)
                        .padding()
                        .background(Color.purple.opacity(0.1))
                        .cornerRadius(20)
                        .foregroundColor(.black)
                }
                Spacer()
            }
        }
    }
}

struct ChatMessage: Identifiable {
    let id: UUID
    let sender: String
    let text: String
    let isSentByCurrentUser: Bool
}

// ViewModel to manage WebSocket connection and chat data
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    private var webSocketTask: URLSessionWebSocketTask?
    private var userId: Int
    
    let missionMessage = "My missions are: \n 1. Go to Aunburn Lake with me, \n 2. Get llao llao Yoghurt with me, \n 3. Find me a rock in the staobao beach. "
    let defaultResponses = ["You got it", "Thank you", "Awesome"]

    init(userId: Int) {
        self.userId = userId
    }
    
    func connect() {
        let url = URL(string: "ws://localhost:8000/ws/\(userId)")!
        webSocketTask = URLSession.shared.webSocketTask(with: url)
        webSocketTask?.resume()
        receiveMessages()  // Start receiving messages
    }
    
    func disconnect() {
        webSocketTask?.cancel(with: .goingAway, reason: nil)
    }
    
    // Handle the incoming message logic
    func handleMessage(text: String) {
        // First, append the user's message to the chat
        DispatchQueue.main.async {
            let sentMessage = ChatMessage(id: UUID(), sender: "You", text: text, isSentByCurrentUser: true)
            self.messages.append(sentMessage)
        }
        
        // Then handle system responses based on the content of the message
        if text.lowercased() == "!task" {
            sendSystemMessage(text: missionMessage)
        } else {
            // Otherwise, pick a random response
            let randomResponse = defaultResponses.randomElement() ?? "You got it"
            sendSystemMessage(text: randomResponse)
        }
        
        // Finally, send the message via WebSocket
        sendMessage(text: text)
    }
    
    private func sendMessage(text: String) {
        let messageData = ["userId": "\(userId)", "text": text]
        
        // Convert dictionary to JSON string instead of data (bytes)
        if let jsonData = try? JSONSerialization.data(withJSONObject: messageData, options: []),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            
            let message = URLSessionWebSocketTask.Message.string(jsonString)  // Use .string instead of .data
            webSocketTask?.send(message) { error in
                if let error = error {
                    print("WebSocket send error: \(error)")
                }
            }
        }
    }
    
    private func sendSystemMessage(text: String) {
        // Send a system-generated message
        DispatchQueue.main.async {
            let systemMessage = ChatMessage(id: UUID(), sender: "System", text: text, isSentByCurrentUser: false)
            self.messages.append(systemMessage)
        }
    }
    
    private func receiveMessages() {
        webSocketTask?.receive { [weak self] result in
            switch result {
            case .failure(let error):
                print("WebSocket receive error: \(error)")
            case .success(let message):
                switch message {
                case .data(let data):
                    if let messageDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: String],
                       let senderId = messageDict["userId"],
                       let text = messageDict["text"] {
                        
                        // Check if the message is sent by the current user or another
                        let isSentByCurrentUser = senderId == "\(self?.userId ?? 0)"
                        let senderName = isSentByCurrentUser ? "You" : "Friend"
                        
                        DispatchQueue.main.async {
                            let receivedMessage = ChatMessage(id: UUID(), sender: senderName, text: text, isSentByCurrentUser: isSentByCurrentUser)
                            self?.messages.append(receivedMessage)
                        }
                    }
                default:
                    break
                }
                
                // Continue receiving more messages
                self?.receiveMessages()
            }
        }
    }
}

#Preview {
    ChatView(userId: 1)
}
