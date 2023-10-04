import processing.net.*;


final int N = 128;
final int iter = 16;
final int SCALE = 8;
float t = 0;
int prevMouseX = mouseX;
int prevMouseY = mouseY;
int mx;
int my;
int Y_AXIS = 1;
color b1, b2, b3, b4, b5, b6, b7, b8;

/*****************************************/
Client myClient;
byte[] byteBuffer = new byte[128];
JSONObject json;
/*****************************************/

Fluid fluid;

void settings() {
  //size(N * SCALE, N * SCALE);
  fullScreen();
}

void setup() {
  fluid = new Fluid(0.15, 0, 0.0000001);
  
  /*****************************************/
  //myClient = new Client(this, "127.0.0.1", 5000);
  /*****************************************/
  // Define colors
  b1 = color(79, 0, 112);
  b2 = color(0, 79, 112);
  b3 = color(0, 203, 216);
  b4 = color(35, 148, 0);
  b5 = color(148,224,0);
  b6 = color(255, 228, 0);
  b7 = color(242, 132, 13);
  b8 = color(216,0,0);
}

/*****************************************/
void mouseMoved() {
  fluid.addDensity(mouseX/SCALE, mouseY/SCALE, 700);
  float amtX = mouseX - pmouseX;
  float amtY = mouseY - pmouseY;
  fluid.addVelocity(mouseX/SCALE, mouseY/SCALE, amtX, amtY);
}
/*****************************************/

void draw() {
  background(0, 10);
  
  //if (myClient.available() > 0) { 
    
  //  int byteCount = myClient.readBytesUntil('\n', byteBuffer);
  //  //myClient.clear();
    
  //  if (byteCount > 0 ) {
  //    String myString = new String(byteBuffer);
  //    json = parseJSONObject(myString);
      
  //    if (json != null) {
  //      mx = json.getInt("mouseX");
  //      my = json.getInt("mouseY");
        
  //      fluid.addDensity(mx, my, 7000);
  //      float amtX = mx - prevMouseX;
  //      float amtY = my - prevMouseY;
  //      fluid.addVelocity(my, my, amtX, amtY);
  //      prevMouseX = mx;
  //      prevMouseY = my;
  //    }
  //  }
  //  byteBuffer = new byte[128];
  //}
  
   
  fluid.step();
  fluid.renderD();
  //fluid.renderV();
  fluid.fadeD();
}
