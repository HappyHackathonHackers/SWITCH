# Furina

Furina is a Friend finder app helps students in university to find friends by completing missions together. Through the completion of missions, students can earn friendship points and charismatic points which can be used to exchange for food vouchers/coupons vendors supported by Universities such as RMIT. This encourages university students to go out of their comfort zone to complete these challenges and provides an opportunity for them to interact with the outside world. 


This project is a combination of a SwiftUI frontend and FastAPI backend. The Swift app interacts with the FastAPI backend to manage users, retrieve friends, and handle missions. The missions feature allows users to chat and complete tasks.

figma link: https://www.figma.com/design/tem3MolQ07OMc2ywphXFCb/FURINA?node-id=0-1&node-type=canvas&t=sfc6fhgEt9ilGUUi-0


Video Demo: https://drive.google.com/file/d/1aExutEdiWWN1yOts_u6oHiBOlxfZONnD/view?usp=sharing

## Prerequisites

- Python 3.10+
- Swift 5.5+
- Xcode 13+
- FastAPI
- SQLAlchemy
- Uvicorn

## Setup Instructions

### Step 1: Setting up the FastAPI Backend

1. Clone this repository and navigate to the `api` directory:

   `
   cd api
   `
   
3. Set up the environment variables by creating a .env file. Make sure to provide your SQLALCHEMY_DATABASE_URI with the correct username, password, and database name.
   `
   echo "SQLALCHEMY_DATABASE_URI=postgresql://<username>:<password>@localhost/<database>" > .env
   `

4. Set up the database migrations using SQLAlchemy (or Alembic):
   `
   alembic init migrations
   alembic revision --autogenerate -m "Initial migration"
   alembic upgrade head
   `

5. Run the FastAPI server using Uvicorn:
`
uvicorn app.main:app --reload
`

The API will now be accessible at http://localhost:8000.  

Step 2: Running the Swift App
`
	1.	Open the Swift project in Xcode.  
 
	2.	Build and run the project.  
 
	3.	On the login page, enter the following credentials:  
 
	•	Username: user01  
 
	•	Password: user01  
 `


Open localhost:8080/docs to see specific API specification.
 
