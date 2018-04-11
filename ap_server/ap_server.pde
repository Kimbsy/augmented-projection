import processing.net.*;

Server ap_server;
int val = 0;

void setup() {
  size(200, 200);
  ap_server = new Server(this, 1920);
}

void draw() {
  val = (val + 1) % 255;
  background(val);
  ap_server.write(val);
}
