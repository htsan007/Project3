
By: Harvey Tsang

***Inverse Kinematics simulation overview video:***
---
{% include youtube.html id="ZqVatlZT_NA" %}

---

**Multiarm IK timestamps/list of attempted features:**
--
**IK multi-arm simulation:** 0:00 - 0:18, 0:29 - 1:01, 1:57 - 2:19

I created a multi-armed inverse kinematics simulation. It is designed to look like a person and mimic their limbs, with the exception of having more joints than normal. The two arms are rooted to the top of the spine, which itself is rooted to the base of the pelvis. The end point that the arms attempt to reach is defined by a green ball that moves around the scene following the general movement of the mouse cursor. When the goal is placed on the left side of the screen, the entity will attempt to reach it with it's left arm, the same applies to the right side and the right arm. When the goal is placed nearer to the middle of the screen, both arms will attempt to reach it. The arms are constrained by their lengths and roots, so in the event that the goal is out of reach, the arm will stop at its full extension.

---
**User Interaction:** 0:19 - 0:29

The user can interact with the simulation by moving the mouse cursor to continuously change the goal position. The simulation can also be paused and unpaused using the spacebar. 

---
**Joint angle & rotation limits:** 1:03 - 1:35, 1:36 - 1:56, 2:19 - 2:29

Joint limits were added to try and mimic a humans set of joints. Obviously since the implemented joints move only in 2D it is missing a degree of freedom. The elbow joints were restricted from bending backwards, and all joints along the arms were prevented from completely folding in when curling. A limit was also placed on the spine joint to show the spine bending, but not too far. Rotation limits were placed on the joint angles as they update, to prevent insane amounts angular change that looked unnatural.

---
**3D simulation:** 2:30 - 2:57

The simulation scene is in 3D and includes a camera that can be repositioned with the 'wasd' keys. The view direction can be changed with the arrow keys.

---
**IK difficulties:** 

A difficult part in implementing the multi-arms was correctly positioning and rotating the limbs, especially when transitioning into a 3D environment. I had some issues where the limbs all broken up and rotating off the wrong axis. This was fixed by performing another translation after rotating the limb. 

------
-----


***Single Agent Navigation (PRM & path traversal) simulation overview video:***
---
{% include youtube.html id="EpYawYf9X0s" %}

----

**Single Agent Navigation timestamps/list of attempted features:**
---
**Single Agent Navigation simulation:** 0:00 - 0:33, 2:00 - 2:22

I also implemented the single agent navigation. For path planning I used PRM, considering the configuration space defined by the radomized obstacles and the navigator. Random nodes were placed within the configuration space and then connected. This network of connected nodes was then accessed using the BFS algorithm to create a path from the chosen start point to the chosen goal point. The navigator then traversed along that path, making turns when necessary, until the goal was reached. To start or stop the traversal, the spacebar is pressed.

---
**Path traversal and smooth rotation:** 0:34 - 1:02

In order to traverse the path I calculated the distance between the navigators position and the next node in the path. From there I updated the position using the distance and a factor dt until the position was close enough to the node, in which case I simply set the position equal to the node position. This was repeated for all nodes in the path. To allow for smooth rotation I did something similar, where at every node the navigator stops and rotates by the total angle times a factor dt. 

---
**Reseting Paths/Scene:** 1:03 - 1:59

The simulation can also be completely reset by pressing 'r'. This will re-generate the obstacles, nodes and paths, and start and goal positions. An alternative option is to only regenerate the nodes and paths, by clicking with the mouse.

---
**Single Agent Navigation Difficulties:**

I had some issues when implementing the rotation. It would only rotate smoothly for counter-clockwise rotations, and for clockwise rotations it would simply snap quickly to face the new direction. I found that I wasn't accounting for all the possible angle increment combinations in my angle update function (which kept track of the current angle and the desired final angle). Before I had simply updated the angle by adding the final angle times a factor dt, but there are more complex cases where the angles don't have the same sign and adding doesn't increment the current angle correctly.

----
----

***Image Captures***
---

IK:
-

|Both arms reach Goal:          | Arms out of reach of ball:          |Right arm reaches ball:    | 
|-------------------------|-------------------------|-------------------------------------|
<img src="./docs/assets/IK both arms goal.JPG" width="300" height="250"> | <img src="./docs/assets/IK both arms out of reach left.JPG" width="300" height="250"> |  <img src="./docs/assets/right arm reach goal.JPG" width="300" height="250">         

Single Agent Navigation:
-

|Start of traversal:          | Mid traversal:          |End of traversal:    | 
|-------------------------|-------------------------|-------------------------------------|
<img src="./docs/assets/start traversal pathing.JPG" width="400" height="300"> | <img src="./docs/assets/mid path traversal.JPG" width="400" height="300"> |  <img src="./docs/assets/fin path traversal.JPG" width="400" height="300">            

---
***Source code:***

<a href= "/IK_code/CSCI5611_Proj3_IK.pde" download>Download IK Code</a>

<a href= "/Pathing_code/CSCI5611_proj3_pathing.pde" download>Download Pathing Code</a>

The IK and Navigation simulations were written by me. Included in them are the functionalities for each corresponding simulation, as well as a 2Dvector class. The vector classe was modified based on Professor Guy's original version. I also made use of the provided camera.pde functionality that was provided from in class. Both simulations were based off of Professor Guy's slides or class exercises. I also referenced  <a href="https://processing.org/reference/"> Processing documentation </a> to explore built-in functions and their functionalities regarding shapes, texturing, mouse/key input, etc.

The single agent navigation asteroid texture was sourced from: <a href="https://www.cleanpng.com/png-asteroid-sprite-clip-art-asteroid-png-photos-116338/download-png.html"> Cleanpng </a>

See the full project repository <a href="https://github.com/htsan007/Project3/tree/main "> ***here*** </a>
