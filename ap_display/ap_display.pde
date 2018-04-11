import processing.net.*;

Client ap_client;
int data;

public void setup() {
  size(200, 200);
  ap_client = new Client(this, "localhost", 1920);
}

public void draw() {
  if (ap_client.available() > 0) {
    data = ap_client.read();
  }
  background(data);
}
