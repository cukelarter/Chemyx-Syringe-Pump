"""
@author: cukelarter

Module for serial interfacing with CHEMYX Syringe Pumps.

"""

import time
import serial
import sys
import glob

def getOpenPorts():
    if sys.platform.startswith('win'):
        ports = ['COM%s' % (i + 1) for i in range(256)]
    elif sys.platform.startswith('linux') or sys.platform.startswith('cygwin'):
        # this excludes your current terminal "/dev/tty"
        ports = glob.glob('/dev/tty[A-Za-z]*')
    elif sys.platform.startswith('darwin'):
        ports = glob.glob('/dev/tty.*')
    else:
        raise EnvironmentError('Unsupported platform')
    result = []
    for port in ports:
        try:
            s = serial.Serial(port)
            s.close()
            result.append(port)
        except (OSError, serial.SerialException):
            pass
    return result

def parsePortName(portinfo):
    """
    On macOS and Linux, selects only usbserial options and parses the 8 character serial number.
    """
    portlist = []
    for port in portinfo:
        if sys.platform.startswith('win'):
            portlist.append(port[0])
        elif sys.platform.startswith('darwin') or sys.platform.startswith('linux'):
            if 'usbserial' in port[0]:
                namelist = port[0].split('-')
                portlist.append(namelist[-1])
    return portlist

class Connection(object):
    """
    Controls serial interfacing with CHEMYX Syringe Pump.
    """
    def __init__(self, port, baudrate,verbose=False,multipump=False):
        """
        Parameters
        ----------
        port : string
        baudrate : int
            MUST match baudrate set in pump settings.
        verbose : bool, optional
            Enables error readouts during exception handling. The default is False.
        multipump : bool
            True if connecting to dual-channel pump. The default is False.

        """
        
        self.port = port
        self.baudrate = baudrate
        self.multipump=multipump
        self.verbose = verbose
        if self.multipump:
            self.currentPump=1

    def openConnection(self):
        try:
            self.ser = serial.Serial()
            self.ser.baudrate = self.baudrate
            self.ser.port = self.port
            self.ser.timeout = 0
            self.ser.open()
            if self.ser.isOpen():
                if self.verbose:
                    print("Opened port")
                    print(self.ser)
                self.getPumpStatus()
                self.ser.flushInput()
                self.ser.flushOutput()
        except Exception as e:
            if self.verbose:
                print('Failed to connect to pump')
                print(e)
            pass

    def closeConnection(self):
        self.ser.close()
        if self.verbose:
            print("Closed connection")

    def sendCommand(self, command):
        """
        Send command to pump.
        If 'set' command is called in multi-pump mode, prepend the number
        of the pump that is being modified.

        Parameters
        ----------
        command : float
            Command to be sent across serial connection.

        """
        if self.multipump and command[:3]=='set':
            command=self.addPump(command)
        print(command)
        try:
            arg = bytes(str(command), 'utf8') + b'\r'
            self.ser.write(arg)
            time.sleep(0.4)
            response = self.getResponse()
            return response
        except TypeError as e:
            if self.verbose:
                print(e)
            self.ser.close()

    def getResponse(self):
        try:
            response_list = []
            while True:
                response = self.ser.readlines()
                for line in response:
                    line = line.strip(b'\n').decode('utf8')
                    line = line.strip('\r')
                    if self.verbose:
                        print(line)
                    response_list.append(line)
                break
            return response_list
        except TypeError as e:
            if self.verbose:
                print(e)
            self.closeConnection()
        except Exception as f:
            if self.verbose:
                print(f)
            self.closeConnection()

    def startPump(self, mode=0, multistep=False):
        """
        Start run of pump. 

        Parameters
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
        """
        command = 'start '
        if self.multipump and mode>0:
            command = f'{mode} {command}'
        if multistep:
            command = f'{command} {int(multistep)}'
        response = self.sendCommand(command)
        return response

    def stopPump(self, mode=0):
        """
        Stop run of pump. 

        Parameters
        ----------
        mode : int
            Mode that pump should stop running.
            For single-channel pumps this value should not change.
            Dual-channel pumps have more control over run state.
            
            0: Default, stops all channels available.
            1: For dual channel pumps, stops just pump 1.
            2: For dual channel pumps, stops just pump 2.
            3: Stop cycle mode.
        """
        command = 'stop '
        if self.multipump and mode>0:
            command = f'{mode} {command}'
        response = self.sendCommand(command)
        return response

    def pausePump(self, mode=0):
        """
        Pauses run of pump. 

        Parameters
        ----------
        mode : int
            Mode that pump should pause current run.
            For single-channel pumps this value should not change.
            Dual-channel pumps have more control over run state.
            
            0: Default, pauses all channels available.
            1: For dual channel pumps, pauses just pump 1.
            2: For dual channel pumps, pauses just pump 2.
            3: Pause cycle mode.
        """
        command = 'pause '
        if self.multipump and mode>0:
            command = f'{mode} {command}'
        response = self.sendCommand(command)
        return response

    def restartPump(self):
        command = 'restart '
        response = self.sendCommand(command)
        return response

    def setUnits(self, units):
        units_dict = {'mL/min': '0', 'mL/hr': '1', 'μL/min': '2', 'μL/hr': '3'}
        command = 'set units ' + units_dict[units]
        response = self.sendCommand(command)
        return response

    def setDiameter(self, diameter):
        command = 'set diameter ' + str(diameter)
        response = self.sendCommand(command)
        return response

    def setRate(self, rate):
        if isinstance(rate,list): 
            # if list of volumes entered, use multi-step command
            command = 'set rate '+','.join([str(x) for x in rate]) 
        else:
            command = 'set rate ' + str(rate)
        response = self.sendCommand(command)
        return response

    def setVolume(self, volume):
        if isinstance(volume,list): 
            # if list of volumes entered, use multi-step command
            command = 'set volume '+','.join([str(x) for x in volume]) 
        else:
            command = 'set volume ' + str(volume)
        response = self.sendCommand(command)
        return response

    def setDelay(self, delay):
        if isinstance(delay,list): 
            # if list of volumes entered, use multi-step command
            command = 'set delay '+','.join([str(x) for x in delay]) 
        else:
            command = 'set delay ' + str(delay)
        response = self.sendCommand(command)
        return response

    def setTime(self, timer):
        command = 'set time ' + str(timer)
        response = self.sendCommand(command)
        return response

    def getParameterLimits(self):
        command = 'read limit parameter'
        response = self.sendCommand(command)
        return response

    def getParameters(self):
        command = 'view parameter'
        response = self.sendCommand(command)
        return response

    def getDisplacedVolume(self):
        command = 'dispensed volume'
        response = self.sendCommand(command)
        return response

    def getElapsedTime(self):
        command = 'elapsed time'
        response = self.sendCommand(command)
        return response

    def getPumpStatus(self):
        command = 'pump status'
        response = self.sendCommand(command)
        return response
    
    def setPump(self,pump):
        """
        Change which pump's settings are being modified in multi-pump setup
        
        Parameters
        ----------
        mode : int
            Pump that will have its settings modified in subsequent commands.
        """
        if self.multipump:
            self.currentPump=pump
            
    def addPump(self, command):
        """
        Prepend pump number to command. Used for 'set' commands.
        
        Parameters
        ----------
        command : string
        """
        if self.multipump:
            return f'{self.currentPump} {command}'
        else:
            return command