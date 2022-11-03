# -*- coding: utf-8 -*-
"""
Created on Mon Oct  17 16:31:35 2022

@author: cukelarter
GUI for interaction with Chemyx syringe pumps.
This GUI is to be used specifically with Dual-Channel implementations.
Tested on CHEMYX 4000-X.
"""

from PyQt5.QtWidgets import *
from PyQt5.QtGui import *
from PyQt5.QtCore import Qt

from core import connect
import sys
import logging

# Logging Setup
logging.basicConfig()
logger=logging.getLogger('Log')
logger.setLevel(logging.INFO)

#%% Testing
class ChemyxPumpGUI(QDialog):
    """GUI for Chemyx Syringe Pumps
    """
    def __init__(self):
        super(ChemyxPumpGUI,self).__init__()
        # set title
        self.setWindowTitle('Chemyx Pump Connector')
        # setting geometry of the window
        self.setGeometry(100, 100, 500, 400)
        # restrict to unmodifiable dimensions
        
        # creating group boxes
        self.logoGroupBox = QGroupBox()
        self.connGroupBox = QGroupBox("Connection Variables")
        self.formGroupBox = QGroupBox("Single-Step Pump Variables")
        self.buttGroupBox = QGroupBox('Run Controls')
        
        # initialize run variable control tabs
        self.tabs=QTabWidget()
        self.tab1=QWidget()
        self.tab2=QWidget()
        self.tab3=QWidget()
        self.tabs.addTab(self.tab1,"Single-Step Pump Variables")
        self.tabs.addTab(self.tab2,"Multi-Step Pump Variables")
        self.tabs.addTab(self.tab3,"Cycle Mode Pump Variables")
        
        # initialize variable to tell if the pump is running
        # used exclusively by start/pause&unpause/stop functions
        self.isRunning=False

        # initialize pump variables and widgets
        self.initPumpVar()
        self.initUI()
        
        # initialize connection controller
        self.CONNECTION = connect.Connection(port=str(self.serportCBox.currentText()),baudrate=self.baudCBox.currentText(),multipump=True)
        self.connected=False
        
    def initPumpVar(self):
        # set default Syringe Pump Variables
        self.units='mL/min'     # OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
        self.unitlist=['mL/min','mL/hr',"\u03BCL/min",'\u03BCL/hr']
        [self.volunit,self.timeunit]=self.units.split('/')
            
    def initUI(self):
        # Logo Graphics
        logopath='static/logo.png'
        self.logo = QPixmap(logopath).scaled(200,100)
        self.logoImage=QLabel()
        self.logoImage.setPixmap(self.logo)
        self.logoImage.setAlignment(Qt.AlignCenter)
        
        # Connection Setup
        portinfo = connect.getOpenPorts()
        portlist = portinfo
        self.serportCBox = QComboBox(width=115)
        self.serportCBox.addItems(portlist)
        self.baudCBox = QComboBox(width=85)
        self.baudCBox.addItems(['9600','14400','19200','38400','57600','115200'])
        self.connectLbl = QLabel('DISCONNECTED')
        self.connectLbl.setStyleSheet("color:red")
        self.connectBtn = QPushButton('Connect')
        self.connectBtn.clicked.connect(lambda:self.connect())

        # Single-Step Pump Variable Fields
        # pump 1
        self.unitsCBox_pump1 = QComboBox()
        self.unitsCBox_pump1.addItems(self.unitlist)
        self.diameterLineEdit_pump1=QLineEdit()
        self.diameterLineEdit_pump1.setValidator(QDoubleValidator(bottom=0))
        self.volumeLineEdit_pump1=QLineEdit()
        self.volumeLineEdit_pump1.setValidator(QDoubleValidator())    
        self.flowRateLineEdit_pump1=QLineEdit()
        self.flowRateLineEdit_pump1.setValidator(QDoubleValidator(bottom=0))
        self.delayLineEdit_pump1=QLineEdit()
        self.delayLineEdit_pump1.setValidator(QDoubleValidator(bottom=0))
        # pump 2
        self.unitsCBox_pump2 = QComboBox()
        self.unitsCBox_pump2.addItems(self.unitlist)
        self.diameterLineEdit_pump2=QLineEdit()
        self.diameterLineEdit_pump2.setValidator(QDoubleValidator(bottom=0))
        self.volumeLineEdit_pump2=QLineEdit()
        self.volumeLineEdit_pump2.setValidator(QDoubleValidator())    
        self.flowRateLineEdit_pump2=QLineEdit()
        self.flowRateLineEdit_pump2.setValidator(QDoubleValidator(bottom=0))
        self.delayLineEdit_pump2=QLineEdit()
        self.delayLineEdit_pump2.setValidator(QDoubleValidator(bottom=0))
        
        # Multi-Step Pump Variable Fields
        # pump 1
        self.multi_unitsCBox_pump1 = QComboBox()
        self.multi_unitsCBox_pump1.addItems(self.unitlist)
        self.multi_diameterLineEdit_pump1=QLineEdit()
        self.multi_diameterLineEdit_pump1.setValidator(QDoubleValidator(bottom=0))
        self.multi_volumeLineEdit_pump1=QLineEdit()
        self.multi_volumeLineEdit_pump1.setValidator(QDoubleValidator())    
        self.multi_flowRateLineEdit_pump1=QLineEdit()
        self.multi_delayLineEdit_pump1=QLineEdit()
        self.multi_delayLineEdit_pump1.setValidator(QDoubleValidator(bottom=0))
        # pump 2
        self.multi_unitsCBox_pump2 = QComboBox()
        self.multi_unitsCBox_pump2.addItems(self.unitlist)
        self.multi_diameterLineEdit_pump2=QLineEdit()
        self.multi_diameterLineEdit_pump2.setValidator(QDoubleValidator(bottom=0))
        self.multi_volumeLineEdit_pump2=QLineEdit()
        self.multi_volumeLineEdit_pump2.setValidator(QDoubleValidator())    
        self.multi_flowRateLineEdit_pump2=QLineEdit()
        self.multi_delayLineEdit_pump2=QLineEdit()
        self.multi_delayLineEdit_pump2.setValidator(QDoubleValidator(bottom=0))
        
        # Cycle Mode Pump Variable Fields
        # pump 1
        self.cycle_unitsCBox = QComboBox()
        self.cycle_unitsCBox.addItems(self.unitlist)
        self.cycle_diameterLineEdit=QLineEdit()
        self.cycle_diameterLineEdit.setValidator(QDoubleValidator(bottom=0))
        self.cycle_volumeLineEdit=QLineEdit()
        self.cycle_volumeLineEdit.setValidator(QDoubleValidator())    
        self.cycle_flowRateLineEdit=QLineEdit()
        self.cycle_flowRateLineEdit.setValidator(QDoubleValidator(bottom=0))
        self.cycle_delayLineEdit=QLineEdit()
        self.cycle_delayLineEdit.setValidator(QDoubleValidator(bottom=0))
        
        # Button Controls
        # start/pause&unpause/stop
        self.stopBtn = QPushButton('Stop')
        self.stopBtn.clicked.connect(lambda:self.stop())
        self.pauseBtn = QPushButton('Pause')
        self.pauseBtn.clicked.connect(lambda:self.pause())
        self.startBtn = QPushButton('Start')
        self.startBtn.clicked.connect(lambda:self.start())
        self.startBtn_pump1 = QPushButton('Start Pump 1')
        self.startBtn_pump1.clicked.connect(lambda:self.start_pump(1))
        self.startBtn_pump2 = QPushButton('Start Pump 2')
        self.startBtn_pump2.clicked.connect(lambda:self.start_pump(2))
        # scan button
        self.scanBtn = QPushButton('Scan For Open Ports')
        self.scanBtn.clicked.connect(lambda:self.scanPorts())
        
        # Initialize Widgets to Sub-Layouts
        logobox=QVBoxLayout()
        logobox.addWidget(self.logoImage)
        
        # Connection Widget
        connbox=QFormLayout()
        scanbox=QHBoxLayout()   # sublayout for scan button and port selection
        scanbox.addWidget(self.serportCBox)
        scanbox.addWidget(self.scanBtn)
        connbox.addRow(QLabel('Serial Port'),scanbox)
        connbox.addRow(QLabel('Baud Rate (WARNING: Must match Baud Rate specified in pump System Settings)',wordWrap=True),self.baudCBox)
        connbox.addRow(self.connectLbl,self.connectBtn)
        
        # Single-Step Run Widget
        fbox_1step = QHBoxLayout()
        # pump 1
        fbox_1step_pump1 = QFormLayout()
        fbox_1step_pump1.addRow(QLabel("Pump 1"))
        fbox_1step_pump1.addRow(QLabel("Units"),self.unitsCBox_pump1)
        fbox_1step_pump1.addRow(QLabel("Syringe Diameter (mm)"),self.diameterLineEdit_pump1)
        fbox_1step_pump1.addRow(QLabel("Volume"),self.volumeLineEdit_pump1)
        fbox_1step_pump1.addRow(QLabel("Flow Rate"),self.flowRateLineEdit_pump1)
        fbox_1step_pump1.addRow(QLabel("Delay (sec)"),self.delayLineEdit_pump1)
        # pump 2
        fbox_1step_pump2 = QFormLayout()
        fbox_1step_pump2.addRow(QLabel("Pump 2"))
        fbox_1step_pump2.addRow(QLabel("Units"),self.unitsCBox_pump2)
        fbox_1step_pump2.addRow(QLabel("Syringe Diameter (mm)"),self.diameterLineEdit_pump2)
        fbox_1step_pump2.addRow(QLabel("Volume"),self.volumeLineEdit_pump2)
        fbox_1step_pump2.addRow(QLabel("Flow Rate"),self.flowRateLineEdit_pump2)
        fbox_1step_pump2.addRow(QLabel("Delay (sec)"),self.delayLineEdit_pump2)
        # append both to layout
        fbox_1step.addLayout(fbox_1step_pump1)
        fbox_1step.addLayout(fbox_1step_pump2)
        
        # Multi-Step Run Widget
        fbox_mstep = QHBoxLayout()
        # pump1
        fbox_mstep_pump1 = QFormLayout()
        fbox_mstep_pump1.addRow(QLabel("Pump 1"))
        fbox_mstep_pump1.addRow(QLabel("Units"),self.multi_unitsCBox_pump1)
        fbox_mstep_pump1.addRow(QLabel("Syringe Diameter (mm)"),self.multi_diameterLineEdit_pump1)
        fbox_mstep_pump1.addRow(QLabel("Volume"),self.multi_volumeLineEdit_pump1)
        fbox_mstep_pump1.addRow(QLabel("Flow Rate"),self.multi_flowRateLineEdit_pump1)
        fbox_mstep_pump1.addRow(QLabel("Delay (sec)"),self.multi_delayLineEdit_pump1)
        # pump2
        fbox_mstep_pump2 = QFormLayout()
        fbox_mstep_pump2.addRow(QLabel("Pump 2"))
        fbox_mstep_pump2.addRow(QLabel("Units"),self.multi_unitsCBox_pump2)
        fbox_mstep_pump2.addRow(QLabel("Syringe Diameter (mm)"),self.multi_diameterLineEdit_pump2)
        fbox_mstep_pump2.addRow(QLabel("Volume"),self.multi_volumeLineEdit_pump2)
        fbox_mstep_pump2.addRow(QLabel("Flow Rate"),self.multi_flowRateLineEdit_pump2)
        fbox_mstep_pump2.addRow(QLabel("Delay (sec)"),self.multi_delayLineEdit_pump2)
        # append both to layout
        fbox_mstep.addLayout(fbox_mstep_pump1)
        fbox_mstep.addLayout(fbox_mstep_pump2)
        
        # Cycle Mode Run Widget
        fbox_cycle = QFormLayout()
        fbox_cycle.addRow(QLabel("Units"),self.cycle_unitsCBox)
        fbox_cycle.addRow(QLabel("Syringe Diameter (mm)"),self.cycle_diameterLineEdit)
        fbox_cycle.addRow(QLabel("Volume"),self.cycle_volumeLineEdit)
        fbox_cycle.addRow(QLabel("Flow Rate"),self.cycle_flowRateLineEdit)
        fbox_cycle.addRow(QLabel("Delay (sec)"),self.cycle_delayLineEdit)
        
        # Run Control Widget
        runctrlbox = QHBoxLayout()
        runctrlbox_start = QVBoxLayout()
        runctrlbox_start.addWidget(self.startBtn)
        runctrlbox_start.addWidget(self.startBtn_pump1)
        runctrlbox_start.addWidget(self.startBtn_pump2)
        runctrlbox.addLayout(runctrlbox_start)
        runctrlbox.addWidget(self.pauseBtn)
        runctrlbox.addWidget(self.stopBtn)
        
        # creating a main vertical box layout and adding sub-layouts
        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.logoGroupBox)
        mainLayout.addWidget(self.connGroupBox)
        mainLayout.addWidget(self.tabs)
        mainLayout.addWidget(self.buttGroupBox)
        
        # Set as layouts of group boxes to defined sub-layouts
        self.logoGroupBox.setLayout(logobox)
        self.connGroupBox.setLayout(connbox)
        self.tab1.setLayout(fbox_1step)
        self.tab2.setLayout(fbox_mstep)
        self.tab3.setLayout(fbox_cycle)
        self.buttGroupBox.setLayout(runctrlbox)
        
        # setting layout of main window
        self.setLayout(mainLayout)
        self.show()
                
    def sendFromGUI(self, pump):
        """
        Send run variable info to pump using information from each of the respective widgets.
        If any are empty throw an error.
        Parameters
        ----------
        pump : int [1,2]
            Pump that commands are sent to.
        """
        # specify which pump commands are sent to
        self.CONNECTION.changePump(pump)
        # Each of these setup variables need to be changed if order is modified in any way
        names=['Units','Syringe Diameter', 'Volume', 'Flow Rate', 'Delay']
        # setup widget references
        widgets_pump1=[self.unitsCBox_pump1,self.diameterLineEdit_pump1,self.volumeLineEdit_pump1,self.flowRateLineEdit_pump1,self.delayLineEdit_pump1]
        widgets_pump2=[self.unitsCBox_pump2,self.diameterLineEdit_pump2,self.volumeLineEdit_pump2,self.flowRateLineEdit_pump2,self.delayLineEdit_pump2]
        # reference widgets for designated pump
        widgets=[widgets_pump1,widgets_pump2][pump-1]
        funcref=[self.CONNECTION.setUnits,self.CONNECTION.setDiameter,self.CONNECTION.setVolume,self.CONNECTION.setRate,self.CONNECTION.setDelay]
        values=[]
        
        # loop through each widget and pull values, then send values using specified function
        for ii in range(len(widgets)):
            func=funcref[ii]
            widg=widgets[ii]
            # different value extraction methods depending on widget
            if widg.__class__.__name__=='QLineEdit':
                if widg.text()!='':
                    value=widg.text()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            elif widg.__class__.__name__=='QComboBox':
                if widg.currentText()!='':
                    value=widg.currentText()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            else: 
                logger.warning('Unrecognized widget class.')
            # Send to pump
            func(value)
            values.append(value)
        """
        Validate that value is inside of operational range.
        Reads parameters from pump and compares to what was sent from GUI.
        Throws error if mismatch.
        """
        # index of relevant variable to readout from pump
        map_readparam_pump1 = [2,3,6,4,7]
        map_readparam_pump2 = [9,10,13,11,14]
        # reference parameters for designated pump
        map_readparam = [map_readparam_pump1,map_readparam_pump2][pump-1]
        # get parameters of current pump run
        readout=self.CONNECTION.getParameters()
        # map readout to params
        params=[readout[x].strip(' ').split(' ')[-1] for x in map_readparam]
        # skip units param, fixed options in GUI are within operational range
        for ii in range(1,len(values)): 
            # get parameter value from pump readout
            paramVal = params[ii]
            # abs() accounts for negative volume metric (withdraw functionality)
            if not float(paramVal)==abs(float(values[ii])):
                raise Exception(f'ERROR: Pump {pump} {names[ii]} value outside of operational range')
    
    def sendFromGUI_multi(self,pump):
        """
        Send run variable info to pump using information from each of the respective widgets.
        If any are empty throw an error.
        For multi-step we skip validation
        """
        # specify which pump commands are sent to
        self.CONNECTION.changePump(pump)
        # Each of these setup variables need to be changed if order is modified in any way
        names=['Units','Syringe Diameter', 'Volume', 'Flow Rate', 'Delay']
        # setup widget references
        widgets_pump1=[self.multi_unitsCBox_pump1,self.multi_diameterLineEdit_pump1,self.multi_volumeLineEdit_pump1,self.multi_flowRateLineEdit_pump1,self.multi_delayLineEdit_pump1]
        widgets_pump2=[self.multi_unitsCBox_pump2,self.multi_diameterLineEdit_pump2,self.multi_volumeLineEdit_pump2,self.multi_flowRateLineEdit_pump2,self.multi_delayLineEdit_pump2]
        # reference widgets for designated pump
        widgets=[widgets_pump1,widgets_pump2][pump-1]
        # function references
        funcref=[self.CONNECTION.setUnits,self.CONNECTION.setDiameter,self.CONNECTION.setVolume,self.CONNECTION.setRate,self.CONNECTION.setDelay]
        values=[]
        nsteps=0
        # loop through each widget and pull values, then send values using specified function
        for ii in range(len(widgets)):
            func=funcref[ii]
            widg=widgets[ii]
            # different value extraction methods depending on widget
            if widg.__class__.__name__=='QLineEdit':
                if widg.text()!='':
                    value=widg.text()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            elif widg.__class__.__name__=='QComboBox':
                if widg.currentText()!='':
                    value=widg.currentText()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            else: 
                logger.warning('Unrecognized widget class.')
            
            # process entry data into list
            if ii>1: 
                # skip units and diameter, these are immutable between steps
                value=[v.strip() for v in value.split(',')]
                # initialize nsteps at first multi-step parameter
                nsteps=len(value) if nsteps==0 else nsteps
                # ensure list length matches number of steps
                if len(value)!=nsteps:
                    raise Exception('ERROR: Number of steps must match number of input variables. \n Pump {pump} {names[ii]}')
            # Send to pump
            func(value)
            values.append(value)
        
    def sendFromGUI_cycle(self):
        """
        Send run variable info to pump using information from each of the respective widgets.
        If any are empty throw an error.
        """
        # specify which pump commands are sent to
        self.CONNECTION.changePump(3)
        # Each of these setup variables need to be changed if order is modified in any way
        names=['Units','Syringe Diameter', 'Volume', 'Flow Rate', 'Delay']
        # setup widget references
        widgets=[self.cycle_unitsCBox,self.cycle_diameterLineEdit,self.cycle_volumeLineEdit,self.cycle_flowRateLineEdit,self.cycle_delayLineEdit]
        # function references
        funcref=[self.CONNECTION.setUnits,self.CONNECTION.setDiameter,self.CONNECTION.setVolume,self.CONNECTION.setRate,self.CONNECTION.setDelay]
        values=[]
        # loop through each widget and pull values, then send values using specified function
        for ii in range(len(widgets)):
            func=funcref[ii]
            widg=widgets[ii]
            # different value extraction methods depending on widget
            if widg.__class__.__name__=='QLineEdit':
                if widg.text()!='':
                    value=widg.text()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            elif widg.__class__.__name__=='QComboBox':
                if widg.currentText()!='':
                    value=widg.currentText()
                else:
                    raise Exception('ERROR: Must enter all pump variables before starting run.')
            else: 
                logger.warning('Unrecognized widget class.')
            # Send to pump
            func(value)
            values.append(value)
                
    def start(self):
        """
        Start the current run. Sends updated pump variables before starting run. 
        """
        if self.connected:
            if self.tabs.currentIndex()==0: # single-step
                logger.info('Sending Single-Step Variables from GUI')
                self.sendFromGUI(pump=1)
                self.sendFromGUI(pump=2)
                self.CONNECTION.startPump()
            elif self.tabs.currentIndex()==1: # multi-step
                logger.info('Sending Multi-Step Variables from GUI')
                self.sendFromGUI_multi(pump=1)
                self.sendFromGUI_multi(pump=2)
                self.CONNECTION.startPump(multistep=True)
            else: # cycle mode
                logger.info('Sending Cycle Mode Variables from GUI')
                self.sendFromGUI_cycle()
                self.CONNECTION.startPump(mode=3)
            self.isRunning=True
            self.setPauseBtn(True)
            logger.info('Started Run - Both Pumps')
            
    def start_pump(self, pump):
        """
        Start the current run just for pump specified. Sends updated pump variables before starting run. 
        Parameters
        ----------
        pump : int [1,2]
            Pump that commands are sent to.
        """
        if self.connected:
            if self.tabs.currentIndex()==0: # single-step
                logger.info(f'Sending Single-Step Variables from GUI to Pump {pump}')
                self.sendFromGUI(pump=pump)
                self.CONNECTION.startPump(mode=pump)
            elif self.tabs.currentIndex()==1: # multi-step
                logger.info(f'Sending Multi-Step Variables from GUI to Pump {pump}')
                self.sendFromGUI_multi(pump=pump)
                self.CONNECTION.startPump(mode=pump,multistep=True) # will this work?
            else: # cycle mode
                logger.warning('Cycle mode starts both pumps.')
                logger.info('Sending Cycle Mode Variables from GUI')
                self.sendFromGUI_cycle()
                self.CONNECTION.startPump(mode=3)
            self.isRunning=True
            self.setPauseBtn(True)
            logger.info(f'Started Run - Pump {pump}')
            
    def stop(self):
        """
        Stops the current run.
        """
        if self.connected:
            self.CONNECTION.stopPump()
            self.isRunning=False
            self.setPauseBtn(True)
            logger.info('Stopped Run')

    def pause(self):
        """
        Pause/Unpause the current run. Updates button to correct display.
        """
        if self.connected:
            if self.isRunning:
                self.CONNECTION.pausePump(mode=1)
                self.CONNECTION.pausePump(mode=2)
                self.setPauseBtn(False)
                logger.info('Paused Run')
                
    def setPauseBtn(self,val):
        """
        Change display of pause/unpause button depending on if progrma is running
        TRUE = Pause, FALSE=Unpause
        """
        self.pauseBtn.setText(['Unpause','Pause'][val])
            
    def connect(self):
        """
        Connects to pump and updates associated info display.
        """
        if not self.connected and self.serportCBox.currentText()!='':
            com = str(self.serportCBox.currentText())
            baud = str(self.baudCBox.currentText())
            try:
                # establish connection to pump
                self.CONNECTION.baudrate = baud
                self.CONNECTION.port = com
                self.CONNECTION.openConnection()
                # modify display info
                self.connectLbl.setText("CONNECTED")
                self.connectLbl.setStyleSheet("color:green")
                self.connectBtn.setText("Disconnect")
                # Lock connection parameters
                self.serportCBox.setEnabled(False)
                self.scanBtn.setEnabled(False)
                self.baudCBox.setEnabled(False)
                # update connection status
                self.connected = True
                logger.info('Connected to pump')
            except TypeError as e:
                print(e)
        else:
            try:
                # close connection to pump
                self.CONNECTION.closeConnection()
            except:
                pass # bad practice, avert your eyes!
            # modify display info
            self.connectLbl.setText("DISCONNECTED")
            self.connectLbl.setStyleSheet("color:red")
            self.connectBtn.setText("Connect")
            # unlock connection parameters
            self.serportCBox.setEnabled(True)
            self.scanBtn.setEnabled(True)
            self.baudCBox.setEnabled(True)
            # update connection status
            self.connected = False
            logger.info('Disconnected from pump')
    
    def scanPorts(self):
        """
        Scans for ports and updates ports combobox
        """
        logger.info('Scanning for Open Serial Ports')
        portinfo = connect.getOpenPorts()
        portlist = portinfo
        self.serportCBox.clear()
        self.serportCBox.addItems(portlist)
        
    def closeEvent(self,event):
        """
        Called when closing out of window. 
        Closes connection to pump.
        """
        logger.info('Disconnecting Pump and Closing Application')
        self.CONNECTION.closeConnection()
        event.accept()
        
#%% Main
if __name__ == '__main__':
    app = QApplication(sys.argv)

    app.setStyleSheet
    ex = ChemyxPumpGUI()
    ex.show()
    sys.exit(app.exec())