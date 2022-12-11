%{
@author: cukelarter

Script for initiating single-step run on dual-channel Chemyx Syringe Pump. Tested on Chemyx 4000-X.

After importing serial connection driver we connect to the pump. Connection will remain open
until user clears "conn" variable. The run will continue to completion after connection is closed.
%}
%% Serial Port Settings
% Get available COM ports. Assumes Windows platform (?).
openPorts=getAvailableComPort();
% MUST set baudrate in pump "System Settings", and MUST match this rate:
baudrate=9600;
% initiate Connection object with first open portusing defined baudrate
conn=connection;
% defining multipump parameter true initiates connection as dualchannel
conn.openConnection(string(openPorts(1)),baudrate,'multipump',true);

%% Set Run Parameters - Single-step Setup

% Specify which pump is having its parameters modified
conn.setPump(1)

% Setup parameters for pump 1
units='mL/min';         % OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
diameter=28.6;          % 28.6mm diameter
volume=1;               % 1 mL volume
rate=1;                 % 1 mL/min flow rate
delay=0.5;              % 30 second delay

% Communicate parameters to pump 1
conn.setUnits(units)
conn.setDiameter(diameter)  
conn.setVolume(volume)      
conn.setRate(rate)          
conn.setDelay(delay)    

% Specify which pump is having its parameters modified
conn.setPump(2)

% Setup parameters for pump 2
units='mL/min';         % OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
diameter=28.6;          % 28.6mm diameter
volume=1;               % 1 mL volume
rate=1;                 % 1 mL/min flow rate
delay=0.5;              % 30 second delay

% Communicate parameters to pump 2
conn.setUnits(units)
conn.setDiameter(diameter)  
conn.setVolume(volume)      
conn.setRate(rate)          
conn.setDelay(delay)

%% Start pump
conn.startPump('mode',0)
