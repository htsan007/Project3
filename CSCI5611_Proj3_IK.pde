

void setup(){
  size(640,480,P3D);
  camera = new Camera();
  camera.position.x = 323.34033; //Set cam position NO TOUCH
  camera.position.y = 219.73163;
  camera.position.z = 625.7619;
  camera.phi = -0.08;
  camera.theta = -182.22586;
  camera.Update(1);
  paused = true;
  
  fk();
  solve();
  
  surface.setTitle("CSCI5611 Project 3");
}
void keyPressed() {
  if (key == ' ') {
    paused = !paused;
  }
  camera.HandleKeyPressed();
}

void keyReleased() {
  camera.HandleKeyReleased();
}
boolean paused;
float armW = 20;
Camera camera;
Vec2 start_l0,start_l1,start_l2, start_l3, endPoint;
Vec2 rstart_l0,rstart_l1,rstart_l2, rstart_l3, rendPoint;
Vec2 topSpineStartl,armStartl;
Box botSpine,topSpine;
//Left limbs from shoulder down
Box b,b0,b1,b2,b3;

//Right limbs from shoulder down
Box rb,rb0,rb1,rb2,rb3;

//Roots
//rect(
Vec2 rootSpine = new Vec2(320,225+75); //bottom of body
//Vec2 rootL = new Vec2(230,150); 
//Vec2 rootR = new Vec2(410,150); 
float wristLim = 80; //degrees

//spine------------
float botSpinel = 75*0.8;
float bsa = 0; //straight

float topSpinel = 75*0.8;
float tsa = 0;
//LEFT------------
//clavicle thing
float l = 90*0.6;
float a = -0.3;

//Upper Arm
float l0 = 90*0.6; 
float a0 = 0.3; //Shoulder joint
//Lower Arm
float l1 = 70*0.6;
float a1 = 0.3; //Elbow joint
//Hand
float l2 = 60*0.6;
float a2 = 0.3; //Wrist joint
//new hand
float l3 = 30*0.6; //new wrist
float a3 = 0.3;

//Box b0 = new Box(rootL.x, rootL.y, armW, l0);
//Box b1 = new Box(start.x, rootL.y, armW, l0);
//Box b2 = new Box(rootL.x, rootL.y, armW, l0);
//Box b3 = new Box(rootL.x, rootL.y, armW, l0);

//----------------

//RIGHT ------------
//Upper Arm
//clavicle thing
float rl = 90*0.6;
float ra = -0.3;

float rl0 = 90*0.6; 
float ra0 = -0.3; //Shoulder joint
//Lower Arm
float rl1 = 70*0.6;
float ra1 = -0.3; //Elbow joint
//Hand
float rl2 = 60*0.6;
float ra2 = -0.3; //Wrist joint
//new hand
float rl3 = 30*0.6; //new wrist
float ra3 = -0.3;

//-------------------

//OBVIOUSLY REAL ARMS HAVE MORE COMPLEX RANGE OF MOTION, THIS IS A SIMPLER SIMULATION SHOWING 
//OFF ANGLE AND ROTATION LIMITS, NOT MEANT TO BE ACCURATE TO REAL LIFE
Vec2 goalL = new Vec2(0,0);
Vec2 goalR = new Vec2(0,0);
void solve(){
  
  Vec2 goal = new Vec2(mouseX, mouseY);
   //same goal for both
  
  
  //SPINE ----
  Vec2 spineToGoal, spineToEndEffector;
  float spineDot, spineAngDiff;
  
  spineToGoal = goal.minus(rootSpine);
  spineToEndEffector = endPoint.minus(rootSpine);
  spineDot = dot(spineToGoal.normalized(),spineToEndEffector.normalized());
  spineDot = clamp(spineDot,-1,1);
  spineAngDiff = acos(spineDot);
  if(spineAngDiff > 0.04){
      spineAngDiff = 0.04;
    }
  if (vecCross(spineToGoal,spineToEndEffector) < 0)
    
    bsa += spineAngDiff;
  else
    bsa -= spineAngDiff;
  /*TODO: Wrist joint limits here*/
  if(bsa < -105*PI/180){
    bsa = -105*PI/180;
  }
  else if(bsa > -75*PI/180){
    bsa = -75*PI/180;
  }
  fk(); //Update link posit
  
  spineToGoal = goal.minus(topSpineStartl);
  spineToEndEffector = endPoint.minus(topSpineStartl);
  spineDot = dot(spineToGoal.normalized(),spineToEndEffector.normalized());
  spineDot = clamp(spineDot,-1,1);
  spineAngDiff = acos(spineDot);
  if(spineAngDiff > 0.045){
      spineAngDiff = 0.045;
    }
  if (vecCross(spineToGoal,spineToEndEffector) < 0)
    
    tsa += spineAngDiff;
  else
    tsa -= spineAngDiff;
  /*TODO: Wrist joint limits here*/
  if(tsa > 15*PI/180){
    tsa = 15*PI/180;
  }
  else if(tsa < -15*PI/180){
    tsa = -15*PI/180;
  }
  fk(); //Update link posit
  
  //LEFT ARM ----------------------
  Vec2 startToGoal, startToEndEffector;
  float dotProd, angleDiff;
  
  
  if(goal.x < 470){
    goalL.x = goal.x;
    goalL.y = goal.y;
  
  
  //Update new wrist joint (end limb)
   startToGoal = goal.minus(start_l3);
  startToEndEffector = endPoint.minus(start_l3);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if(angleDiff > 0.07){
      angleDiff = 0.07;
    }
  if (vecCross(startToGoal,startToEndEffector) < 0)
    
    a3 += angleDiff;
  else
    a3 -= angleDiff;
  /*TODO: Wrist joint limits here*/
  if(a3 > wristLim*PI/180){
    a3 = wristLim*PI/180;
  }
  else if(a3 < -wristLim*PI/180){
    a3 = -wristLim*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //2nd limb from end point (old wrist)
  startToGoal = goal.minus(start_l2);
  startToEndEffector = endPoint.minus(start_l2);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if(angleDiff > 0.06){
      angleDiff = 0.06;
    }
  if (vecCross(startToGoal,startToEndEffector) < 0)
    
    a2 += angleDiff;
  else
    a2 -= angleDiff;
  /*TODO: Wrist joint limits here*/
  if(a2 > 0){ //Dont bend "elbow" other way
    a2 = 0;
  }
  else if(a2 < -1.3*wristLim*PI/180){
    a2 = -1.3*wristLim*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  
  
  //Update elbow joint
  startToGoal = goal.minus(start_l1);
  startToEndEffector = endPoint.minus(start_l1);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if(angleDiff > 0.055){
      angleDiff = 0.055;
    }
  if (vecCross(startToGoal,startToEndEffector) < 0)
    a1 += angleDiff;
  else
    a1 -= angleDiff;
  
  if(a1 > 0){
    a1 = 0;
  }
  else if(a1 < -100*PI/180){
    a1 = -100*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  
  //Update shoulder joint
  startToGoal = goal.minus(start_l0); //rootL -> armStartl , same for rootR
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPoint.minus(start_l0);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if(angleDiff > 0.045){
      angleDiff = 0.045;
    }
  if (vecCross(startToGoal,startToEndEffector) < 0)
    a0 += angleDiff;
  else
    a0 -= angleDiff;
  /*TODO: Shoulder joint limits here*/
  if(a0 < -120*PI/180){
    a0 = -120*PI/180;
  }
  else if(a0 > 120*PI/180){
    a0 = 120*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
   startToGoal = goal.minus(armStartl); //rootL -> armStartl , same for rootR
  if (startToGoal.length() < .0001) return;
  startToEndEffector = endPoint.minus(armStartl);
  dotProd = dot(startToGoal.normalized(),startToEndEffector.normalized());
  dotProd = clamp(dotProd,-1,1);
  angleDiff = acos(dotProd);
  if(angleDiff > 0.045){
      angleDiff = 0.045;
    }
  if (vecCross(startToGoal,startToEndEffector) < 0)
    a += angleDiff;
  else
    a -= angleDiff;
  /*TODO: Shoulder joint limits here*/
  if(a < 150*PI/180){
    a = 150*PI/180;
  }
  else if(a > 180*PI/180){
    a = 180*PI/180;
  }
  fk();
  }
  //println("Left: Angle 0:",a0,"Angle 1:",a1,"Angle 2:",a2,"Angle 3:",a3);
 //LEFT ARM ----------------------
 
 //RIGHT ARM ---------
 Vec2 rstartToGoal, rstartToEndEffector;
  float rdotProd, rangleDiff;
  if(goal.x > 170){
    goalR.x = goal.x;
    goalR.y = goal.y;
  
  //Update new wrist joint (end limb)
   rstartToGoal = goal.minus(rstart_l3);
  rstartToEndEffector = rendPoint.minus(rstart_l3);
  rdotProd = dot(rstartToGoal.normalized(),rstartToEndEffector.normalized());
  rdotProd = clamp(rdotProd,-1,1);
  rangleDiff = acos(rdotProd);
  if(rangleDiff > 0.07){
      rangleDiff = 0.07;
    }
  if (vecCross(rstartToGoal,rstartToEndEffector) < 0)
    
    ra3 += rangleDiff;
  else
    ra3 -= rangleDiff;
  /*TODO: Wrist joint limits here*/
  if(ra3 > wristLim*PI/180){
    ra3 = wristLim*PI/180;
  }
  else if(ra3 < -wristLim*PI/180){
    ra3 = -wristLim*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //2nd limb from end point (old wrist)
  rstartToGoal = goal.minus(rstart_l2);
  rstartToEndEffector = rendPoint.minus(rstart_l2);
  rdotProd = dot(rstartToGoal.normalized(),rstartToEndEffector.normalized());
  rdotProd = clamp(rdotProd,-1,1);
  rangleDiff = acos(rdotProd);
  if(rangleDiff > 0.06){
      rangleDiff = 0.06;
    }
  if (vecCross(rstartToGoal,rstartToEndEffector) < 0)
    
    ra2 += rangleDiff;
  else
    ra2 -= rangleDiff;
  /*TODO: Wrist joint limits here*/
  if(ra2 > 1.3*wristLim*PI/180){
    ra2 = 1.3*wristLim*PI/180;
  }
  else if(ra2 < 0){ //don't "break" elbow joint
    ra2 = 0;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //Update elbow joint
  rstartToGoal = goal.minus(rstart_l1);
  rstartToEndEffector = rendPoint.minus(rstart_l1);
  rdotProd = dot(rstartToGoal.normalized(),rstartToEndEffector.normalized());
  rdotProd = clamp(rdotProd,-1,1);
  rangleDiff = acos(rdotProd);
  if(rangleDiff > 0.055){
      rangleDiff = 0.055;
    }
  if (vecCross(rstartToGoal,rstartToEndEffector) < 0)
    ra1 += rangleDiff;
  else
    ra1 -= rangleDiff;
    
  if(ra1 > 100*PI/180){
    ra1 = 100*PI/180;
  }
  else if(ra1 < 0){ //don't "break" elbow joint
    ra1 = 0;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  
  //Update shoulder joint
  rstartToGoal = goal.minus(rstart_l0);
  if (rstartToGoal.length() < .0001) return;
  rstartToEndEffector = rendPoint.minus(rstart_l0);
  rdotProd = dot(rstartToGoal.normalized(),rstartToEndEffector.normalized());
  rdotProd = clamp(rdotProd,-1,1);
  rangleDiff = acos(rdotProd);
  if(rangleDiff > 0.045){
      rangleDiff = 0.045;
    }
  if (vecCross(rstartToGoal,rstartToEndEffector) < 0)
    ra0 += rangleDiff;
  else
    ra0 -= rangleDiff;
  /*TODO: Shoulder joint limits here*/
  if(ra0 < -120*PI/180){
    ra0 = -120*PI/180;
  }
  else if(ra0 > 120*PI/180){
    ra0 = 120*PI/180;
  }
  fk();
  
  //Clavicle link
  rstartToGoal = goal.minus(armStartl);
  if (rstartToGoal.length() < .0001) return;
  rstartToEndEffector = rendPoint.minus(armStartl);
  rdotProd = dot(rstartToGoal.normalized(),rstartToEndEffector.normalized());
  rdotProd = clamp(rdotProd,-1,1);
  rangleDiff = acos(rdotProd);
  if(rangleDiff > 0.045){
      rangleDiff = 0.045;
    }
  if (vecCross(rstartToGoal,rstartToEndEffector) < 0)
    ra += rangleDiff;
  else
    ra -= rangleDiff;
  /*TODO: Shoulder joint limits here*/
  if(ra > 30*PI/180){
    ra = 30*PI/180;
  }
  else if(ra < 0*PI/180){
    ra = 0*PI/180;
  }
  fk(); //Update link positions with fk (e.g. end effector changed)
  
  //println("Right: Angle 0:",ra0,"Angle 1:",ra1,"Angle 2:",ra2,"Angle 3:",ra3);
  
  //------------------------
  }
}

void fk(){
  
  topSpineStartl = new Vec2(cos(bsa)*botSpinel,sin(bsa)*botSpinel).plus(rootSpine);
  armStartl = new Vec2(cos(bsa+tsa)*topSpinel,sin(bsa+tsa)*topSpinel).plus(topSpineStartl);
  topSpine = new Box(topSpineStartl.x + topSpinel/2,topSpineStartl.y + armW/2,topSpinel,armW);
  botSpine = new Box(rootSpine.x + botSpinel/2,rootSpine.y + armW/2,botSpinel,armW);
  
  start_l0 = new Vec2(cos(a)*l,sin(a)*l).plus(armStartl);
  start_l1 = new Vec2(cos(a+a0)*l0,sin(a+a0)*l0).plus(start_l0);
  start_l2 = new Vec2(cos(a+a0+a1)*l1,sin(a+a0+a1)*l1).plus(start_l1);
  start_l3 = new Vec2(cos(a+a0+a1+a2)*l2,sin(a+a0+a1+a2)*l2).plus(start_l2);
  endPoint = new Vec2(cos(a+a0+a1+a2+a3)*l3,sin(a+a0+a1+a2+a3)*l3).plus(start_l3);
  
  //Box objects given CENTER POINT of box
  b = new Box(armStartl.x + l/2, armStartl.y + armW/2, l, armW);
  b0 = new Box(start_l0.x + l0/2, start_l0.y + armW/2, l0, armW);
  b1 = new Box(start_l1.x + l1/2, start_l1.y + armW/2, l1, armW);
  b2 = new Box(start_l2.x + l2/2, start_l2.y + armW/2, l2,armW);
  b3 = new Box(start_l3.x + l3/2, start_l3.y + armW/2, l3,armW);
  
  rstart_l0 = new Vec2(cos(ra)*rl,sin(ra)*rl).plus(armStartl);
  rstart_l1 = new Vec2(cos(ra+ra0)*rl0,sin(ra+ra0)*rl0).plus(rstart_l0);
  rstart_l2 = new Vec2(cos(ra+ra0+ra1)*rl1,sin(ra+ra0+ra1)*rl1).plus(rstart_l1);
  rstart_l3 = new Vec2(cos(ra+ra0+ra1+ra2)*rl2,sin(ra+ra0+ra1+ra2)*rl2).plus(rstart_l2);
  rendPoint = new Vec2(cos(ra+ra0+ra1+ra2+ra3)*rl3,sin(ra+ra0+ra1+ra2+ra3)*rl3).plus(rstart_l3);
  
  rb = new Box(armStartl.x + l/2, armStartl.y + armW/2, l, armW);
  rb0 = new Box(rstart_l0.x + rl0/2, rstart_l0.y + armW/2, rl0, armW);
  rb1 = new Box(rstart_l1.x + rl1/2, rstart_l1.y + armW/2, rl1, armW);
  rb2 = new Box(rstart_l2.x + rl2/2, rstart_l2.y + armW/2, rl2, armW);
  rb3 = new Box(rstart_l3.x + rl3/2, rstart_l3.y + armW/2, rl3, armW);
}

void draw(){
  if(!paused){
    fk();
    solve();
  }
  
  
  camera.Update(0.05);
  //println(camera.position.x);
  //println(camera.position.y);
  //println(camera.position.z);
  //println(camera.theta);
  //println(camera.phi);
  lights();
  background(250,250,250);
  
  rectMode(CENTER);
  shapeMode(CORNER);
  
  //DRAW A BODY
  pushMatrix();
  translate(armStartl.x+cos(tsa)+cos(bsa),armStartl.y-35-sin(tsa) -sin(bsa),0);
  noStroke();
  sphere(30); //head
  popMatrix();
  
  stroke(50,50,50);
  strokeWeight(0.7);
  
  //fill(100,100,255);
  //pushMatrix();
  //translate(320,225,-60);
  //box(180,150,90); //body
  ////rect(320, 225, 180, 150); 
  //popMatrix();
  noStroke(); //reach object
   fill(100,255,100);
  pushMatrix();
  translate(mouseX,mouseY,0);
  sphere(20);
  popMatrix();
  
  //pants
  fill(255,100,100);
  pushMatrix();
  translate(320,310,0);
  box(65,20,15);
  popMatrix();
  
  pushMatrix();
  translate(300,395,0);
  box(25,150,15);
  popMatrix();
  
  pushMatrix();
  translate(340,395,0);
  box(25,150,15);
  popMatrix();
  //rect(280, 375, 40, 150);
  //rect(360, 375, 40, 150);
  
  fill(0,0,0); //shoes
  pushMatrix();
  translate(285,460,0);
  box(55,30,35);
  popMatrix();
  
  pushMatrix();
  translate(355,460,0);
  box(55,30,35);
  popMatrix();
  //rect(265,460, 70, 30);
  //rect(375,460, 70, 30);
  
  fill(0,0,0); //eyes
  pushMatrix();
  translate(armStartl.x+cos(tsa)+cos(bsa)+15,armStartl.y+sin(tsa)+sin(bsa) -35,22);
  sphere(5);
  popMatrix();
  
  pushMatrix();
   translate(armStartl.x+cos(tsa)+cos(bsa)-15,armStartl.y+sin(tsa)+sin(bsa) -35,22);
  sphere(5);
  popMatrix();
  
  //circle(300,100,15); //left eye
  //circle(340, 100, 15); //right eye
  
  pushMatrix(); //mouth
  translate(armStartl.x+cos(tsa)+cos(bsa),armStartl.y+sin(tsa)+sin(bsa) -25,27);
  box(23,5,5);
  popMatrix();
  
  //rect(320, 115, 55, 10); //mouth
  //DRAW SPINE
  fill(100,100,255); 
  pushMatrix();
  translate(botSpine.x - botSpine.w/2, botSpine.y - botSpine.h/2);
  rotate(bsa);
  translate(botSpine.w/2,0,0);
  box(botSpine.w, botSpine.h, botSpine.w/2);
  popMatrix();
  
  pushMatrix();
  translate(topSpine.x - topSpine.w/2, topSpine.y - topSpine.h/2);
  rotate(tsa+bsa);
  translate(topSpine.w/2,0,0);
  box(topSpine.w, topSpine.h, topSpine.w/2);
  popMatrix();
  
  //LEFT LIMB--------
  fill(100,100,255); //sleeve blue
   //clavicle 
  pushMatrix();
  translate(b.x - b.w/2,b.y - b.h/2);
  rotate(a);
  translate(b.w/2,0,0);
  //rect(b0.w/2 , 0, b0.w, b0.h);
  box(b.w, b.h, b.w/2);
  popMatrix();
  
  pushMatrix();
  translate(b0.x - b0.w/2,b0.y - b0.h/2);
  rotate(a+a0);
  translate(b0.w/2,0,0);
  //rect(b0.w/2 , 0, b0.w, b0.h);
  box(b0.w, b0.h, b0.w/2);
  popMatrix();
  
  noStroke();
  fill(225,180,170);
  pushMatrix();
  translate(b1.x - b1.w/2,b1.y - b1.h/2);
  rotate(a+a0+a1);
  
  translate(b1.w/2,0,0);
  //rect(b1.w/2 , 0, b1.w, b1.h);
  box(b1.w, b1.h, b1.w/2);
  popMatrix();
  
  pushMatrix();
  translate(b2.x - b2.w/2,b2.y - b2.h/2);
  rotate(a+a0+a1+a2);
  
  translate(b2.w/2,0,0);
  //rect(b2.w/2 , 0, b2.w, b2.h);
  box(b2.w,b2.h,b2.w/2);
  popMatrix();
  
  pushMatrix(); //NEW LIMB SEGMENT
  translate(b3.x - b3.w/2,b3.y - b3.h/2);
  rotate(a+a0+a1+a2+a3);
  
  translate(b3.w/2,0,0);
  //rect(b3.w/2 , 0, b3.w, b3.h);
  box(b3.w, b3.h, b3.w/2);
  popMatrix();
  //--------------
  
  //RIGHT LIMB-----------
  stroke(50,50,50);
  strokeWeight(0.7);
  fill(100,100,255); //sleeve blue
  
  //clavicle
  pushMatrix();
  translate(rb.x - rb.w/2,rb.y - rb.h/2);
  rotate(ra);
  translate(rb.w/2,0,0);
  //rect(b0.w/2 , 0, b0.w, b0.h);
  box(rb.w, rb.h, rb.w/2);
  popMatrix();
  
  pushMatrix();
  translate(rb0.x - rb0.w/2,rb0.y - rb0.h/2);
  rotate(ra+ra0);
  translate(rb0.w/2,0,0);
  //rect(b0.w/2 , 0, b0.w, b0.h);
  box(rb0.w, rb0.h, rb0.w/2);
  popMatrix();
  
  noStroke();
  fill(225,180,170);
  pushMatrix();
  translate(rb1.x - rb1.w/2,rb1.y - rb1.h/2);
  rotate(ra+ra0+ra1);
  
  translate(rb1.w/2,0,0);
  //rect(b1.w/2 , 0, b1.w, b1.h);
  box(rb1.w, rb1.h, rb1.w/2);
  popMatrix();
  
  pushMatrix();
  translate(rb2.x - rb2.w/2,rb2.y - rb2.h/2);
  rotate(ra+ra0+ra1+ra2);
  
  translate(rb2.w/2,0,0);
  //rect(b2.w/2 , 0, b2.w, b2.h);
  box(rb2.w,rb2.h,rb2.w/2);
  popMatrix();
  
  pushMatrix(); //NEW LIMB SEGMENT
  translate(rb3.x - rb3.w/2,rb3.y - rb3.h/2);
  rotate(ra+ra0+ra1+ra2+ra3);
  
  translate(rb3.w/2,0,0);
  //rect(b3.w/2 , 0, b3.w, b3.h);
  box(rb3.w, rb3.h, rb3.w/2);
  popMatrix();
  //--------------
  
}

boolean CircleBoxCollision(Circle c1, Box b1){ //circle box collision function
  Vec2 closestPoint = new Vec2(
     clamp(c1.pos.x, b1.x - b1.w/2, b1.x + b1.w/2),
    clamp(c1.pos.y, b1.y - b1.h/2, b1.y + b1.h/2));
    
  return (closestPoint.distanceTo(c1.pos) <= c1.radius); //inclusive if on edge
}

public class Circle { //class for circle
  public Vec2 pos; //center point x and y
  public float radius;
  public int id = -1;
  public int collide = 0; //set to 1 for collision
  
  public Circle(Vec2 pos, float r){//constructor
    this.pos = pos;
    this.radius = r;
  }
}

public class Box { //class for box
  public float x,y,w,h; //x,y of center
  public int id = -1;
  public int collide = 0; //set to 1 for collision
  
  public Box(float x, float y, float w, float h){ //constructor
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}
Vec2 findBoxCenter(float startX, float startY, float w, float l){
  float centerX = startX + l/2;
  float centerY = startY + w/2;
  return new Vec2(centerX,centerY);
}
//-----------------
// Vector Library
//-----------------

public float clamp(float value, float min, float max){ //value clamp function
  if(value < min){
    return min;
  }
  else if(value > max){
    return max;
  }
  return value;
}

public float cross(float x1, float y1, float x2, float y2){
  return (x1*y2 - y1*x2); //ad - bc : (x1,y1) & (x2,y2) == (a,b) & (c,d)
}

//2DVector library based from Prof. Guy's version
public class Vec2 {
  public float x, y;
  
  public Vec2(float x, float y){
    this.x = x;
    this.y = y;
  }
  
  public String toString(){
    return "(" + x+ "," + y +")";
  }
  
  public float length(){
   if((x==0) && (y==0)){
      return 0;
    }
    else {
      return sqrt(x*x+y*y);
    }
  }
  
  
  public Vec2 plus(Vec2 rhs){
    return new Vec2(x+rhs.x, y+rhs.y);
  }
  
  public void add(Vec2 rhs){
    x += rhs.x;
    y += rhs.y;
  }
  
  public Vec2 minus(Vec2 rhs){
    return new Vec2(x-rhs.x, y-rhs.y);
  }
  
  public void subtract(Vec2 rhs){
    x -= rhs.x;
    y -= rhs.y;
  }
  
  public Vec2 times(float rhs){
    return new Vec2(x*rhs, y*rhs);
  }
  
  public void mul(float rhs){
    x *= rhs;
    y *= rhs;
  }
  
  public void clampToLength(float maxL){
    if((x==0) && (y==0)){
     return;
    }
    float magnitude = sqrt(x*x + y*y);
    if (magnitude > maxL){
      x *= maxL/magnitude;
      y *= maxL/magnitude;
    }
  }
  
  
  public void setToLength(float newL){
    if((x==0) && (y==0)){
     return;
    }
    float magnitude = sqrt(x*x + y*y);
    x *= newL/magnitude;
    y *= newL/magnitude;
  }
  
  public void normalize(){
    if((x == 0) && (y == 0)){
      return;
    }
    else {
      float magnitude = sqrt(x*x + y*y);
      x /= magnitude;
      y /= magnitude;
    }
  }
  
  public Vec2 normalized(){
    if((x == 0) && (y == 0)){
      return new Vec2(0,0);
    }
    float magnitude = sqrt(x*x + y*y);
    return new Vec2(x/magnitude, y/magnitude);
  }
  
  public float distanceTo(Vec2 rhs){
    float dx = rhs.x - x;
    float dy = rhs.y - y;
    if((dx == 0) && (dy == 0)){
      return 0;
    }
    return sqrt(dx*dx + dy*dy);
  }
}

Vec2 interpolate(Vec2 a, Vec2 b, float t){
  return a.plus((b.minus(a)).times(t));
}

float interpolate(float a, float b, float t){
  return a + ((b-a)*t);
}

float dot(Vec2 a, Vec2 b){
  return a.x*b.x + a.y*b.y;
}
float vecCross(Vec2 a, Vec2 b){
  return (a.x*b.y - a.y*b.x); //ad - bc
}
Vec2 projAB(Vec2 a, Vec2 b){
  return b.times(a.x*b.x + a.y*b.y);
}
