import processing.net.*;

final int N = 128;
final int iter = 16;
final int SCALE = 5;
float t = 0;
int prevMouseX = mouseX;
int prevMouseY = mouseY;
int mx;
int my;

/*****************************************/
Client myClient;
byte[] byteBuffer = new byte[128];
JSONObject json;
/*****************************************/

Fluid fluid;

void settings() {
  size(N * SCALE, N * SCALE);
}

void setup() {
  fluid = new Fluid(0.15, 0, 0.0000001);
  
  /*****************************************/
  myClient = new Client(this, "127.0.0.1", 5000);
  /*****************************************/
}

/*****************************************/
//void mouseMoved() {
//  fluid.addDensity(mouseX/SCALE, mouseY/SCALE, 2000);
//  float amtX = mouseX - pmouseX;
//  float amtY = mouseY - pmouseY;
//  fluid.addVelocity(mouseX/SCALE, mouseX/SCALE, amtX, amtY);
//}
/*****************************************/

void draw() {
  background(0, 10);
  
  if (myClient.available() > 0) { 
    
    int byteCount = myClient.readBytesUntil('\n', byteBuffer);
    //myClient.clear();
    
    if (byteCount > 0 ) {
      String myString = new String(byteBuffer);
      json = parseJSONObject(myString);
      
      if (json != null) {
        mx = json.getInt("mouseX");
        my = json.getInt("mouseY");
        
        fluid.addDensity(mx, my, 2000);
        float amtX = mx - prevMouseX;
        float amtY = my - prevMouseY;
        fluid.addVelocity(my, my, amtX, amtY);
        prevMouseX = mx;
        prevMouseY = my;
      }
    }
    byteBuffer = new byte[128];
  }
  
   
  fluid.step();
  fluid.renderD();
  //fluid.renderV();
  fluid.fadeD();
}
