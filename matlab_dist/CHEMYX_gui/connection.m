classdef connection < handle
    properties
        ser % serialport object
        waittime = 0.3 % float, delay after sending one command
        multipump % bool, true if pump is multi-channel
        currentpump % used in multipump setups
    end
    methods
        function obj = openConnection(obj,port,baudrate,multipump)
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
            obj.multipump=multipump;
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
        function response = startPump(obj)
            obj.sendCommand(sprintf('start pump'));
        end
        function response = stopPump(obj)
            obj.sendCommand(sprintf('stop pump'));
        end
        function response = pausePump(obj)
            obj.sendCommand(sprintf('pause pump'));
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
                obj.currentPump=pump;
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
                response=append(int2str(obj.currentPump),' ',command);
            else
                response=command;
            end
        end
    end
end