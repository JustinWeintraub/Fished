FlowField ff;
ArrayList<Animal> animals = new ArrayList<Animal>();
void setup() {
  //size(500, 500);
  fullScreen();
  ff = new FlowField(10, height/1.75);
}
void draw() {
  //background(#FAFFFF);
  background(#FFEBC6);
  ff.update();
  for (int i = animals.size()-1; i >= 0; i--) {
    Animal a = animals.get(i);
    ArrayList<Animal> fishes = new ArrayList<Animal>();
    for (int j=animals.size()-1; j>=0; j--){
    if((animals.get(j) instanceof Fish)){
      fishes.add(animals.get(j));
    }
    }
    a.update(fishes);
    if (animals.size()-1>i &&a.leftCanvas()) animals.remove(i);
  }
  if (frameCount%60 ==0) {
    PVector locate=new PVector(width-10, map(random(1),0,1,ff.water.y,width));
    animals.add(new Fish(locate));
  }
  if (frameCount%120 ==0) {
    PVector locate=new PVector(width-10, map(random(1),0,1,0,ff.water.y/1.1));
    animals.add(new Bird(locate));
  }
  if (frameCount%180 ==0) {
    PVector locate=new PVector(width-10, map(random(1),0,1,ff.water.y,width));
    animals.add(new Pufferfish(locate));
  }
}