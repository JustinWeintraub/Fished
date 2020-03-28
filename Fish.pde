class Fish extends Animal {
  Fish(PVector start){
    super(start);
    mass=1;
    maxSpeed = 2;
    maxForce = 1;
  }
  void display(){
    fill(255,255,0);
    stroke(0);
    translate(location.x,location.y);
    rect(0,0,10,10);
    line(2,2,2,3);
    line(8,2,8,3);
    line(2,7,8,7);
    translate(-location.x,-location.y); 
  }
   void customBehavior(ArrayList<Animal> fishes) {  
    //Neighbors
    float scale = 10.0;
    PVector total = new PVector(0, 0);
    for (Animal fish : fishes) {
      PVector d = PVector.sub(location, fish.location);
      if (d.mag() > 25 && d.mag() < 500) {
        PVector f = d.setMag(scale / d.mag());
        f.limit(maxForce);
        total.add(f);
      }
    }
    total.mult(-1);
    applyForce(total);
    if(location.y<ff.water.y)location.y=ff.water.y;
  }
}
