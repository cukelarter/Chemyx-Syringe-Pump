%{
Created on Mon June 13 16:15:46 2022
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

% initiate Connection object with first open port
conn=connection;
conn.openConnection(string(openPorts(1)),baudrate);

%% Connect and Run Pump - Basic Setup

% Setup parameters for basic run
units='mL/min';         % OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
diameter=28.6;            % 28.6mm diameter - can be set in pump GUI
volume=1;               % 1 mL volume
rate=1;                 % 1 mL/min flow rate
runtime=volume/rate;    % this is calculated implictly by pump
delay=0.5;              % 30 second delay

% Communicate parameters to pump
conn.setUnits(units)
conn.setDiameter(diameter)  
conn.setVolume(volume)      
conn.setRate(rate)          
conn.setDelay(delay)    

% Start pump
conn.startPump()