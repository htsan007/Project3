
By: Harvey Tsang

***Inverse Kinematics simulation overview video:***
---
{% include youtube.html id="rl4Ep5qccD8" %}

---

**Cloth timestamps/list of attempted features:**
--
**IK simulation:** 0:00 - 0:26

I created a cloth simulation starting by defining a 50 x 50 mesh of nodes, and then connecting them with springs. In order to make it look like cloth when drawn, I drew triangles connecting between each point. The cloth is pinned along the top, and is affected by the force of gravity. It collides with the red ball object as it falls. The simulation can be started/stopped using the spacebar.

---
**3D simulation:** 0:27 - 0:52

The simulation scene is in 3D and includes a camera that can be repositioned with the 'wasd' keys. The view direction can be changed with the arrow keys.

---
**High-quality Rendering:** 0:54 - 1:09

For high-quality rendering I added lighting to the scene and also textured the cloth to look like a flag by giving each triangle vertex a corresponding texture coordinate.

---
**IK Difficulties:** 

A difficult part of implementing the cloth was adding the collision with the ball. Because the cloth nodes are just points, the distance when there is a collision between the ball and a point is simply the ball radius or less. However this seemed resulted in a cases where the cloth slightly phase into the ball instead of sliding off of it, or the triangles making up the cloth would become very sharp and distinct. I fixed this by adding a small constant to the collision detection and node repositioning distance, which provided enough leeway in distance to avoid these cases while still looking natural.

------
-----


***Single Agent Navigation (PRM & path traversal) simulation overview video:***
---
{% include youtube.html id="EpYawYf9X0s" %}

----

**Single Agent Navigation timestamps/list of attempted features:**
---
**Single Agent Navigation simulation:** 0:00 - 0:31

I created the SPH Fluid simulation in 2D. There is a total 750 particles that are eventually added to the scene when the simulation is started. While the simulation is running the user is able to interact with the fluid particles using the left-click on the mouse. The simulation can be started/stopped using the spacebar.

---
**Larger Scene:** 0:06 - 0:31

I created a larger scene to look like a bathroom sink. There are visible white "sink" boundaries on the bottom half of the scene and the fluid will generate from the faucet head when started. After all the particles have been spawned, it will look as if the sink is full.

---
**User interaction:** 0:53 - 1:11

To interact with the fluid, the user can use the left-click on the mouse grab and move a chunk of particles. When the mouse-click is released the particles will also be released. 

---
**Color**: 1:12 - 1:25

The particles were colored to represent the total amount of pressure they are under. This forms a blue gradient across the particles, with dark blue being high pressure on the bottom, and light blue having low pressure on the top.

---
**Single Agent Navigation Difficulties:**

I had some trouble at first with making the fluid flow realisticly. Everything was just moving too slowly and all my variables had to be very large for any movement to occur. It ended up being a scaling issue where the values were being misrepresented in the scene. To fix this I moved all the scene scaling to the draw function so that all the calculations done before that were independent from the scene scale. This made it so that the scene scale would only be applied when everything was ready to be displayed.

----
----

***Image Captures***
---

IK:
-

|Both arms reach Goal:          | Arms out of reach of ball:          |Right arm reaches ball:    | 
|-------------------------|-------------------------|-------------------------------------|
|<img src="./docs/assets/IK both arms goal.JPG" width="480" height="640"> | <img src="./docs/assets/IK both arms out of reach left.JPG" width="640" height="480"> |  <img src="./docs/assets/right arm reach goal.JPG" width="640" height="480">  |       

Single Agent Navigation:
-

|Start of traversal:          | Mid traversal:          |End of traversal:    | 
|-------------------------|-------------------------|-------------------------------------|
|<img src="./docs/assets/start traversal pathing.JPG" width="1024" height="768"> | <img src="./docs/assets/mid path traversal.JPG" width="1024" height="768"> |  <img src="./docs/assets/fin path traversal.JPG" width="1024" height="768">  |          

---
***Source code:***

<a href= "/IK_code/CSCI5611_Proj3_IK.pde" download>Download IK Code</a>

<a href= "/Pathing_code/CSCI5611_proj3_pathing.pde" download>Download Pathing Code</a>

The cloth and fluid simulations were written by me. Included in them are the functionalities for each corresponding simulation, as well as a 2D/3D vector class if it was 2D or 3D. Both vector classes were modified based on Professor Guy's original version. I also made use of the provided camera.pde functionality that was provided from in class. The cloth simulation and SPH fluid simulation were written using Professor Guy's cloth/fluid slides and code examples as a basis. I also referenced  <a href="https://processing.org/reference/"> Processing documentation </a> to explore built-in functions and their functionalities regarding PImage, texturing, mouse/key input, etc.

The fluid simulation background texture was sourced from: <a href="https://www.vecteezy.com/photo/17154821-the-bathroom-faucet-is-turned-off-to-save-water-energy-and-protect-the-environment-water-saving-concept "> Vecteezy </a>

The cloth flag texture was sourced from: <a href="https://www.freepik.com/free-vector/illustration-usa-flag_2807790.htm#query=american%20flag&position=0&from_view=keyword&track=ais "> Freepik </a>

See the full project repository <a href="https://github.com/htsan007/Project3/tree/main "> ***here*** </a>
