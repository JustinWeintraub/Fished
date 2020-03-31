class Animal { //base class all animals inherit from
  PVector location, velocity, acceleration;
  float mass, maxSpeed, maxForce; 

  Animal(PVector start) {
    location = start.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  void display() {
  }

  void move() {
    //basic physics movement
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  boolean leftCanvas() {
    //determines if off screen
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) return true;
    return false;
  }

  
  void customBehavior(ArrayList<Animal> fishes){
  }
  
  void applyForce(PVector f) {
    //converts force to acceleration
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }


  void update(ArrayList<Animal> fishes) {
    //calls child functions for fishes
    follow(ff);
    customBehavior(fishes);
    move();
    display();
  }

  void follow(FlowField f) {
    //moves animal based on flowfield
    PVector desiredVelocity = f.lookup(location);
    desiredVelocity.setMag(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
}
