
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
int score=0;
int HP = 10;
int level = 0;

PShape mouthDraw;
PShape leftEye; 
PShape rightEye;
PShape leftBro;
PShape rightBro;
float step=0;

PImage[] monsterImages;
PImage[] explosionImages;
PImage[] eyesImages;
PImage red;
PImage[] monster5;
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

  monsterImages = readImages("heihei", 12, 30, 0);
  explosionImages = readExpImages(26, 100, 0);
  eyesImages = readEyeImages("eye", 14, 20, 0);
  red = loadImage("red.png");
  red.resize(30, 0);
  monster5= readMonster5Images(7, 100, 0);


  face = new Face();
}

void draw() {  

//  println(frameRate);
  level = score/10+1;
  background(255, 248, 225);
  stroke(0);
  box2d.step();

  // Simulating particles
  if (random(1) < (2)/100.0) {
    Particle p = new Particle(width+20, random(0+20, height-20), 30);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(-10, -5), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }
  if (random(1) < (2)/100.0) {
    Particle p = new Particle(-20, random(0+20, height-20), 30);
    p.animation=new Animation(monsterImages, 12);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(5, 10), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }


  if (random(1) < (2)/100.0) {
    BallMonster w = new BallMonster(-20, random(0+20, height-20), random(5, 10), random(-5, 5));
    ballMonsters.add(w);
  }
  for (int i = ballMonsters.size ()-1; i >= 0; i--) {
    BallMonster w = ballMonsters.get(i);
    w.display();
    if (w.done()) {
      ballMonsters.remove(i);
    }
  }

  face.track1();
  face.track2();
  face.update();
  if (face.found>0) {
    face.display();
  }
  

  
  for (int i = particles.size ()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    if (face.found>0) {
      p.move(face.eyeLeftPos);
      face.eatCheck(p );
      face.inMouthCheck(p );
      face.inEyesCheck(p );
    }
    if (p.done()) {
      particles.remove(i);
    }
  }

  if (face.eyebrowLeft<7.8 && face.mouthWidth>18.3 && random(1)<0.1) {
    for (float alpha = -PI/2+PI/10; alpha<PI/2; alpha+=PI/10 ) {
      Weapon w1 = new Weapon(face.coorL.x-60, face.coorL.y+40, alpha, -100*cos(alpha), 100*sin(alpha));
      weapons.add(w1);
      Weapon w2 = new Weapon(face.coorR.x+60, face.coorR.y+40, alpha, 100*cos(alpha), 100*sin(alpha));
      weapons.add(w2);
    }
  }


  for (int i=weapons.size ()-1; i>=0; --i) {
    Weapon w = weapons.get(i);
    w.display();
    if (w.done()) {
      weapons.remove(i);
    }
  }


  fill(0, 0, 255);
  textSize(30 );
  text("Score: "+score, 30, 50);
  text("Level "+level, width/2-50, 50);
  fill(255, 0, 0);
  text("HP: "+ HP, width-200, 50);

  //  if (HP<=0) {
  //      fill(255, 0, 0);
  //      rect(0, 0, width, height);
  //      noLoop();
  //    }
}

// OSC CALLBACK FUNCTIONS

void oscEvent(OscMessage m) {
  face.parseOSC(m);
}

void beginContact(Contact cp) {
  // Get both shapes
  Fixture f1 = cp.getFixtureA();
  Fixture f2 = cp.getFixtureB();
  // Get both bodies
  Body b1 = f1.getBody();
  Body b2 = f2.getBody();

  // Get our objects that reference these bodies
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
    } else 
      if (p2.hitted==true) {
      p2.destroyed = true;
      p1.hitted=true;
    }
  } else if (o1.getClass()==Weapon.class&& o2.getClass()==Particle.class) {
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
