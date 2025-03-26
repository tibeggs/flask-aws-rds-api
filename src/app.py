from flask import Flask, jsonify, request
# from config import Config
from services.rds_service import get_last_five_messages
from services.sqs_service import send_message_to_queue

app = Flask(__name__)
# app.config.from_object(Config)

@app.route('/messages', methods=['GET'])
def messages():
    try:
        last_five_messages = get_last_five_messages()
        return jsonify(last_five_messages), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

@app.route('/messages', methods=['POST'])
def post_message():
    try:
        # Get JSON data from request
        message_data = request.get_json()
        
        if not message_data:
            return jsonify({"error": "No message data provided"}), 400
            
        # Validate required fields
        if 'message' not in message_data:
            return jsonify({"error": "Message content is required"}), 400
            
        # Send message to SQS queue
        response = send_message_to_queue(message_data)
        
        return jsonify({
            "message": "Message sent to queue successfully",
            "message_id": response.get('MessageId')
        }), 202
    except ValueError as e:
        return jsonify({"error": str(e)}), 400
    except Exception as e:
        return jsonify({"error": f"Failed to send message: {str(e)}"}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)