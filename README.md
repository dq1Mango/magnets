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

<h3>Screenshots</h3>
The position traced by a charged particle launched inside a uniform magnetic field<br>
<img width="828" alt="Screenshot 2025-04-01 at 10 10 38 PM" src="https://github.com/user-attachments/assets/a1069cc1-4741-4bb1-95a0-93a5a9554332" /><br>
Magnetic field produced from a single moving particle<br>
<img width="576" alt="Screenshot 2025-04-01 at 10 13 32 PM" src="https://github.com/user-attachments/assets/5076c6e2-830b-407f-9c39-1f71f20bddb2" /><br>
Magnetic field of a "wire"<br>
<img width="575" alt="Screenshot 2025-04-01 at 10 16 14 PM" src="https://github.com/user-attachments/assets/7093f96c-1e7e-4cfd-aa49-d00b458fd150" /><br>
Complex superposition of 3 particles<br>
<img width="576" alt="Screenshot 2025-04-01 at 10 18 40 PM" src="https://github.com/user-attachments/assets/58b2546e-0164-4e4e-bca8-90e583d35b78" /><br>
