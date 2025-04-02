#Web VPython 3.2
from vpython import *

# Scene setup: 3D scene with title
scene = canvas(title="3D Solenoid and Magnetic Field Visualization", background=color.purple)

print("This is a visual simulation of a charged particles experience within a solenoid. A solenoid is a coil of wire that, when electricity flows through it, creates a magnetic field, similar to a bar magnet! An ideal solenoid has uniform magnetic field B within it, and negligible field outside of it. Using the buttons below, explore how it affects a charged particle moving within it.")

# Solenoid : Positioned at (-10, 0, 0), length 20, radius 2
solenoid = cylinder(pos=vector(-10, 0, 0), axis=vector(20, 0, 0), radius=2, opacity=0.3)

# Particle: Yellow sphere with trail, initially at (0, 0, 0)
particle = sphere(pos=vector(0, 0, 0), radius=0.2, color=color.yellow, make_trail=True)
particle.velocity = vector(0, 0, 0)  # initialized

#exampleig = sphere(pos=vector(10, 0, 0), radius=0.2, color=color.purple, make_trail=False)

# Reset functions
def reset_particle():
    particle.pos = vector(0, 0, 0)
    place_stationary()
    particle.clear_trail()

def reset_scene():
    reset_particle()
    solenoid.pos = vector(-10, 0, 0)
    solenoid.axis = vector(20, 0, 0)

# Functions to control particle velocity
def launch_perpendicular(): 
    particle.velocity = vector(0, 1, 0)  # Set perpendicular velocity

def launch_parallel(): 
    particle.velocity = vector(1, 0, 0)  # Set parallel velocity

def place_stationary(): 
    particle.velocity = vector(0, 0, 0)  # Set stationary velocity
    
def helix(): 
    particle.velocity = vector(1,1,0)

# Toggle visibility of field arrows
def toggle_field_lines():
    for arrow_on_line in field_arrows:
        arrow_on_line.visible = not arrow_on_line.visible

# Buttons for particle motion control
button(text="Launch Perpendicular", bind=launch_perpendicular)
button(text="Launch Parallel", bind=launch_parallel)
button(text="Place Stationary", bind=place_stationary)
button(text="Reset Scene", bind=reset_scene)
button(text="Helix", bind=helix)
button(text="Toggle Field Lines", bind=toggle_field_lines)

# Current direction arrows: Above and below the x-axis
for x in range(-6, 6, 2):
    arrow(pos=vector(x, 2, 0), axis=vector(0, 0, 2), color=color.blue)
    arrow(pos=vector(x, -2, 0), axis=vector(0, 0, -2), color=color.blue)

# North pole indicator: Red arrow pointing along the x-axis
north_arrow = arrow(pos=vector(10, 0, 0), axis=vector(3, 0, 0), color=color.red)

# Field arrows: Placed at intervals along the magnetic field line
field_arrows = []
for x in range(-10, 6, 5):
    arrow_on_line = arrow(pos=vector(x, 0, 0), axis=vector(2, 0, 0), color=color.green)
    field_arrows.append(arrow_on_line)

# Animation loop
dt = 0.01
B = vector(1, 0, 0)  # Uniform magnetic field
q = 1  # Charge of the particle

# Animation loop that handles the motion of the particle

while particle.pos.x < 10: # makes it so it stops before it leaves solenoid
    rate(100)
    
    # Calculate the magnitude
    velocity_magnitude = particle.velocity.mag
    
    # Particle motion
    if velocity_magnitude > 0:
        F = q * cross(particle.velocity, B)  # Calculate force on particle due to magnetic field
        particle.velocity += F * dt  # Update particle velocity based on force
        particle.pos += particle.velocity * dt  # Update particle position based on velocity
    
