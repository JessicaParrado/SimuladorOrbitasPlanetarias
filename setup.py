'''
*Universidad Sergio Arboleda
*Autores: Jessica Valentina Parrado Alfonso
Fecha:Mayo 2021
Computación Paralela y Distribuida
'''
from distutils.core import setup, Extension
from Cython.Build import cythonize

exts = (cythonize('cy_simulador.pyx'))

setup(ext_modules=exts)