# Flask AWS RDS API

This project is a simple Flask API that polls an AWS RDS instance to retrieve the last five messages stored in the database. It is designed to be containerized using Docker and can be deployed on AWS Fargate.

## Project Structure

```
flask-aws-rds-api
├── src
│   ├── app.py                # Entry point of the Flask application
│   ├── config.py             # Configuration settings for the application
│   ├── database.py           # Database connection logic
│   ├── models
│   │   └── message.py        # Message model definition
│   └── services
│       └── rds_service.py    # RDS service logic for querying messages
├── Dockerfile                 # Instructions to build the Docker image
├── docker-compose.yml         # Service orchestration configuration
├── requirements.txt           # Python dependencies
├── .env.example               # Example environment variables
└── README.md                  # Project documentation
```

## Setup Instructions

1. **Clone the repository:**
   ```bash
   git clone <repository-url>
   cd flask-aws-rds-api
   ```

2. **Create a virtual environment (optional but recommended):**
   ```bash
   python -m venv venv
   source venv/bin/activate  # On Windows use `venv\Scripts\activate`
   ```

3. **Install dependencies:**
   ```bash
   pip install -r requirements.txt
   ```

4. **Configure environment variables:**
   Copy `.env.example` to `.env` and fill in the required values for your AWS RDS instance.

5. **Run the application:**
   You can run the application locally using:
   ```bash
   python src/app.py
   ```

## Docker Instructions

To build and run the application using Docker:

1. **Build the Docker image:**
   ```bash
   docker build -t flask-aws-rds-api .
   ```

2. **Run the Docker container:**
   ```bash
   docker run -p 5000:5000 flask-aws-rds-api
   ```

## Usage

Once the application is running, you can access the API endpoint to retrieve the last five messages. The endpoint is typically available at `http://localhost:5000/messages`.
