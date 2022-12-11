classdef connection < handle
    %{
    Connection class for interacting with Chemyx Syringe Pumps using
    MATLAB. Connection file can be stored at same level of run script in
    order to be accessed by other scripts.
    %}
    properties
        ser % serialport object
        waittime = 0.4 % float, delay after sending one command
        multipump = false % bool, true if pump is multi-channel
        currentpump % int, used in multipump setups
    end
    methods
        function obj = openConnection(obj,port,baudrate,varargin)
            % Create serialport object
            obj.ser = serialport(port,baudrate);
            % Chemyx RS232 serial port config
            set(obj.ser,'DataBits',8);              
            set(obj.ser,'Parity','none');
            set(obj.ser,'StopBits',1);
            set(obj.ser,'FlowControl','none');
            configureTerminator(obj.ser,'CR/LF');
            set(obj.ser,'Timeout',0.5);
            % multipump setting
            % setup input parser
            p=inputParser;
            addOptional(p,'multipump',false);
            parse(p,varargin{:});
            % set from parse
            obj.multipump = p.Results.multipump;
            if obj.multipump % if user inputs multipump
                obj.currentpump=1;
            end
        end
        function response = sendCommand(obj, command)
            %{
            Send command to pump.
            If 'set' command is called in multi-pump mode, prepend the number
            of the pump that is being modified.
            
            Parameters
            ----------
            command : string
                Command to be sent across serial connection.
            %}
            % check for multipump setup
            if obj.multipump && strcmp(command(1:3),'set')
                command=obj.addPump(command);
            end
            disp(command) % for debug/feedback purposes
            writeline(obj.ser,command);
            % delay before sending another command
            pause(obj.waittime)
        end
        function response = startPump(obj,varargin)
            %{
            Start run of pump. 

            Optional Parameters
            ----------
            mode : int
                Mode that pump should start running.
                For single-channel pumps this value should not change.
                Dual-channel pumps have more control over run state.

                0: Default, runs all channels available.
                1: For dual channel pumps, runs just pump 1.
                2: For dual channel pumps, runs just pump 2.
                3: Run in cycle mode.
            multistep : bool
                Determine if pump should start in multistep mode
            %}
            command='start ';
            % setup input parser
            p=inputParser;
            addOptional(p,'mode',0);
            addOptional(p,'multistep',false);
            parse(p,varargin{:});
            % set from parse
            mode = p.Results.mode;
            multistep = p.Results.multistep;
            % modify command based on parameters
            if obj.multipump&&mode>0
                command=append(int2str(mode),' ',command);
            end
            if multistep
                command=append(command,' ',int2str(multistep));
            end
            % send command
            obj.sendCommand(sprintf(command));
        end
        function response = stopPump(obj,varargin)
            %{
            Stop run of pump. 

            Optional Parameters
            ----------
            mode (vargin 1) : int
                Mode that pump should stop running.
                For single-channel pumps this value should not change.
                Dual-channel pumps have more control over run state.

                0: Default, stops all channels available.
                1: For dual channel pumps, stops just pump 1.
                2: For dual channel pumps, stops just pump 2.
                3: Stop cycle mode.
            %}
            command='stop ';
            % if optional parameters entered
            if length(varargin)>0
                mode=int2str(cell2mat(varargin(1)));
                if obj.multipump&&mode>0
                    command=append(mode,' ',command);
                end
            end
            % send command
            obj.sendCommand(sprintf(command));
        end
        function response = pausePump(obj,varargin)
            %{
            Pause or unpause run of pump. 

            Optional Parameters
            ----------
            mode (vargin 1): int
                Mode that pump should pause current run.
                For single-channel pumps this value should not change.
                Dual-channel pumps have more control over run state.

                0: Default, pauses all channels available.
                1: For dual channel pumps, pauses just pump 1.
                2: For dual channel pumps, pauses just pump 2.
                3: Pause cycle mode.
            %}
            command='pause ';
            if length(varargin)>0
                mode=int2str(cell2mat(varargin(1)));
                if obj.multipump&&mode>0
                    command=append(mode,' ',command);
                end
            end
            % send command
            obj.sendCommand(sprintf(command));
        end
        function response = setUnits(obj,units)
            units_dict = containers.Map([{'mL/min'}, {'mL/hr'}, {'μL/min'}, {'μL/hr'}],[{0},{1},{2},{3}]);
            obj.sendCommand(sprintf('set units %i', units_dict(units)));
        end
        function response = setDiameter(obj,diameter)
            obj.sendCommand(sprintf('set diameter %f', diameter));
        end
        function response = setRate(obj,rate)
            %{
            Set rate of run. If rate is a list, apply multi-step setting.
            
            Parameters
            ----------
            rate : float, list of floats, string array,
                Rate that pump will output fluid from syringe. List input
                results in multi-step command where each entry is an
                individual step. 
                For multi-step variable rate, enter slashes between
                Rate1 and Rate2 of each step. EX: setRate(["5/10", "15/20"])
            %}
            if length(rate)>1
                % set using multi-step command
                rate=join(string(rate),',');
            else
                rate=string(rate);
            end
            obj.sendCommand(sprintf('set rate %s', rate));
        end
        function response = setVolume(obj,volume)
            %{
            Set volume of run. If rate is a list, apply multi-step setting.
            
            Parameters
            ----------
            volume : float, list of floats, string array,
                Volume of fluid that pump will output from syringe. List input
                results in multi-step command where each entry is an
                individual step. 
            %}
            if length(volume)>1
                % set using multi-step command
                volume=join(string(volume),',');
            else
                volume=string(volume);
            end
            obj.sendCommand(sprintf('set volume %s', volume));
        end
        function response = setDelay(obj,delay)
            %{
            Set delay of run. If rate is a list, apply multi-step setting.
            
            Parameters
            ----------
            delay : float, list of floats, string array,
                Delay before starting each step of the run. List input
                results in multi-step command where each entry is an
                individual step. 
            %}
            if length(delay)>1
                % set using multi-step command
                delay=join(string(delay),',');
            else
                delay=string(delay);
            end
            obj.sendCommand(sprintf('set delay %s', delay));
        end
        function response = closeConnection(obj)
            obj.ser=[];
        end
        function response = setPump(obj, pump)
            %{
            Change which pump's settings are being modified in multi-pump setup
  
            Parameters
            ----------
            pump : int
                Pump that will have its settings modified in subsequent commands.
            %}
            if obj.multipump
                obj.currentpump=pump;
            end
        end
        function response = addPump(obj, command)
            %{
            Prepend pump number to command. Used for 'set' commands.

            Parameters
            ----------
            command : string
            %}
            if obj.multipump
                response=append(int2str(obj.currentpump),' ',command);
            else
                response=command;
            end
        end
    end
end