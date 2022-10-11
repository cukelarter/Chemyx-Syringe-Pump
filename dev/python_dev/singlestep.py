# -*- coding: utf-8 -*-
"""
Created on Mon May 30 16:15:46 2022
@author: cukelarter

Script for initiating single step run on Chemyx Syringe Pump. Tested on Chemyx 100-X.

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
conn = connect.Connection(port=str(portinfo[0]),baudrate=baudrate, multipump=False)

#%% Connect and Run Pump - Basic Setup
if __name__=='__main__':
    
    # Open Connection to pump
    conn.openConnection()
    
    # Setup parameters for basic run
    units='mL/min'		 	# OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
    diameter=28.6           # 28.6mm diameter
    volume=1                # 1 mL volume
    rate=1                  # 1 mL/min flow rate
    runtime=volume/rate     # this is calculated implictly by pump
    delay=0.5               # 30 second delay
    
    # Communicate parameters to pump
    conn.setUnits(units)
    conn.setDiameter(diameter)  
    conn.setVolume(volume)      
    conn.setRate(rate)          
    conn.setDelay(delay)       
    
    # Start pump
    conn.startPump()