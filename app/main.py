
from flask import Flask, jsonify

app = Flask(__name__)

@app.route("/")
def home():
    return jsonify({
        "project": "Automated Cloud Security & DevSecOps Vulnerability Pipeline",
        "security": "Security testing enabled",
        "status": "Application running"
    })

@app.route("/health")
def health():
    return jsonify({
        "status": "healthy"
    })

@app.route("/info")
def info():
    return jsonify({
        "application": "Cloud Security Pipeline",
        "version": "1.0",
        "framework": "Flask",
        "purpose": "Automated vulnerability detection"
    })

if __name__ == "__main__":
    app.run(host="127.0.0.1", port=5000, debug=False)
