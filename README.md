# Chemyx-Syringe-Pump
Control software for CHEMYX Syringe Pump hardware. Includes core connection structures, example single-step and multi-step runs, interactive GUI, and instructions.

Python distribution contains core connection module that connects to pump and sends using PySerial. 
Python GUI uses PyQT5 and must be run within a Python environment.

MATLAB distribution uses serialport object to connect and send commands.
MATLAB GUI must be run using the MATLAB runner.

Future expansion will include handling multi-channel pumps (such as the 4000-X), and export to standalone executables. 
