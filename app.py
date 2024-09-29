# app.py

from flask import Flask

app = Flask(__name__)

@app.route('/')
def hello():
    return "Hello, World! This is your Dockerized Python Flask application."

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5001)
