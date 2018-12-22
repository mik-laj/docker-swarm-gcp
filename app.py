from flask import Flask
from flask import jsonify
from flask import request
import os
import socket

app = Flask(__name__)


@app.route("/ip", methods=["GET"])
def get_my_ip():
    resp = {}
    resp['ip'] = request.remote_addr
    if request.environ.get('HTTP_X_FORWARDED_FOR') is not None:
        resp['for'] = request.environ['HTTP_X_FORWARDED_FOR']
    return jsonify(resp), 200

@app.route("/")
def hello():
    html = "<h1>Hello, Awesome Awesome Some World! </h1>"
    return html

if __name__ == "__main__":
  app.run(host='0.0.0.0', port=80)

