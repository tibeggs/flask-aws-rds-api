import psycopg2
import psycopg2.extras
from config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD

def get_connection():
    """Create and return a connection to the PostgreSQL database."""
    connection = psycopg2.connect(
        host=DB_HOST,
        port=int(DB_PORT) if DB_PORT else 5432,  # PostgreSQL default port is 5432
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )
    return connection

def get_last_five_messages():
    """Retrieve the last five messages from the database using PostgreSQL."""
    connection = get_connection()
    try:
        with connection.cursor(cursor_factory=psycopg2.extras.DictCursor) as cursor:
            sql = "SELECT id, message, message_time, created_at FROM extable ORDER BY created_at DESC LIMIT 5"
            cursor.execute(sql)
            messages = cursor.fetchall()
            
            # Convert DictCursor results to regular dictionaries
            result = []
            for message in messages:
                message_dict = dict(message)
                # Convert the timestamp to string to make it JSON serializable
                if 'message_time' in message_dict and message_dict['message_time']:
                    message_dict['message_time'] = message_dict['message_time'].isoformat()
                result.append(message_dict)
                
            return result
    finally:
        connection.close()