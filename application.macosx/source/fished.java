import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class fished extends PApplet {

FlowField ff;
ArrayList<Animal> animals = new ArrayList<Animal>();
public void setup() {
  //size(500, 500);
  
  ff = new FlowField(10, height/1.75f);
}
public void draw() {
  //background(#FAFFFF);
  background(0xffFFEBC6);
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
    PVector locate=new PVector(width-10, map(random(1),0,1,0,ff.water.y/1.1f));
    animals.add(new Bird(locate));
  }
  if (frameCount%180 ==0) {
    PVector locate=new PVector(width-10, map(random(1),0,1,ff.water.y,width));
    animals.add(new Pufferfish(locate));
  }
}
class Animal {
  PVector location, velocity, acceleration;
  float mass, maxSpeed, maxForce; 

  Animal(PVector start) {
    location = start.copy();
    velocity = new PVector(0, 0);
    acceleration = new PVector(0, 0);
  }

  public void display() {
    /*float s = mass * 15;
    pushMatrix();
    translate(location.x, location.y);
    rotate(velocity.heading());
    fill(0);
    stroke(0);
    triangle(s/2, 0, -s/2, s*0.2, -s/2, -s*0.2);
    popMatrix();*/
  }

  public void move() {
    velocity.add(acceleration);
    location.add(velocity);
    acceleration.mult(0);
  }
  public boolean leftCanvas() {
    if (location.x < 0 || location.x > width || location.y < 0 || location.y > height) return true;
    return false;
  }

  
  public void customBehavior(ArrayList<Animal> fishes){
    //whatever
  }
  
  public void applyForce(PVector f) {
    PVector a = f.copy().div(mass);
    acceleration.add(a);
  }


  public void update(ArrayList<Animal> fishes) {
    follow(ff);
    customBehavior(fishes);
    move();
    display();
  }

  public void follow(FlowField f) {
    PVector desiredVelocity = f.lookup(location);
    desiredVelocity.setMag(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
}
class Bird extends Animal {
  Animal target;
  Bird(PVector start){
    super(start);
    mass=10;
    maxSpeed = map(abs(randomGaussian()),0,3,2,4);
    maxForce = 2;
  }
  public void display(){
    fill(0);
    stroke(0);
    translate(location.x,location.y); 
    rect(0,0,10,10);
    translate(-location.x,-location.y);
  }
  public void targetFind(ArrayList<Animal> fishes){
    for (Animal fish : fishes) {
      if(abs(location.x-fish.location.x)<5 && PApplet.parseInt(random(50))==9){
       target=fish;
      }
    }
  }
  public void seek() {
    PVector desiredVelocity = PVector.sub(target.location, location);
    desiredVelocity.limit(maxSpeed);
    PVector steer = PVector.sub(desiredVelocity, velocity);
    steer.limit(maxForce);
    applyForce(steer);
  }
  public boolean reached() {
    float d = PVector.sub(target.location, location).mag();
    if (d < 5) return true;
    return false;
  }
  public void customBehavior(ArrayList<Animal> fishes) {   
    //Target finding
    targetFind(fishes);
    if(target==null && location.y>ff.water.y/1.05f)applyForce(new PVector(0,-10).limit(maxForce/2));
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
class Fish extends Animal {
  Fish(PVector start){
    super(start);
    mass=1;
    maxSpeed = 2;
    maxForce = 1;
  }
  public void display(){
    fill(255,255,0);
    stroke(0);
    translate(location.x,location.y);
    rect(0,0,10,10);
    line(2,2,2,3);
    line(8,2,8,3);
    line(2,7,8,7);
    translate(-location.x,-location.y); 
  }
   public void customBehavior(ArrayList<Animal> fishes) {  
    //Neighbors
    float scale = 10.0f;
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

  public void setFlow() {

    for (int row = 0; row < numrows; row++) {
      for (int col = 0; col < numcols; col++) {
        // flow[row][col] = PVector.random2D();
        if(row*resolution<water.y)flow[row][col] = new PVector(-1, map(noise((frameCount+col)/100.0f),0,1,.75f,-.50f));
        else flow[row][col] = new PVector(-1, randomGaussian());
      }
    }
  }

  public void display() {
    fill(0xff0077be, 150);
    noStroke();
    rect(water.x,water.y,width,height);
    if (showFlow == false) return;
    for (int row = 0; row < PApplet.parseFloat(numrows)/height*water.y; row++) {
      for (int col = numcols-PApplet.parseInt(random(1,100)); col >= 0; col-=PApplet.parseInt(random(1,100))) {
        PVector p = flow[row][col];
        pushMatrix();
        translate(col*resolution, row*resolution);
        stroke(175);
        rotate(p.heading());
        line(-randomGaussian()/2.5f*resolution, 0, randomGaussian()/2.5f*resolution, 0);
        //line(0.3*resolution, 0, 0.1*resolution, 0.2*resolution);
        //line(0.3*resolution, 0, 0.1*resolution, -0.2*resolution);
        popMatrix();
      }
      }
    
  }


  public PVector lookup(PVector position) {
    int col = PApplet.parseInt(constrain(position.x/resolution, 0, numcols-1));
    int row = PApplet.parseInt(constrain(position.y/resolution, 0, numrows-1));
    return flow[row][col];
  }
  
  public void update(){
    setFlow();
    display();
  }
}
class Pufferfish extends Animal {
  Pufferfish(PVector start){
    super(start);
    mass=10;
    maxSpeed = 1;
    maxForce = 1;
  }
  public void display(){
    fill(0xffffa500);
    stroke(0);
    translate(location.x,location.y);
    //rotate(velocity.mag()/(2*PI));
    ellipse(0,0,10,10);
    line(2,2,2,3);
    translate(-location.x,-location.y); 
  }
  public void customBehavior(ArrayList<Animal> fishes) {  
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
  public void settings() {  fullScreen(); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--present", "--window-color=#666666", "--stop-color=#cccccc", "fished" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
