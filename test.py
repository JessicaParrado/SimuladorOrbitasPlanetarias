'''
*Universidad Sergio Arboleda
*Autores: Jessica Valentina Parrado Alfonso
Fecha:Mayo 2021
Computación Paralela y Distribuida
'''
import simulador
import cy_simulador
import time


################################# Inicializar Python
py_sun = simulador.Body()
py_sun.name = 'Sun'
py_sun.mass = 1.98892 * 10 ** 30

py_earth = simulador.Body()
py_earth.name = 'Earth'
py_earth.mass = 5.9742 * 10 ** 24
py_earth.px = -1 * simulador.AU
py_earth.vy = 29.783 * 1000  # 29.783 km/sec


py_venus = simulador.Body()
py_venus.name = 'Venus'
py_venus.mass = 4.8685 * 10 ** 24
py_venus.px = 0.723 * simulador.AU
py_venus.vy = -35.02 * 1000
#venus.pencolor('red')


################################# Inicializar Cython
cy_sun = cy_simulador.Body()
cy_sun.name = 'Sun'
cy_sun.mass = 1.98892 * 10 ** 30

cy_earth = cy_simulador.Body()
cy_earth.name = 'Earth'
cy_earth.mass = 5.9742 * 10 ** 24
cy_earth.px = -1 * cy_simulador.AU
cy_earth.vy = 29.783 * 1000  # 29.783 km/sec


cy_venus = cy_simulador.Body()
cy_venus.name = 'Venus'
cy_venus.mass = 4.8685 * 10 ** 24
cy_venus.px = 0.723 * cy_simulador.AU
cy_venus.vy = -35.02 * 1000
#venus.pencolor('red')


### Tiempos
inicio = time.time()
simulador.loop([py_sun, py_earth, py_venus])
tiempoPy = time.time() - inicio

inicio = time.time()
cy_simulador.loop([cy_sun, cy_earth, cy_venus])
tiempoCy = time.time() - inicio

speedUp = round(tiempoPy/tiempoCy,3)

print("Tiempo Python: {} \n".format(tiempoPy))
print("Tiempo Cython: {} \n".format(tiempoCy))
print("SpeedUp: {} \n".format(speedUp))