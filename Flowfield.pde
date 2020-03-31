class FlowField {
  int resolution, numrows, numcols; 
  PVector[][] flow;
  boolean showFlow;
  PVector water=new PVector(0,0);
  FlowField(int r, float barrier) {
    resolution = r;
    numrows = height/resolution;
    numcols = width/resolution;
    flow = new PVector[numrows][numcols];
    setFlow();
    showFlow = true;
    water.y=barrier;
  }

  void setFlow() {
    //Flow field that determines movement is based off of
    //2d random noise determined based on part of screen
    for (int row = 0; row < numrows; row++) {
      for (int col = 0; col < numcols; col++) {
        // flow[row][col] = PVector.random2D();
        //simulates wind
        if(row*resolution<water.y)flow[row][col] = new PVector(-1, map(noise((frameCount+col)/100.0),0,1,.75,-.50));
        //randomGaussian if in water
        else flow[row][col] = new PVector(-1, randomGaussian());
      }
    }
  }

  void display() {
    fill(#0077be, 150);
    noStroke();
    rect(water.x,water.y,width,height);
    if (showFlow == false) return;
    for (int row = 0; row < float(numrows)/height*water.y; row++) {
      for (int col = numcols-int(random(1,100)); col >= 0; col-=int(random(1,100))) {
        //wind is drawn in a few locations on the screen
        PVector p = flow[row][col];
        pushMatrix();
        translate(col*resolution, row*resolution);
        stroke(175);
        rotate(p.heading());
        line(-randomGaussian()/2.5*resolution, 0, randomGaussian()/2.5*resolution, 0);
        //line(0.3*resolution, 0, 0.1*resolution, 0.2*resolution);
        //line(0.3*resolution, 0, 0.1*resolution, -0.2*resolution);
        popMatrix();
      }
      }
    
  }


  PVector lookup(PVector position) {
    //gets flowfield at a particular location
    int col = int(constrain(position.x/resolution, 0, numcols-1));
    int row = int(constrain(position.y/resolution, 0, numrows-1));
    return flow[row][col];
  }
  
  void update(){
    setFlow();
    display();
  }
}
