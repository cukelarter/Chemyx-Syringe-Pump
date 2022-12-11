%{
@author: cukelarter

Script for initiating single-step basic run on Chemyx Syringe Pump. Tested on Chemyx 100-X.

After importing serial connection driver we connect to the pump. Connection will remain open
until user clears "conn" variable. The run will continue to completion after connection is closed.
%}
%% Serial Port Settings
% Get available COM ports. Assumes Windows platform (?).
openPorts=getAvailableComPort();
% MUST set baudrate in pump "System Settings", and MUST match this rate:
baudrate=9600;
% initiate Connection object with first open port using defined baudrate
conn=connection;
conn.openConnection(string(openPorts(1)),baudrate);

%% Set Run Parameters - Single-step Setup

% Setup parameters for basic run
units='mL/min';         % OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
diameter=28.6;          % 28.6mm diameter
volume=1;               % 1 mL volume
rate=1;                 % 1 mL/min flow rate
delay=0.5;              % 30 second delay

% Communicate parameters to pump
conn.setUnits(units)
conn.setDiameter(diameter)  
conn.setVolume(volume)      
conn.setRate(rate)          
conn.setDelay(delay)    

%% Start pump
conn.startPump() 