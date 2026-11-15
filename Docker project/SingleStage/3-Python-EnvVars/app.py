from flask import Flask, jsonify
import os

app = Flask(__name__)

@app.route('/')
def home():
    db_host = os.getenv('DB_HOST', 'localhost')
    db_port = os.getenv('DB_PORT', '5432')
    env = os.getenv('ENV', 'development')
    
    return jsonify({
        "message": "Hello from Flask!",
        "environment": env,
        "database": {
            "host": db_host,
            "port": db_port
        }
    })

@app.route('/config')
def config():
    return jsonify({
        "DB_HOST": os.getenv('DB_HOST', 'not set'),
        "DB_PORT": os.getenv('DB_PORT', 'not set'),
        "ENV": os.getenv('ENV', 'not set')
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
