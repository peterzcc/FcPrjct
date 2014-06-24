
void handleSpecialSkill() {
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
}

void addMonsters() {
  if (random(1) < (1.5)/100.0) {
    Particle p = new Particle(width+20, random(0+20, height-20), 30);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(-10, -5), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }
  if (random(1) < (1.5)/100.0) {
    Particle p = new Particle(-20, random(0+20, height-20), 30);
    p.animation=new Animation(monsterImages, 12);
    particles.add(p);
    p.body.setLinearVelocity(new Vec2(random(5, 10), random(-5, 5)));
    p.body.setAngularVelocity(random(-1, 1));
  }
  if (random(1) < (0.5)/100.0) {
    BallMonster w = new BallMonster(-20, random(0+20, height-20), random(5, 10), random(-5, 5));
    ballMonsters.add(w);
  }
}

void updateMonsters() {
  for (int i = ballMonsters.size ()-1; i >= 0; i--) {
    BallMonster w = ballMonsters.get(i);
    w.display();
    if (w.done()) {
      ballMonsters.remove(i);
    }
  }  
  for (int i = particles.size ()-1; i >= 0; i--) {
    Particle p = particles.get(i);
    p.display();
    if (face.found>0) {
      p.move(face.eyeLeftPos);
      p.eatCheck(face );
      p.inMouthCheck(face );
      p.inEyesCheck(face);
    }
    if (p.done()) {
      particles.remove(i);
    }
  }
}

PImage[]  readImages(String prefix, int num, int scaleX, int scaleY) {
  PImage[] images = new PImage[num];
  for (int i=0; i<num; ++i) {
    String name = prefix+nf(i, 4)+".png";
    images[i]= loadImage(name);
    images[i].resize(scaleX, scaleY);
  }
  return images;
}

PImage[]  readEyeImages(String prefix, int num, int scaleX, int scaleY) {
  PImage[] images = new PImage[num];
  for (int i=0; i<num; ++i) {
    String name = prefix+i+".png";
    //      println(name);
    images[i]= loadImage(name);
    images[i].resize(scaleX, scaleY);
  }
  return images;
}

PImage[]  readExpImages( int num, int scaleX, int scaleY) {
  PImage[] images = new PImage[num];
  for (int i=0; i<num; ++i) {
    int index = i+1;
    String name = "data/explosion/"+index+".png";
    images[i]= loadImage(name);
    images[i].resize(scaleX, scaleY);
  }
  return images;
}

PImage[]  readMonster5Images( int num, int scaleX, int scaleY) {
  PImage[] images = new PImage[num];
  for (int i=0; i<num; ++i) {
    int index = i+1;
    String name = "data/monster5/"+index+".png";
    images[i]= loadImage(name);
    images[i].resize(scaleX, scaleY);
  }
  return images;
}

float browCenterY=-1.4604;

PVector CenterOfWeight(PVector[] vertices) {
  PVector center = new PVector();
  for (PVector vertex : vertices) {
    center.add(vertex);
  }
  center.div(vertices.length);
  return center;
}

Vec2[] PVectorToVec2(PVector[] points) {
  Vec2[] result=new Vec2[points.length];
  for (int i=points.length-1; i>=0; --i) {
    result[points.length-1-i]=box2d.coordPixelsToWorld(points[i].x, points[i].y);
  }
  return result;
}

//_________________________________________________________________________


//  int inPolyCheck(float x, float y,PVector[] z) {
//    float a = 0;
//    PVector v = new PVector(x, y);
//    for (int i =0; i<z.length-1; i++) {
//      PVector v1 = z[i].get();
//      PVector v2 = z[i+1].get();
//      a += vAtan2cent180(v, v1, v2);
//    }
//    PVector v1 = z[z.length-1].get();
//    PVector v2 = z[0].get();
//    a += vAtan2cent180(v, v1, v2);
//
//    if (abs(abs(a) - TWO_PI) < 0.01) return 1;
//    else return 0;
//  }

Boolean inPolyCheck(float x, float y, PVector[] z) {
  float a = 0;
  PVector v = new PVector(x, y);
  for (int i =0; i<z.length-1; i++) {
    PVector v1 = z[i].get();
    PVector v2 = z[i+1].get();
    a += vAtan2cent180(v, v1, v2);
  }
  PVector v1 = z[z.length-1].get();
  PVector v2 = z[0].get();
  a += vAtan2cent180(v, v1, v2);

  if (abs(abs(a) - TWO_PI) < 0.01) return true;
  else return false;
}


float vAtan2cent180(PVector cent, PVector v2, PVector v1) {
  PVector vA = v1.get();
  PVector vB = v2.get();
  vA.sub(cent);
  vB.sub(cent);
  vB.mult(-1);
  float ang = atan2(vB.x, vB.y) - atan2(vA.x, vA.y);
  if (ang < 0) ang = TWO_PI + ang;
  ang-=PI;
  return ang;
}

/*
  rightBro=createShape();
 rightBro.beginShape();
 for (PVector rightBroVertex : face.geyeBR) {
 rightBro.vertex(rightBroVertex.x, rightBroVertex.y);
 }
 rightBro.endShape(CLOSE);
 shape(rightBro);
 
 leftBro=createShape();
 leftBro.beginShape();
 for (PVector leftBroVertex : face.geyeBL) {
 leftBro.vertex(leftBroVertex.x, leftBroVertex.y);
 }
 leftBro.endShape(CLOSE);
 shape(leftBro);
 */
/*
  rightEye=createShape();
 rightEye.beginShape();
 for (PVector rightEyeVertex : face.geyeR) {
 rightEye.vertex(rightEyeVertex.x, rightEyeVertex.y);
 }
 rightEye.endShape(CLOSE);
 shape(rightEye);
 
 leftEye=createShape();
 leftEye.beginShape();
 for (PVector leftEyeVertex : face.geyeL) {
 leftEye.vertex(leftEyeVertex.x, leftEyeVertex.y);
 }
 leftEye.endShape(CLOSE);
 shape(leftEye);
 */
