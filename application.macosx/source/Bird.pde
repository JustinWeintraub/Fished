class Bird extends Animal {
  Animal target;
  Bird(PVector start){
    super(start);
    mass=10;
    maxSpeed = map(abs(randomGaussian()),0,3,2,4);
    maxForce = 2;
  }
  void display(){
    fill(0);
    stroke(0);
    translate(location.x,location.y); 
    rect(0,0,10,10);
    translate(-location.x,-location.y);
  }
  void targetFind(ArrayList<Animal> fishes){
    for (Animal fish : fishes) {
      if(abs(location.x-fish.location.x)<5 && int(random(50))==9){
       target=fish;
      }
    }
  }
  void seek() {
    PVector desiredVelocity = PVector.sub(target.location, location);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  boolean reached() {
    float d = PVector.sub(target.location, location).mag();
    if (d < 5) return true;
    return false;
  }
  void customBehavior(ArrayList<Animal> fishes) {   
    //Target finding
    targetFind(fishes);
    if(target==null && location.y>ff.water.y/1.05)applyForce(new PVector(0,-10).limit(maxForce/2));
    if(target!=null){
      seek();
      if(reached()){
        for (int j=animals.size()-1; j>=0; j--){
          if((animals.get(j)==target)){
            animals.remove(j);
          }
        }
      target=null;
      }
    }
  }
}