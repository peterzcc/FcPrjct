import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;



import oscP5.*;
OscP5 oscP5;

import shiffman.box2d.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.joints.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.contacts.*;


Box2DProcessing box2d;

// our FaceOSC tracked face dat
Face face;
ArrayList<Particle> particles;
ArrayList<Weapon> weapons;
ArrayList<BallMonster> ballMonsters;
ArrayList<Worm> worms = new ArrayList<Worm>();
int score=0;
int level = 0;
Boolean playing = false;
int mode;

PShape mouthDraw; PShape leftEye;  PShape rightEye;PShape leftBro; PShape rightBro;
float step=0;

PImage[] monsterImages; PImage[] explosionImages; PImage[] eyesImages;
PImage red;
PImage[] monster5,wormIm;
PImage back;

Minim minim; AudioPlayer eatSound,exploSound,hurtSound;
button button1;
void setup() {
  size(1024, 768, P2D);
  frameRate(60);
  oscP5 = new OscP5(this, 8338);

  // Initialize box2d
  box2d = new Box2DProcessing(this);
  box2d.createWorld();
  box2d.step(1/60.0, 8, 3);
  box2d.listenForCollisions();
  particles = new ArrayList<Particle>();
  weapons = new ArrayList<Weapon>();
  ballMonsters = new ArrayList<BallMonster>();

  monsterImages = readImages("heihei", 12, 48, 0);
  explosionImages = readExpImages(26, 160, 0);
  eyesImages = readEyeImages("eye", 14, 20, 0);
  red = loadImage("red.png");
  red.resize(48, 0);
  monster5= readMonster5Images(7, 160, 0);
  wormIm = new PImage[1];wormIm[0] = loadImage("worm.png" );wormIm[0].resize(400,0);
  
  back = loadImage("beijing.png");
  face = new Face();
  
  minim = new Minim(this);
  eatSound = minim.loadFile("eat.wav");
  exploSound = minim.loadFile("explosion.wav");
  hurtSound = minim.loadFile("scream.wav");
  
  button1= new button(displayWidth/2-400,displayHeight/2-200,50);

}

void draw() {  
  
  println(frameRate);
//  background(back);
  image(back,0,0);
  stroke(0);
  box2d.step();
  face.track1();
  face.track2();
  face.update();
  if (face.found>0) {
    face.display();
  }
  
 if(mode==0){
    startdisplay();
    startgame();
    
  }else
  if (mode==1){
  addMonsters();
  updateMonsters();
  handleSpecialSkill();
  fill(0, 0, 255);
  textSize(30 );
  text("Score: "+score, 30, 50);
  text("Level "+level, width/2-50, 50);
  }


}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

void beginContact(Contact cp) {
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  
  Object o1 = b1.getUserData();
  Object o2 = b2.getUserData();
  if (face.found>0) {
    if ( o1.getClass()==Particle.class && o2.getClass() == Face.class) {
      Particle p1=(Particle) o1;
      p1.hitted=true;
    } else if (o1.getClass() == Face.class && o2.getClass()==Particle.class) {
      Particle p2=(Particle) o2;
      p2.hitted=true;
    }
  }
  if (o1.getClass()==Particle.class && o2.getClass()==Particle.class) {
    Particle p1=(Particle) o1;
    Particle p2=(Particle) o2;
    if (p1.hitted==true) {
      p1.destroyed=true;
      p2.hitted=true;
      exploSound.rewind();
      exploSound.play();
    } else 
      if (p2.hitted==true) {
      p2.destroyed = true;
      p1.hitted=true;
      exploSound.rewind();
      exploSound.play();
    }
  } 
  else if (o1.getClass()==Weapon.class&& o2.getClass()==Particle.class) {
    Particle p2=(Particle) o2;
    p2.hitted=true;
    p2.destroyed=true;
  } else if (o2.getClass()==Weapon.class && o1.getClass()==Particle.class) {
    Particle p1=(Particle) o1;
    p1.hitted=true;
    p1.destroyed=true;
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
}

void mousePressed(){
}
