# -*- coding: utf-8 -*-
"""
Created on Mon May 30 16:15:46 2022

@author: cukelarter
Barebones script for basic mode run of Chemyx Syringe Pump in Python
Tested on Chemyx 100-X.
"""
#%% Import CHEMYX serial connection modules
from core import connect

# get open port info
portinfo = connect.getOpenPorts() 

# initiate Connection object
conn = connect.Connection(port=str(portinfo[0]),baudrate=9600, x=0, mode=0)

#%% Connect and Run Pump - Basic Loop Setup
if __name__=='__main__':
    
    # open Connection to pump
    conn.openConnection()
    
    # Apply some parameters to a basic run
    # set parameters
    conn.setUnits('mL/min') # OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
    diameter=28.6           # 28.6mm diameter - can be set in pump GUI
    volume=1                # 1 mL volume
    rate=1                  # 1 mL/min flow rate
    runtime=volume/rate     # this is calculated implictly by pump
    delay=0.5               # 30 second delay
    
    # communicate parameters to pump
    conn.setDiameter(diameter)  
    conn.setVolume(volume)      
    conn.setRate(rate)          
    conn.setDelay(delay)       
    
    # start pump
    conn.startPump()