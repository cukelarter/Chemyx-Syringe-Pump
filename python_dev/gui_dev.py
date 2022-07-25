# -*- coding: utf-8 -*-
"""
Created on Sun Jul  3 16:31:35 2022

@author: cukelarter
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
        self.setGeometry(100, 100, 350, 400)
        # restrict to unmodifiable dimensions
        #self.setFixedWidth(600)
        #self.setFixedHeight(400)
        
        # creating group boxes
        self.logoGroupBox = QGroupBox()
        self.connGroupBox = QGroupBox("Connection Variables")
        self.formGroupBox = QGroupBox("Single-Step Pump Variables")
        self.buttGroupBox = QGroupBox('Run Controls')
        
        # initialize variable to tell if the pump is running
        # used exclusively by start/pause&unpause/stop functions
        self.isRunning=False

        # initialize pump variables and widgets
        self.initPumpVar()
        self.initUI()
        
        # initialize connection controller
        self.CONNECTION = connect.Connection(port=str(self.serportCBox.currentText()),baudrate=self.baudCBox.currentText())
        self.connected=False
        
    def initPumpVar(self):
        # set default Syringe Pump Variables
        self.units='mL/min'     # OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
        self.unitlist=['mL/min','mL/hr',"\u03BCL/min",'\u03BCL/hr']
        [self.volunit,self.timeunit]=self.units.split('/')
        
        # these don't actually do anything - all updates occur in one step
        # !! maybe these shouldn't be set? food for thought
        #self.diameter=28.6      # 28.6mm diameter - can be set in pump GUI
        #self.volume=1                # 1 mL volume
        #self.flowrate=1                  # 1 mL/min flow rate
        #self.runtime=self.volume/self.flowrate     # this is calculated implictly by pump
        #self.delay=0.5               # 30 second delay
        
    def initUI(self):
        # Logo Graphics
        logopath='static/logo.png'
        self.logo = QPixmap(logopath)
        self.logoImage=QLabel()
        self.logoImage.setPixmap(self.logo)
        self.logoImage.setAlignment(Qt.AlignCenter)
        
        # Connection Setup
        portinfo = connect.getOpenPorts()
        portlist = portinfo
        self.serportCBox = QComboBox(width=115)
        self.serportCBox.addItems(portlist)
        self.baudCBox = QComboBox(width=85)
        self.baudCBox.addItems(['9600','38400'])
        self.connectLbl = QLabel('DISCONNECTED')
        self.connectLbl.setStyleSheet("color:red")
        self.connectBtn = QPushButton('Connect')
        self.connectBtn.clicked.connect(lambda:self.connect())

        # Pump Variable Fields
        self.unitsCBox = QComboBox()
        self.unitsCBox.addItems(self.unitlist)
        self.diameterLineEdit=QLineEdit()
        self.diameterLineEdit.setValidator(QDoubleValidator(bottom=0))
        self.volumeLineEdit=QLineEdit()
        self.volumeLineEdit.setValidator(QDoubleValidator(bottom=0))    
        self.flowRateLineEdit=QLineEdit()
        self.flowRateLineEdit.setValidator(QDoubleValidator(bottom=0))
        self.delayLineEdit=QLineEdit()
        self.delayLineEdit.setValidator(QDoubleValidator(bottom=0))
        
        # Button Controls
        # start/pause&unpause/stop
        self.stopBtn = QPushButton('Stop')
        self.stopBtn.clicked.connect(lambda:self.stop())
        self.pauseBtn = QPushButton('Pause')
        self.pauseBtn.clicked.connect(lambda:self.pause())
        self.startBtn = QPushButton('Start')
        self.startBtn.clicked.connect(lambda:self.start())
        # scan button
        self.scanBtn = QPushButton('Scan For Open Ports')
        self.scanBtn.clicked.connect(lambda:self.scanPorts())
        
        # Initialize Widgets to Sub-Layouts
        logobox=QVBoxLayout()
        logobox.addWidget(self.logoImage)
        
        connbox=QFormLayout()
        scanbox=QHBoxLayout()   # sublayout for scan button and port selection
        scanbox.addWidget(self.serportCBox)
        scanbox.addWidget(self.scanBtn)
        connbox.addRow(QLabel('Serial Port'),scanbox)
        connbox.addRow(QLabel('Baud Rate'),self.baudCBox)
        connbox.addRow(self.connectLbl,self.connectBtn)
        
        fbox = QFormLayout()
        fbox.addRow(QLabel("Units"),self.unitsCBox)
        fbox.addRow(QLabel("Syringe Diameter (mm)"),self.diameterLineEdit)
        fbox.addRow(QLabel("Volume"),self.volumeLineEdit)
        fbox.addRow(QLabel("Flow Rate"),self.flowRateLineEdit)
        fbox.addRow(QLabel("Delay (mins)"),self.delayLineEdit)
        
        runctrlbox = QHBoxLayout()
        runctrlbox.addWidget(self.startBtn)
        runctrlbox.addWidget(self.pauseBtn)
        runctrlbox.addWidget(self.stopBtn)
        
        # creating a vertical box layout and adding sub-layouts
        mainLayout = QVBoxLayout()
        mainLayout.addWidget(self.logoGroupBox)
        mainLayout.addWidget(self.connGroupBox)
        mainLayout.addWidget(self.formGroupBox)
        mainLayout.addWidget(self.buttGroupBox)
        
        # Set as layouts of group boxes to defined sub-layouts
        self.logoGroupBox.setLayout(logobox)
        self.connGroupBox.setLayout(connbox)
        self.formGroupBox.setLayout(fbox)
        self.buttGroupBox.setLayout(runctrlbox)
        
        # setting layout of main window
        self.setLayout(mainLayout)
        self.show()
                
    def sendFromGUI(self):
        """
        Send run variable info to pump using information from each of the respective widgets.
        If any are empty throw an error.
        Consider not throwing error for certain ones.
        """
        widgets=[self.unitsCBox,self.diameterLineEdit,self.volumeLineEdit,self.flowRateLineEdit,self.delayLineEdit]
        funcref=[self.CONNECTION.setUnits,self.CONNECTION.setDiameter,self.CONNECTION.setVolume,self.CONNECTION.setRate,self.CONNECTION.setDelay]
        for ii in range(len(widgets)):
            func=funcref[ii]
            widg=widgets[ii]
            if widg.__class__.__name__=='QLineEdit':
                assert(widg.text()!=''),'ERROR: Must enter all pump variables before starting run.'
                func(widg.text())
            elif widg.__class__.__name__=='QComboBox':
                assert(widg.currentText()!=''),'ERROR: Must enter all pump variables before starting run.'
                func(widg.currentText())
            else: 
                logger.warning('Unrecognized widget class.')
                
    def start(self):
        """
        Start the current run. Sends updated pump variables before starting run. 
        """
        if self.connected:
            logger.info('Sending Pump Variables from GUI')
            self.sendFromGUI()
            self.CONNECTION.startPump()
            self.isRunning=True
            self.setPauseBtn(True)
            logger.info('Started Run')

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
                self.CONNECTION.pausePump()
                #self.isRunning=False
                self.setPauseBtn(False)
                logger.info('Paused Run')
            else:
                self.CONNECTION.startPump()
                #self.pauseBtn.setText('Pause')
                #self.isRunning=True
                self.setPauseBtn(True)
                logger.info('Unpaused Run')
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