int IX(int x, int y) {
  x = constrain(x, 0, N-1);
  y = constrain(y, 0, N-1);
  return x + (y * N);
}


class Fluid {
  int size;
  int numOfSections;
  float sectionSize;
  float dt;
  float diff;
  float visc;

  float[] s;
  float[] density;

  float[] Vx;
  float[] Vy;

  float[] Vx0;
  float[] Vy0;

  Fluid(float dt, float diffusion, float viscosity) {

    this.size = N;
    this.numOfSections = 8;
    this.sectionSize = (this.size * SCALE) / this.numOfSections;
    this.dt = dt;
    this.diff = diffusion;
    this.visc = viscosity;

    this.s = new float[N*N];
    this.density = new float[N*N];

    this.Vx = new float[N*N];
    this.Vy = new float[N*N];

    this.Vx0 = new float[N*N];
    this.Vy0 = new float[N*N];
  }

  void step() {
    int N          = this.size;
    float visc     = this.visc;
    float diff     = this.diff;
    float dt       = this.dt;
    float[] Vx      = this.Vx;
    float[] Vy      = this.Vy;
    float[] Vx0     = this.Vx0;
    float[] Vy0     = this.Vy0;
    float[] s       = this.s;
    float[] density = this.density;

    diffuse(1, Vx0, Vx, visc, dt);
    diffuse(2, Vy0, Vy, visc, dt);

    project(Vx0, Vy0, Vx, Vy);

    advect(1, Vx, Vx0, Vx0, Vy0, dt);
    advect(2, Vy, Vy0, Vx0, Vy0, dt);

    project(Vx, Vy, Vx0, Vy0);

    diffuse(0, s, density, diff, dt);
    advect(0, density, s, Vx, Vy, dt);
  }

  void addDensity(int x, int y, float amount) {
    int index = IX(x, y);
    this.density[index] += amount;
  }

  void addVelocity(int x, int y, float amountX, float amountY) {
    int index = IX(x, y);
    this.Vx[index] += amountX;
    this.Vy[index] += amountY;
  }

  void renderD() {
    colorMode(HSB, 255);
    
    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float d = this.density[IX(i, j)];
        
        fill((d + 50) % 255,200,d);
        noStroke();
        square(x, y, SCALE); 
              
        //push();
        
        //if (y >= 0 && y <= this.sectionSize * 1) {
        //  //fill(255,255,204); // yellow
        //  //fill((d + 50) % 60,200,d);
        //  fill(d % 60,200,d);
        //} else if (y > this.sectionSize * 1 && y <= this.sectionSize * 2) {
        //  //fill(255, 68, 51); // orange
        //  //fill((d + 50) % 39,200,d);
        //  fill(d % 100,200,d);
        //} else if (y > this.sectionSize * 2 && y <= this.sectionSize * 3) {
        //  //fill(255,0,0); // red
        //  fill((d + 50) % 10,200,d);
        //} else if (y > this.sectionSize * 3 && y <= this.sectionSize * 4) {
        //  //fill(135, 206, 235); // sky blue
        //  fill((d + 50) % 197,200,d);
        //} else if (y > this.sectionSize * 4 && y <= this.sectionSize * 5) {
        //  //fill(0,0,255); // blue
        //  fill((d + 50) % 150,200,d);
        //} else if (y > this.sectionSize * 5 && y <= this.sectionSize * 6) {
        //  //fill(0,0,128); // navy blue
        //  fill((d + 100) % 200,200,d);
        //} else if (y > this.sectionSize * 6 && y <= this.sectionSize * 7) {
        //  //fill(128,0,128); // purple 
        //  fill((d + 50) % 50,200,d);
        //} else if (y > this.sectionSize * 7 && y <= this.sectionSize * 8) {
        //  //fill(169,169,169); // dark grey
        //  fill((d + 50) % 120,200,d);
        //}
        
        //noStroke();
        ////stroke(0);
        ////ellipse(x, y, SCALE, SCALE);
        //square(x, y, SCALE);
        ////circle(x, y, SCALE);

        //pop();     
      }
    }
  }

  void renderV() {

    for (int i = 0; i < N; i++) {
      for (int j = 0; j < N; j++) {
        float x = i * SCALE;
        float y = j * SCALE;
        float vx = this.Vx[IX(i, j)];
        float vy = this.Vy[IX(i, j)];
        stroke(255);

        if (!(abs(vx) < 0.1 && abs(vy) <= 0.1)) {
          line(x, y, x+vx*SCALE, y+vy*SCALE );
        }
      }
    }
  }

  void fadeD() {
    for (int i = 0; i < this.density.length; i++) {
      float d = density[i];
      //density[i] = constrain(d-0.02, 0, 1500);
      density[i] = density[i] - 0.25;
      
      if (density[i] < -10) {
        density[i] = 0;
      }
    }
  }
}
