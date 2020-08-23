#!/usr/bin/python3

from http.server import BaseHTTPRequestHandler, HTTPServer

PORT = 84 

class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.end_headers()
        self.wfile.write(b'Test Message')

with HTTPServer(('0.0.0.0', PORT), SimpleHTTPRequestHandler) as httpd:
    print("serving at port", PORT)
    httpd.serve_forever()

