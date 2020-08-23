#!/usr/bin/python3
#    openssl req -new -x509 -keyout server.pem -out server.pem -days 365 -nodes
# run as follows:
#    python myssl.py
# then in your browser/curl -k, visit:
#    https://localhost:5000
# 
from http.server import BaseHTTPRequestHandler, HTTPServer
from urllib.parse import urlparse
import ssl


class SimpleHTTPRequestHandler(BaseHTTPRequestHandler):

     def inspect_master(self):
         self.send_response(200)
         self.end_headers()
         self.wfile.write(b'{"skip_rules":["hiya","hiyb","helo","test_service"]}')


     def info(self):
         self.send_response(200)
         self.end_headers()
         self.wfile.write(b'{"nodes":["127.0.0.1"], "services":{"test_service": ["127.0.0.1"]}}')

     def do_GET(self):
         # expect: curl -ks https://127.0.0.1:5000/inspect/master
         path = urlparse(self.path).path
         print(f"path is {path}")
         if path == "/":
             self.info()
         elif path == "/inspect/master":
             self.inspect_master()
         else:
             self.send_response(404)
             self.end_headers()
             self.wfile.write(b'{"error":"Not Found"}')

httpd = HTTPServer(('localhost', 443), SimpleHTTPRequestHandler)
httpd.socket = ssl.wrap_socket (httpd.socket, certfile='./server.pem',
server_side=True)
httpd.serve_forever()

