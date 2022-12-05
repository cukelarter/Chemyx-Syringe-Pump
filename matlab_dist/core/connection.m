classdef connection < handle
    properties
        ser % serialport object
        waittime = 0.3 % float, delay after sending one command
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
            if length(varargin)>0 % if user inputs multipump
                obj.multipump=cell2mat(varargin(1));
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
            mode (vargin 1) : int
                Mode that pump should start running.
                For single-channel pumps this value should not change.
                Dual-channel pumps have more control over run state.

                0: Default, runs all channels available.
                1: For dual channel pumps, runs just pump 1.
                2: For dual channel pumps, runs just pump 2.
                3: Run in cycle mode.
            %}
            command='start pump';
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
            command='stop pump';
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
            command='pause pump';
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
            obj.sendCommand(sprintf('set rate %f', rate));
        end
        function response = setVolume(obj,volume)
            obj.sendCommand(sprintf('set volume %f', volume));
        end
        function response = setDelay(obj,delay)
            obj.sendCommand(sprintf('set delay %f', delay));
        end
        function response = closeConnection(obj)
            obj.ser=[];
        end
        function response = setPump(obj, pump)
            %{
            Change which pump's settings are being modified in multi-pump setup
  
            Parameters
            ----------
            mode : int
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