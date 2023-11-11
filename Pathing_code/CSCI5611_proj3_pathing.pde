
PImage comet;
//A list of circle obstacles
static int numObstacles = 75;
Vec2 circlePos[] = new Vec2[numObstacles]; //Circle positions
float circleRad[] = new float[numObstacles];  //Circle radii

//A box obstacle
Vec2 boxTopLeft = new Vec2(100,100);
float boxW = 100;
float boxH = 250;

boolean paused;
float circNavigatorRad = 15/2;
float triSide = sqrt(3)*circNavigatorRad;

float triSide2 = triSide/2;
float currAng = 0;
float angle = 0;
float totalAngle = 0;
boolean triRotated = false;

float squareSide;
int goalFound = 0;
//ArrayList<Integer> pathToGoal = new ArrayList(); //hold forward path to goal - nodes
Vec2 triTop ;
Vec2 triLeft ;
Vec2 triRight ;
Vec2 startPos = new Vec2(100,random(0,768)); //default random near left side
Vec2 circNaviPos;
Vec2 goalPos = new Vec2(1000,random(0,768)); //default random near right side (changes default area based on mouseclick)

float pathConstrain = 200; //restrict path length

void placeRandomObstacles(){
  //Initial obstacle position
  for (int i = 0; i < numObstacles/5; i++){
    circlePos[i] = new Vec2(random(10,1014),random(10,758));
    circleRad[i] = (30+random(1,30));
    
  }
  for (int i = numObstacles/5; i < numObstacles; i++){
    circlePos[i] = new Vec2(random(10,1014),random(10,758));
    circleRad[i] = (10+random(1,20));
    
  }
}
int strokeWidth = 2;
void setup(){
  
  size(1024,768,P2D);
  placeRandomObstacles();
  buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
  runBFS(closestNode(startPos),closestNode(goalPos));
  paused = true;
  pathIdx = 0;
  comet = loadImage("asteroid.png");
}
int pathIdx = 0;

void draw(){
  //println("FrameRate:",frameRate);
  strokeWeight(1);
  background(70); //Grey background
  stroke(0,0,0);
  fill(255,255,255);
  
  triTop = new Vec2(circNaviPos.x,circNaviPos.y+circNavigatorRad);
  triLeft = new Vec2(circNaviPos.x - triSide2,circNaviPos.y-circNavigatorRad/2);
  triRight = new Vec2(circNaviPos.x + triSide2,circNaviPos.y-circNavigatorRad/2);
  //Draw the circle obstacles
  rectMode(CENTER);
  noStroke();
  
  for (int i = 0; i < numObstacles; i++){
    Vec2 c = circlePos[i];
    float r = circleRad[i];
    textureMode(NORMAL);
    beginShape();
    squareSide = sqrt(2)*r;
    texture(comet);
   
    vertex(c.x-squareSide/2,c.y+squareSide/2,0,0);
    vertex(c.x-squareSide/2,c.y-squareSide/2,1,0);
    vertex(c.x+squareSide/2,c.y-squareSide/2,1,1);
    vertex(c.x+squareSide/2,c.y+squareSide/2,0,1);
    endShape();
    //rect(c.x,c.y,squareSide,squareSide);
    //circle(c.x,c.y,r);
  }
  
  //Draw the box obstacles
  //TODO: Uncomment this to draw the box
  //fill(250,200,200);
  //rect(boxTopLeft.x, boxTopLeft.y, boxW, boxH);
  
  //Draw PRM Nodes
  fill(255,150,150);
  for (int i = 0; i < numNodes; i++){
    circle(nodePos[i].x,nodePos[i].y,5);
  }
  
  //Draw graph
  fill(0);
  stroke(120,45);
  strokeWeight(0.25);
  for (int i = 0; i < numNodes; i++){
    for (int j : neighbors[i]){
      line(nodePos[i].x,nodePos[i].y,nodePos[j].x,nodePos[j].y);
    }
  }
  
  //Draw Start and Goal
  fill(20,60,250);
  circle(nodePos[startNode].x,nodePos[startNode].y,20);
  
  
  //circle(startPos.x,startPos.y,20);
  fill(250,30,50); //GOAL RED
  circle(nodePos[goalNode].x,nodePos[goalNode].y,20);
  //circle(goalPos.x,goalPos.y,20);
  
  //Draw Planned Path
  stroke(20,255,40,120);
  strokeWeight(3);
  for (int i = 0; i < path.size()-1; i++){
    int curNode = path.get(i);
    int nextNode = path.get(i+1);
    //strokeWeight(i*3);
    line(nodePos[curNode].x,nodePos[curNode].y,nodePos[nextNode].x,nodePos[nextNode].y);
  }
  
  //ANIMATE PATH TRAVERSAL
  //noStroke();
  stroke(100,149,237);
  strokeWeight(1);
  fill(50,120,50); //navigator green
  
  Vec2 topDir = triTop.minus(circNaviPos);
  topDir.normalize();
  Vec2 dir = new Vec2(0,0);
  
  pushMatrix(); //draw triangle to screen
  translate(circNaviPos.x, circNaviPos.y);
  rotate(currAng);
  triTop = new Vec2(0,circNavigatorRad);
  triLeft = new Vec2( - triSide2,-circNavigatorRad/2);
  triRight = new Vec2(+ triSide2,-circNavigatorRad/2);
  //fill(138,43,226);
  stroke(1,1,1);
  strokeWeight(1);
  //circle(0,0,15);
  //noStroke(); 
  fill(0,255,255);
  triangle(triTop.x, triTop.y, triLeft.x, triLeft.y, triRight.x, triRight.y);
  popMatrix();
  pathIdx = traversePath(0.000001, pathIdx);
  if(!paused){
    if(!triRotated){
      //if(pathIdx != -1){
       dir = nodePos[path.get(pathIdx)].minus(circNaviPos);
       dir.normalize();
       //println(pathIdx,dir.x,dir.y);
       angle = -acos(dot(topDir, dir) / (topDir.length() * dir.length()));
       //totalAngle += angle;
       for(int i = 0; i < 20; i++){
         currAng = rotNavigator(0.002,angle, currAng);
       }
      
        pushMatrix();
        translate(circNaviPos.x, circNaviPos.y);
        rotate(currAng);
        triTop = new Vec2(0,circNavigatorRad);
        triLeft = new Vec2( - triSide2,-circNavigatorRad/2);
        triRight = new Vec2(+ triSide2,-circNavigatorRad/2);
        //fill(138,43,226);
        stroke(1,1,1);
        strokeWeight(1);
        //circle(0,0,15);
        //noStroke();
        fill(0,255,255);
        triangle(triTop.x, triTop.y, triLeft.x, triLeft.y, triRight.x, triRight.y);
        popMatrix();
      //}
      //else {
      //  pushMatrix();
      //  translate(circNaviPos.x, circNaviPos.y);
      //  angle = -acos(dot(topDir, dir) / (topDir.length() * dir.length()));
        
      //  rotate(currAng);
      //  triTop = new Vec2(0,circNavigatorRad);
      //  triLeft = new Vec2( - triSide2,-circNavigatorRad/2);
      //  triRight = new Vec2(+ triSide2,-circNavigatorRad/2);
      //  triangle(triTop.x, triTop.y, triLeft.x, triLeft.y, triRight.x, triRight.y);
      //  popMatrix();
      //}
    }
    else{
      //currAng = 0;
      for(int i = 0; i < 100; i++){
        //if(pathIdx == -1){
        //  break;
        //}
        //else{
          //if(nodePos[path.get(pathIdx)].distanceTo(circNaviPos) == 0){
          //  circNaviPos = nodePos[path.get(pathIdx)];
          //  paused = !paused;
          //}
          //for(int j =0; j < 35; j++){
          pathIdx = traversePath(0.02, pathIdx);
          //}
        
         dir = nodePos[path.get(pathIdx)].minus(circNaviPos);
         dir.normalize();
         //println(pathIdx,dir.x,dir.y);
         //angle = -acos(dot(topDir, dir) / (topDir.length() * dir.length()));
         //currAng = rotNavigator(0.01,angle, currAng);
          pushMatrix();
          translate(circNaviPos.x, circNaviPos.y);
          rotate(angle);
          triTop = new Vec2(0,circNavigatorRad);
          triLeft = new Vec2( - triSide2,-circNavigatorRad/2);
          triRight = new Vec2(+ triSide2,-circNavigatorRad/2);
          //fill(138,43,226);
          stroke(1,1,1);
          strokeWeight(1);
          //circle(0,0,15);
          //noStroke();
          fill(0,255,255);
          triangle(triTop.x, triTop.y, triLeft.x, triLeft.y, triRight.x, triRight.y);
          popMatrix();
         //}
      }
    }
  }
}

void keyPressed(){
  if (key == 'r'){
    //TODO: Randomize obstacle positions and radii
    //      Also, replan for these new obstacles.
    startPos = new Vec2(100,random(0,768)); //default random near left side
    goalPos = new Vec2(1000,random(0,768)); //default random near right side (changes default area based on mouseclick)

    placeRandomObstacles();
    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
    pathIdx = 0;
    paused = true;
    
  }
  if ( key == ' '){ //pause
    
    paused = !paused;
    //generate new nodes and path with same obstacles
    //startPos = new Vec2(100,random(0,768)); //default random near left side
    //goalPos = new Vec2(1000,random(0,768)); //default random near right side (changes default area based on mouseclick)

    //buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    //runBFS(closestNode(startPos),closestNode(goalPos));
    //pathIdx = 0;
  }
  
  if (keyCode == RIGHT){
    boxTopLeft.x += 10;
    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
  if (keyCode == LEFT){
    boxTopLeft.x -= 10;
    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
  if (keyCode == UP){
    boxTopLeft.y -= 10;
    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
  if (keyCode == DOWN){
    boxTopLeft.y += 10;
    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
  }
}

int closestNode(Vec2 point){
  //TODO: Return the closest node the passed in point
  int indx = -1;
  float dist = 10000000;
  for(int i = 0; i < numNodes; i++){
    if(point.distanceTo(nodePos[i]) < dist){
      dist = point.distanceTo(nodePos[i]);
      indx = i;
    }
  }
  return indx;
}

void mousePressed(){
  
  ////goalPos = new Vec2(mouseX, mouseY);
  //goalPos = new Vec2(1000,random(0,768)); //pick different random node on right side
  ////println("New Goal is",goalPos.x, goalPos.y);
  //runBFS(closestNode(startPos),closestNode(goalPos));
  //pathIdx = 0;
  
  //generate new nodes and path with same obstacles
  startPos = new Vec2(100,random(0,768)); //default random near left side
    goalPos = new Vec2(1000,random(0,768)); //default random near right side (changes default area based on mouseclick)

    buildPRM(circlePos, circleRad, boxTopLeft, boxW, boxH);
    runBFS(closestNode(startPos),closestNode(goalPos));
    pathIdx = 0;
    
    paused = true;
}



/////////
// Point Intersection Tests
/////////

//Returns true if the point is inside a box
boolean pointInBox(Vec2 boxTopLeft, float boxW, float boxH, Vec2 pointPos){
  //TODO: Return true if the point is actually inside the box
  if(pointPos.x > boxTopLeft.x && pointPos.x < boxTopLeft.x+boxW){
    if(pointPos.y > boxTopLeft.y && pointPos.y < boxTopLeft.y+boxH){
      return true;
    }
  }
  return false;
}

//Returns true if the point is inside a circle
boolean pointInCircle(Vec2 center, float r, Vec2 pointPos){
  float dist = pointPos.distanceTo(center);
  if (dist < r){ //small safety factor
    return true;
  }
  return false;
}

//Returns true if the point is inside a list of circle
boolean pointInCircleList(Vec2[] centers, float[] radii, Vec2 pointPos){
  for (int i = 0; i < numObstacles; i++){
    Vec2 center =  centers[i];
    float r = radii[i] + circNavigatorRad; //INCLUDE navigation circ radius
    if (pointInCircle(center,r,pointPos)){
      return true;
    }
  }
  return false;
}




/////////
// Ray Intersection Tests
/////////

class hitInfo{
  public boolean hit = false;
  public float t = 9999999;
}

hitInfo rayBoxIntersect(Vec2 boxTopLeft, float boxW, float boxH, Vec2 ray_start, Vec2 ray_dir, float max_t){
  hitInfo hit = new hitInfo();
  hit.hit = true;
  
  float t_left_x, t_right_x, t_top_y, t_bot_y;
  t_left_x = (boxTopLeft.x - ray_start.x)/ray_dir.x;
  t_right_x = (boxTopLeft.x + boxW - ray_start.x)/ray_dir.x;
  t_top_y = (boxTopLeft.y - ray_start.y)/ray_dir.y;
  t_bot_y = (boxTopLeft.y + boxH - ray_start.y)/ray_dir.y;
  
  float t_max_x = max(t_left_x,t_right_x);
  float t_max_y = max(t_top_y,t_bot_y);
  float t_max = min(t_max_x,t_max_y); //When the ray exists the box
  
  float t_min_x = min(t_left_x,t_right_x);
  float t_min_y = min(t_top_y,t_bot_y);
  float t_min = max(t_min_x,t_min_y); //When the ray enters the box
  
  
  //The the box is behind the ray (negative t)
  if (t_max < 0){
    hit.hit = false;
    hit.t = t_max;
    return hit;
  }
  
  //The ray never hits the box
  if (t_min > t_max){
    hit.hit = false;
  }
  
  //The ray hits, but further out than max_t
  if (t_min > max_t){
    hit.hit = false;
  }
  
  hit.t = t_min;
  return hit;
}

hitInfo rayCircleIntersect(Vec2 center, float r, Vec2 l_start, Vec2 l_dir, float max_t){
  hitInfo hit = new hitInfo();
  
  //Step 2: Compute W - a displacement vector pointing from the start of the line segment to the center of the circle
    Vec2 toCircle = center.minus(l_start);
    
    //Step 3: Solve quadratic equation for intersection point (in terms of l_dir and toCircle)
    float a = 1;  //Length of l_dir (we normalized it)
    float b = -2*dot(l_dir,toCircle); //-2*dot(l_dir,toCircle)
    float c = toCircle.lengthSqr() - (r+strokeWidth)*(r+strokeWidth); //different of squared distances - include pathing circle rad
    
    float d = b*b - 4*a*c; //discriminant 
    
    if (d >=0 ){ 
      //If d is positive we know the line is colliding, but we need to check if the collision line within the line segment
      //  ... this means t will be between 0 and the length of the line segment
      float t1 = (-b - sqrt(d))/(2*a); //Optimization: we only need the first collision
      float t2 = (-b + sqrt(d))/(2*a); //Optimization: we only need the first collision
      //println(hit.t,t1,t2);
      if (t1 > 0 && t1 < max_t){
        hit.hit = true;
        hit.t = t1;
      }
      else if (t1 < 0 && t2 > 0){
        hit.hit = true;
        hit.t = -1;
      }
      
    }
    
  return hit;
}

hitInfo rayCircleListIntersect(Vec2[] centers, float[] radii, Vec2 l_start, Vec2 l_dir, float max_t){
  hitInfo hit = new hitInfo();
  hit.t = max_t;
  for (int i = 0; i < numObstacles; i++){
    Vec2 center = centers[i];
    float r = radii[i]; //INCLUDE navigation circle rad
    
    hitInfo circleHit = rayCircleIntersect(center, r, l_start, l_dir, hit.t);
    if (circleHit.t > 0 && circleHit.t < hit.t){
      hit.hit = true;
      hit.t = circleHit.t;
    }
    else if (circleHit.hit && circleHit.t < 0){
      hit.hit = true;
      hit.t = -1;
    }
  }
  return hit;
}




/////////////////////////////////
// A Probabilistic Roadmap (PRM)
////////////////////////////////

static int numNodes = 600;

//The optimal path found along the PRM
ArrayList<Integer> path = new ArrayList();
int startNode, goalNode; //The actual node the PRM tries to connect do

//Represent our graph structure as 3 lists
ArrayList<Integer>[] neighbors = new ArrayList[numNodes];  //A list of neighbors can can be reached from a given node
Boolean[] visited = new Boolean[numNodes]; //A list which store if a given node has been visited
int[] parent = new int[numNodes]; //A list which stores the best previous node on the optimal path to reach this node

//The PRM uses the above graph, along with a list of node positions
Vec2[] nodePos = new Vec2[numNodes];

//Generate non-colliding PRM nodes
void generateRandomNodes(Vec2[] circleCenters, float[] circleRadii, Vec2 boxTopLeft, float boxW, float boxH){
  for (int i = 0; i < numNodes; i++){
    Vec2 randPos = new Vec2(random(circNavigatorRad,width-circNavigatorRad),random(circNavigatorRad,height-circNavigatorRad));
    boolean insideAnyCircle = pointInCircleList(circleCenters,circleRadii,randPos);
    boolean insideBox = pointInBox(boxTopLeft, boxW,boxH, randPos);
    while (insideAnyCircle /*|| insideBox*/){ //pick new
      randPos = new Vec2(random(circNavigatorRad,width-circNavigatorRad),random(circNavigatorRad,height-circNavigatorRad));
      insideAnyCircle = pointInCircleList(circleCenters,circleRadii,randPos);
      //insideBox = pointInBox(boxTopLeft, boxW,boxH, randPos);
    }
    nodePos[i] = randPos;
  }
}


//Set which nodes are connected to which neighbors based on PRM rules
void connectNeighbors(){
  for (int i = 0; i < numNodes; i++){
    neighbors[i] = new ArrayList<Integer>();  //Clear neighbors list
    for (int j = 0; j < numNodes; j++){
      if (i == j) continue; //don't connect to myself 
      Vec2 dir = nodePos[j].minus(nodePos[i]).normalized();
      float distBetween = nodePos[i].distanceTo(nodePos[j]);
      if(distBetween < pathConstrain){
        hitInfo Boxhit = rayBoxIntersect(boxTopLeft, boxW, boxH, nodePos[i], dir, distBetween);
        hitInfo circleListCheck = rayCircleListIntersect(circlePos, circleRad, nodePos[i], dir, distBetween);
        if (!circleListCheck.hit /*&& !Boxhit.hit*/){
          neighbors[i].add(j);
        }
      }
    }
  }
}

//Build the PRM
// 1. Generate collision-free nodes
// 2. Connect mutually visible nodes as graph neighbors
void buildPRM(Vec2[] circleCenters, float[] circleRadii, Vec2 boxTopLeft, float boxW, float boxH){
  generateRandomNodes(circleCenters, circleRadii, boxTopLeft, boxW, boxH);
  connectNeighbors();
}

//BFS
void runBFS(int startID, int goalID){
  startNode = startID;
  goalNode = goalID;
  circNaviPos = nodePos[startNode]; //SET navigator position init to start
  goalFound = 0;
  ArrayList<Integer> fringe = new ArrayList();  //Make a new, empty fringe
  path = new ArrayList(); //Reset path
  for (int i = 0; i < numNodes; i++) { //Clear visit tags and parent pointers
    visited[i] = false;
    parent[i] = -1; //No parent yet
  }

  //println("\nBeginning Search");
  
  visited[startID] = true;
  fringe.add(startID);
  //println("Adding node", startID, "(start) to the fringe.");
  //println(" Current Fring: ", fringe);
  
  while (fringe.size() > 0){
    int currentNode = fringe.get(0);
    fringe.remove(0);
    if (currentNode == goalID){
      goalFound = 1;
      println("Goal found!");
      break;
    }
    for (int i = 0; i < neighbors[currentNode].size(); i++){
      int neighborNode = neighbors[currentNode].get(i);
      if (!visited[neighborNode]){
        visited[neighborNode] = true;
        parent[neighborNode] = currentNode;
        fringe.add(neighborNode);
        //println("Added node", neighborNode, "to the fringe.");
        //println(" Current Fringe: ", fringe);
      }
    }
    
  }
  if (goalFound == 0){
    print("No goal found");
  }
  
  //print("\nReverse path: ");
  int prevNode = parent[goalID];
  path.add(0,goalID);
  //print(goalID, " ");
  while (prevNode >= 0){
    //print(prevNode," ");
    path.add(0,prevNode);
    prevNode = parent[prevNode];
  }
  print("\n");
  
  //pathToGoal = new ArrayList();
  //for(int i = 0; i < path.size(); i++){
  //  pathToGoal.add(path.get(i)); //reverse the reversed path to get forward path
  //}
  //print("Forward path: ");
  //for(int i = 0; i < pathToGoal.size(); i++){
  //  print(pathToGoal.get(i) + " ");
  //}
  //print("\n");
}

float rotNavigator(float dt,float angleFinal,float angleCur){
  if(angleFinal > 0 && angleCur > 0){
    if(angleFinal - angleCur > -0.01 && angleFinal - angleCur < 0.01){
    angleCur = angleFinal;
    triRotated = true;
    return angleFinal;
    }
    triRotated = false;
    return angleCur + angleFinal*dt;
  }
  else if (angleFinal < 0 && angleCur < 0 && angleCur < angleFinal){
    if(angleFinal - angleCur > -0.01 && angleFinal - angleCur < 0.01){
    angleCur = angleFinal;
    triRotated = true;
    return angleFinal;
    }
    triRotated = false;
    return angleCur - angleFinal*dt;
  }
  else if (angleFinal < 0 && angleCur < 0 && angleCur > angleFinal){
    if(angleFinal - angleCur > -0.01 && angleFinal - angleCur < 0.01){
    angleCur = angleFinal;
    triRotated = true;
    return angleFinal;
    }
    triRotated = false;
    return angleCur + angleFinal*dt;
  }
  else if(angleFinal == angleCur){
    triRotated = true;
    return angleFinal;
  }
  else {
    triRotated = false;
      return angleCur + angleFinal*dt;
  }
}

int traversePath(float dt, int pathNodeIdx){ //write function to perform gradual rotation, SETS bool- completed rotation or not, traverse stop while rotating
  float totaldist = 0;
  if(goalFound == 0){
    println("No path to goal");
    println();
    return path.size()-1;
  }
  if(pathNodeIdx > 0){
    totaldist = nodePos[path.get(pathNodeIdx)].distanceTo(nodePos[path.get(pathNodeIdx-1)]);
  }
  
  float dist = nodePos[path.get(pathNodeIdx)].distanceTo(circNaviPos);
  //println("dist:" + dist);
  if(pathNodeIdx == path.size()-1){
    if(dist < 0.1){
      circNaviPos = nodePos[path.get(pathNodeIdx)];
      return path.size()-1;
    }
  }
  
  Vec2 dir = nodePos[path.get(pathNodeIdx)].minus(circNaviPos);
  dir.normalize();
  //println("dir:" + dir.x + " " + dir.y);
  
  if(dist < 0.1){
    if(pathNodeIdx == path.size() -1){
      if(dist < 0.1){
        circNaviPos = nodePos[path.get(pathNodeIdx)];
        return path.size()-1;
      }
      return pathNodeIdx;
    }
    else {
      circNaviPos = nodePos[path.get(pathNodeIdx)];
      pathNodeIdx++;
      triRotated = false;
    }
  }
  if(triRotated){
    
    
    circNaviPos = circNaviPos.plus(dir.times(dt));
  }
  
  return pathNodeIdx;
}

//-----------------
//   Vector Library
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
  
  public float lengthSqr(){
    return x*x+y*y;
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
