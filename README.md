<h1>README</h1>

<h3>Description</h3>
This repository consists of two interactive programs designed to assist in the visualization of magnetic fields and the movement of particles in such fields.

<h2>Godot Field Explorer</h2>

This is first person "game" in which you are able to be immersed in a 3 dimensional magnetic field. It allows you to see how changing different properies of particles affects the field they produce and also simulates the motion those particles would take

<h3>Installation</h3>

-Clone this Repo (git clone https://github.com/dq1Mango/magnets/)<br>
-Download the <a href=https://godotengine.org/download/> Godot Engine</a> <br>
-Run Godot and open the directory that was cloned (it will be called magnets)<br>
-Click the triangle in the top right to run the project<br>

I would have liked to provide binaries for the common operating systems, it is actually quite the pain ...  (sorry)

<strong>KeyBindings (also acessible in-game)</strong>:<br>
Movement:<br>
W - Forward <br>
S - Backward<br>
A - Left<br>
D - Right<br>
Space - Up<br>
Shift - Down<br>
<br>
Simulation:<br>
N - New Particle<br>
P - Play / Pause the simulation<br>
R - Reset particles to original position<br>
Q - Quit<br>
<br>
Features to (maybe) add:

-someway to define color gradient<br>
-toggle transparent vectors<br>
-toggle between ways to visualize magnitude (color / length)<br>
-field density<br>
<br>
-type of "particle" (someway to add non point particles (this could be done in a differt *scene* potentially))<br>
<br>
-key rebindings (this is gonna be fake cuz its gonna be soooooo tedius)<br>
-framerate (maybe i dont actually know how fps works in godot)<br>

<h2>Python Solenoid Simulation</h2>

This is a python script written with <a href=https://pypi.org/project/vpython/>vpython</a> that allows you to observe the differnt paths a charged particle can take in the uniform magnetic field produced by a solenoid

<h3>Dependencies</h3>
-<a href=https://pypi.org/project/vpython>vpython</a><br>

<h3>Installation</h3><br>
-Download / copy the "webProject.py" file<br>
-Install necessary dependencies (pip install vpython)<br>
-Execute the file (python3 webProject.py)<br>
