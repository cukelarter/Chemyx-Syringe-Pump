# -*- coding: utf-8 -*-
"""
Created on Tue Oct  4 15:41:48 2022

@author: cukelarter

Script for initiating basic run on Chemyx Syringe Pump. Tested on Chemyx 100-X.

After importing serial connection driver we connect to the pump. Connection will remain open
until user calls "conn.closeConnection()". If user does not call this before exiting
the connection will remain locked open until the connection is physically broken (unplugged).
The run will continue to completion after connection is closed.

"""

#%% Import CHEMYX serial connection module/driver
from core import connect

# get open port info
portinfo = connect.getOpenPorts() 

# MUST set baudrate in pump "System Settings", and MUST match this rate:
baudrate=9600
# initiate Connection object with first open port
conn = connect.Connection(port=str(portinfo[0]),baudrate=baudrate, multipump=True)

#%% Connect and Run Pump - Basic Setup
if __name__=='__main__':
    
    # Open Connection to pump
    conn.openConnection()
    
    # Specify which pump is having its parameters modified
    conn.changePump(1)
    
    # Setup parameters for pump 1
    units='mL/min'		 	# OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
    diameter=28.6           # 28.6mm diameter
    volume=1                # 1 mL volume
    rate=1                  # 1 mL/min flow rate
    runtime=volume/rate     # this is calculated implictly by pump
    delay=0.5               # 30 second delay
    
    # Communicate parameters to pump 1
    conn.setUnits(units)
    conn.setDiameter(diameter)  
    conn.setVolume(volume)      
    conn.setRate(rate)          
    conn.setDelay(delay)       
    
    # Specify which pump is having its parameters modified
    conn.changePump(2)
    
    # Setup parameters for pump 2
    units='mL/min'		 	# OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
    diameter=28.6           # 28.6mm diameter
    volume=1                # 1 mL volume
    rate=1                  # 1 mL/min flow rate
    runtime=volume/rate     # this is calculated implictly by pump
    delay=0.5               # 30 second delay
    
    # Communicate parameters to pump 1
    conn.setUnits(units)
    conn.setDiameter(diameter)  
    conn.setVolume(volume)      
    conn.setRate(rate)          
    conn.setDelay(delay)  
    
    # Start pump
    conn.startPump()