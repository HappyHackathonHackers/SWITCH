# Swift & FastAPI Project

This project is a combination of a SwiftUI frontend and FastAPI backend. The Swift app interacts with the FastAPI backend to manage users, retrieve friends, and handle missions. The missions feature allows users to chat and complete tasks.

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

   ```bash
   cd api
   ```
2. Set up the environment variables by creating a .env file. Make sure to provide your SQLALCHEMY_DATABASE_URI with the correct username, password, and database name.
   ```bash
   echo "SQLALCHEMY_DATABASE_URI=postgresql://<username>:<password>@localhost/<database>" > .env
   ```
3. Set up the database migrations using SQLAlchemy (or Alembic):
   ```bash
   alembic init migrations
   alembic revision --autogenerate -m "Initial migration"
   alembic upgrade head
  ```
4. Run the FastAPI server using Uvicorn:
```bash
uvicorn app.main:app --reload
```

