classdef connection < handle
   properties
       ser % serialport object
       waittime = 0.5 % pauses allow pump to process consecutive serial input
   end
   methods
      function obj = openConnection(obj,port,baudrate)
        % Create serialport object
        obj.ser = serialport(port,baudrate);
        % Chemyx RS232 serial port config
        set(obj.ser,'DataBits',8);              
        set(obj.ser,'Parity','none');
        set(obj.ser,'StopBits',1);
        set(obj.ser,'FlowControl','none');
        configureTerminator(obj.ser,'CR/LF');
        set(obj.ser,'Timeout',0.5);
      end
      function response = startPump(obj)
          writeline(obj.ser,'start pump');
      end
      function response = stopPump(obj)
          writeline(obj.ser,'stop pump');
      end
      function response = pausePump(obj)
          writeline(obj.ser,'pause pump');
      end
      function response = setUnits(obj,units)
          units_dict = containers.Map([{'mL/min'}, {'mL/hr'}, {'μL/min'}, {'μL/hr'}],[{0},{1},{2},{3}]);
          sprintf(units)
          writeline(obj.ser,sprintf('set units %i', units_dict(units)));
          pause(obj.waittime)
      end
      function response = setDiameter(obj,diameter)
          writeline(obj.ser,sprintf('set diameter %f', diameter));
          pause(obj.waittime)
      end
      function response = setRate(obj,rate)
          writeline(obj.ser,sprintf('set rate %f', rate));
          pause(obj.waittime)
      end
      function response = setVolume(obj,volume)
          writeline(obj.ser,sprintf('set volume %f', volume));
          pause(obj.waittime)
      end
      function response = setDelay(obj,delay)
          writeline(obj.ser,sprintf('set delay %f', delay));
          pause(obj.waittime)
      end
      function response = closeConnection(obj)
          obj.ser=[];
      end
   end
end