'''
*Universidad Sergio Arboleda
*Autores: Jessica Valentina Parrado Alfonso
Fecha:Mayo 2021
Computación Paralela y Distribuida
'''

#cython: language_level=3
cimport cython
cdef extern from "math.h":
    long double sqrt(double x) nogil
cdef extern from "math.h":
    long double cos(double x) nogil
cdef extern from "math.h":
    long double sin(double x) nogil
cdef extern from "math.h":
    long double atan2(double x , double y) nogil


# The gravitational constant G
cdef float G = 6.67428e-11

# Assumed scale: 100 pixels = 1AU.
AU = (149.6e6 * 1000)     # 149.6 million km, in meters.
cdef float SCALE = 250 / AU
#class Body(Turtle):
cdef class Body():
    """Subclass of Turtle representing a gravitationally-acting body.

    Extra attributes:
    mass : mass in kg
    vx, vy: x, y velocities in m/s
    px, py: x, y positions in m
    """
    cdef public double vx, vy, px, py, mass
    cdef public str name

    def __init__(self):

        self.name = 'Body'
        self.mass = 0.0
        self.vx =  0.0
        self.vy =  0.0
        self.px = 0.0
        self.py = 0.0
    @cython.cdivision(True)
    cdef tuple attraction(Body self, Body other):
        """(Body): (fx, fy)

        Returns the force exerted upon this body by the other body.
        """
        # Report an error if the other object is the same as this one.
        if self is other:
            raise ValueError("Attraction of object %r to itself requested"
                             % self.name)

        # Compute the distance of the other body.
        cdef double sx
        cdef double sy
        cdef double ox
        cdef double oy
        cdef double dx
        cdef double dy
        cdef double d

        sx, sy = self.px, self.py
        ox, oy = other.px, other.py
        dx = (ox-sx)
        dy = (oy-sy)
        d = sqrt(dx**2 + dy**2)
        cdef long double f
        # Report an error if the distance is zero; otherwise we'll
        # get a ZeroDivisionError exception further down.
        if d == 0:
            raise ValueError("Collision between objects %r and %r"
                             % (self.name, other.name))

        # Compute the force of attraction
        f = G * self.mass * other.mass / (d**2)
        cdef double theta
        cdef double fx
        cdef double fy
        # Compute the direction of the force.
        theta = atan2(dy, dx)
        fx = cos(theta) * f
        fy = sin(theta) * f
        return fx, fy

def loop(list bodies):
    """([Body])

    Never returns; loops through the simulation, updating the
    positions of all the provided bodies.
    """
    cdef long double timestep
    timestep = 24*3600  # One day
    
    "for body in bodies:"
    "    body.penup()"
    "   body.hideturtle()"
    cdef int step
    step = 1
    """365 steps in orden to complete eaarth's cycle"""
    cdef long double total_fx
    cdef long double total_fy
    cdef long double fx
    cdef long double fy
    cdef int b 
    cdef Body body, other
    while (step <= 365 * 1000):
        #update_info(step, bodies)
        step += 1

        force = {}
        for body in bodies:
            # Add up all of the forces exerted on 'body'.
            total_fx = total_fy = 0.0
            for other in bodies:
                # Don't calculate the body's attraction to itself
                if body is other:
                    continue
                fx, fy = body.attraction(other)
                total_fx += fx
                total_fy += fy

            # Record the total force exerted.
            force[body] = (total_fx, total_fy)

        # Update velocities based upon on the force.
        for body in bodies:
            fx, fy = force[body]
            body.vx += fx / body.mass * timestep
            body.vy += fy / body.mass * timestep

            # Update positions
            body.px += body.vx * timestep
            body.py += body.vy * timestep
            #body.goto(body.px*SCALE, body.py*SCALE)
            # body.dot(3)