from fastapi import FastAPI, Depends, WebSocket, WebSocketDisconnect
from sqlalchemy.orm import Session
from .database import SessionLocal, engine
from . import models
from pydantic import BaseModel
from typing import List
import json

# Create the tables in the database
models.Base.metadata.create_all(bind=engine)

app = FastAPI()

class ConnectionManager:
    def __init__(self):
        self.active_connections: List[WebSocket] = []

    async def connect(self, websocket: WebSocket):
        await websocket.accept()
        self.active_connections.append(websocket)

    def disconnect(self, websocket: WebSocket):
        self.active_connections.remove(websocket)

    async def broadcast(self, message: dict):
        # Create a list of websockets to remove in case they disconnect
        disconnected_connections = []
        
        for connection in self.active_connections:
            try:
                await connection.send_json(message)
            except Exception as e:
                print(f"Error sending message to connection: {e}")
                # If the connection fails, mark it for removal
                disconnected_connections.append(connection)

        # Remove any disconnected clients
        for connection in disconnected_connections:
            self.disconnect(connection)
            
@app.websocket("/ws/{user_id}")
async def websocket_endpoint(websocket: WebSocket, user_id: str):
    await manager.connect(websocket)
    try:
        while True:
            message = await websocket.receive()
            
            # Check if the message is text or another type
            if "text" in message:
                data = message["text"]
                # Process the text message (assuming it's JSON)
                try:
                    message_data = json.loads(data)
                    message_data["userId"] = user_id  # Attach sender user_id
                    await manager.broadcast(message_data)  # Broadcast message to all users
                except json.JSONDecodeError as e:
                    print(f"Invalid JSON data from user {user_id}: {data} - Error: {e}")
            else:
                print(f"Received non-text message from user {user_id}: {message}")
    except WebSocketDisconnect:
        manager.disconnect(websocket)
        print(f"User {user_id} disconnected.")

manager = ConnectionManager()


# Dependency to get a database session
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

# Pydantic model for user input validation
class UserCreate(BaseModel):
    name: str
    age: int
    university: str
    major: str
    country: str
    interests: List[str]

@app.get("/users/")
def read_users(db: Session = Depends(get_db)):
    users = db.query(models.User).all()
    return users

# POST route to insert a new user into the database
@app.post("/users/")
def create_user(user: UserCreate, db: Session = Depends(get_db)):
    db_user = models.User(  # Create SQLAlchemy model instance here
        name=user.name,
        age=user.age,
        university=user.university,
        major=user.major,
        country=user.country,
        interests=user.interests
    )
    db.add(db_user)  # Add the SQLAlchemy model to the session
    db.commit()  # Commit the transaction
    db.refresh(db_user)  # Refresh to get the newly created ID
    return db_user  # Return the newly created user
