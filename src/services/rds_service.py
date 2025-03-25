import pymysql
from config import DB_HOST, DB_PORT, DB_NAME, DB_USER, DB_PASSWORD

def get_connection():
    """Create and return a connection to the database."""
    connection = pymysql.connect(
        host=DB_HOST,
        port=int(DB_PORT) if DB_PORT else 3306,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME,
        cursorclass=pymysql.cursors.DictCursor
    )
    return connection

def get_last_five_messages():
    """Retrieve the last five messages from the database using PyMySQL."""
    connection = get_connection()
    try:
        with connection.cursor() as cursor:
            sql = "SELECT id, message, message_time, created_at FROM exTable ORDER BY created_at DESC LIMIT 5"
            cursor.execute(sql)
            messages = cursor.fetchall()
            
            # Convert the timestamp to string to make it JSON serializable
            for message in messages:
                if 'message_time' in message and message['message_time']:
                    message['message_time'] = message['message_time'].isoformat()
                    
            return messages
    finally:
        connection.close()