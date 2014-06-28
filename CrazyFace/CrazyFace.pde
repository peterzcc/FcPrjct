import ddf.minim.spi.*;
import ddf.minim.signals.*;
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.ugens.*;
import ddf.minim.effects.*;
import oscP5.*;
OscP5 oscP5;

import shiffman.box2d.*;
import processing.video.*;

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
ArrayList<Dog> dogs = new ArrayList<Dog>();
int score=0;
int level = 0;
Boolean playing = false;
int mode;
int tag;
int start=0;
int cartoon=4;
int play=1;
int pause=2;
int replay=3;
int start_time=-1;

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
PImage[] monster5, wormIm, dogIm;
PImage back;
PImage start_button;
Movie cartoon1;
AudioPlayer music;
Minim minim; 
AudioPlayer eatSound, exploSound, hurtSound;
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

  red = loadImage("red.png");
  start_button=loadImage("start.png");
  red.resize(48, 0);
  start_button.resize(100,0);
  monster5= readMonster5Images(7, 160, 0);
  wormIm = readEyeImages("data/worm/", 11, 400, 0);
  //  wormIm[0] = loadImage("worm.png" );wormIm[0].resize(400,0);

  //  dogIm = new PImage[1];dogIm[0] = loadImage("monster1.png");dogIm[0].resize(200,0);
  dogIm = readEyeImages("data/dog/", 10, 200, 0);
  back = loadImage("beijing2.png");
  face = new Face();
  mode=cartoon;
  tag=0;

  minim = new Minim(this);
  eatSound = minim.loadFile("eat.wav");
  exploSound = minim.loadFile("explosion.wav");
  hurtSound = minim.loadFile("scream.mp3");
  music = minim.loadFile("music.mp3");

  button1= new button(displayWidth/2-400, displayHeight/2-200, 50);
  cartoon1=new Movie(this, "cartoon3.mov");
  cartoon1.loop();
}

void draw() {  
  //  background(back);
  //image(back,0,0);
  stroke(0);
  if ((mode==play||mode==pause)&&(face.LHealth<0&&face.RHealth<0)) {
    mode=replay;
    tag=1;
  }
  if (mode==cartoon&& face.found>0) {
    mode=start;
    music.pause();
  }

  if (mode==play&&face.found==0) {
    mode=pause;
  }
  if (mode==pause&&face.found>0) {
    mode=play;
  }
  if (mode==pause) {
    image(back, 0, 0);
    box2d.step();
    addMonsters();
    updateMonsters();
    fill(0, 0, 255);
    textSize(30 );
    text("Score: "+score, 30, 50);
    text("Level "+level, width/2-50, 50);
    
    if (face.found>0) start_time=-1;
    else {
      if (start_time ==-1)
      {
        start_time =millis();
      }else if ((millis()-start_time)>=30000) {
        mode=cartoon;
        start_time=-1;
        face = new Face();
        particles = new ArrayList<Particle>();
        weapons = new ArrayList<Weapon>();
        ballMonsters = new ArrayList<BallMonster>();
        button1= new button(displayWidth/2-400, displayHeight/2-200, 50);
        score=0;
        level=1;
        tag=0;
        cartoon1.loop();
      }
    }
    
  } 
  
  else if (mode==replay) {
    image(back, 0, 0);
    if (tag==1) {
      face = new Face();
      particles = new ArrayList<Particle>();
      weapons = new ArrayList<Weapon>();
      ballMonsters = new ArrayList<BallMonster>();
      button1= new button(displayWidth/2-400, displayHeight/2-200, 50);
      score=0;
      level=1;
      tag=0;
    }
    box2d.step();
    face.track1();
    face.track2();
    face.update();
    if (face.found>0) {
      face.display();
    }
    startdisplay();
    startgame();
    if (face.found>0) start_time=-1;
    else {
      if (start_time ==-1)
      {
        start_time =millis();
      }else if ((millis()-start_time)>=30000) {
        mode=cartoon;
        start_time=-1;
        cartoon1.loop();
      }
    }
  } else if (mode==start) {

    image(back, 0, 0);
    box2d.step();
    face.track1();
    face.track2();
    face.update();
    if (face.found>0) {
      face.display();
    }
    startdisplay();
    startgame();
    cartoon1.stop();
    if (face.found>0) start_time=-1;
    else {
      if (start_time ==-1)
      {
        start_time =millis();
      }else if ((millis()-start_time)>=30000) {
        mode=cartoon;
        start_time=-1;
        cartoon1.loop();
      }
    }
  } else if (mode==play) {
    image(back, 0, 0);
    box2d.step();
    face.track1();
    face.track2();
    face.update();
    if (face.found>0) {
      face.display();
    }
    addMonsters();
    updateMonsters();
    handleSpecialSkill();
    fill(0, 0, 255);
    textSize(30 );
    text("Score: "+score, 30, 50);
    text("Level "+level, width/2-50, 50);
  } else if (mode==cartoon) {
    pushMatrix();
    scale(1.1);
    imageMode(CENTER );
    image(cartoon1, width/2-40, height/2-40);
    imageMode(CORNER );
    popMatrix();
    if (!music.isLooping() || !music.isPlaying()) {
      music.rewind();
      music.loop();
    }
  }  
  //  fill(0, 0, 255);
  //  textSize(30 );
  //  text("Score: "+score, 30, 50);
  //  text("Level "+level, width/2-50, 50);
  // println(face.RHealth + " " + face.LHealth);

  println(mode);
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
  } else if (o1.getClass()==Weapon.class&& o2.getClass()==Particle.class) {
    Particle p2=(Particle) o2;
    p2.hitted=true;
    p2.destroyed=true;
    exploSound.rewind();
    exploSound.play();
  } else if (o2.getClass()==Weapon.class && o1.getClass()==Particle.class) {
    Particle p1=(Particle) o1;
    p1.hitted=true;
    p1.destroyed=true;
    exploSound.rewind();
    exploSound.play();
  } else if (o1.getClass()==button.class || o2.getClass()==button.class) {
    exploSound.rewind();
    exploSound.play();
  }
}

// Objects stop touching each other
void endContact(Contact cp) {
}

void mousePressed() {
}

void movieEvent(Movie m) {
  m.read();
}
