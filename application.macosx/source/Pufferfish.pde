class Pufferfish extends Animal {
  Pufferfish(PVector start){
    super(start);
    mass=10;
    maxSpeed = 1;
    maxForce = 1;
  }
  void display(){
    fill(#ffa500);
    stroke(0);
    translate(location.x,location.y);
    //rotate(velocity.mag()/(2*PI));
    ellipse(0,0,10,10);
    line(2,2,2,3);
    translate(-location.x,-location.y); 
  }
  void customBehavior(ArrayList<Animal> fishes) {  
    for (int j=animals.size()-1; j>=0; j--){
      if(abs(animals.get(j).location.x-location.x)<10){
        if(abs(animals.get(j).location.y-location.y)<10){
            if(!(animals.get(j) instanceof Pufferfish)){
              animals.remove(j);
            }
        }
      }
    }
  }
}