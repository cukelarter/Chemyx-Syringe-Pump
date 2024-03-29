%{
@author: cukelarter

Script for initiating multi-step run on Chemyx Syringe Pump. Tested on Chemyx 100-X.

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
conn.openConnection(string(openPorts(1)),baudrate);

%% Set Run Parameters - Multi-step Setup

% Setup parameters for multistep run
units='mL/min';         % OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
diameter=28.6;          % 28.6mm diameter
volume=[0.25,5,2];      % Volume = [Step1: 0.25mL, Step2: 5mL, Step3: 2mL]
delay=[0.1,0.2,0.3];    % Delay  = [Step1: 6s,     Step2: 12s, Step3: 18s]

% Variable flow rates in each step, linear ramping generated by pump
% between rate1 and rate2 for each step
% Rate = [Step1: 20mL/min->21mL/min, Step2: 5mL/min->6mL/min, Step3: 40mL/min->41mL/min]
rate1=[20,5,40];        
rate2=[21,6,41];
nsteps = length(rate1);
% format variable flow rate command
rates=[];
for step=1:nsteps
    rates = [rates; strjoin([string(rate1(step)),string(rate2(step))],"/")];
end

% Communicate parameters to pump
conn.setUnits(units)
conn.setDiameter(diameter)  
conn.setVolume(volume)      
conn.setRate(rates)          
conn.setDelay(delay)    

%% Start pump - set multistep attribute to true
conn.startPump('mode',0,'multistep',1)
