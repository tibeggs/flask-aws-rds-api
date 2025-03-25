from flask import Flask, jsonify
# from config import Config
from services.rds_service import get_last_five_messages

app = Flask(__name__)
# app.config.from_object(Config)

@app.route('/messages', methods=['GET'])
def messages():
    try:
        last_five_messages = get_last_five_messages()
        return jsonify(last_five_messages), 200
    except Exception as e:
        return jsonify({"error": str(e)}), 500

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)