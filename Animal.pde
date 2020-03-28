class Animal {
  PVector location, velocity, acceleration;
  float mass, maxSpeed, maxForce; 

  Animal(PVector start) {
    location = start.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void display() {
    /*float s = mass * 15;
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    fill(0);
    stroke(0);
    triangle(s/2, 0, -s/2, s*0.2, -s/2, -s*0.2);
    popMatrix();*/
  }

  void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  boolean leftCanvas() {
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) return true;
    return false;
  }

  
  void customBehavior(ArrayList<Animal> fishes){
    //whatever
  }
  
  void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }


  void update(ArrayList<Animal> fishes) {
    follow(ff);
    customBehavior(fishes);
    move();
    display();
  }

  void follow(FlowField f) {
    PVector desiredVelocity = f.lookup(location);
    desiredVelocity.setMag(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
}
