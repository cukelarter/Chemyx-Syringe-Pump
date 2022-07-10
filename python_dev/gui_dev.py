# -*- coding: utf-8 -*-
"""
Created on Sun Jul  3 16:31:35 2022

@author: Luke
"""

from PyQt5.QtWidgets import QMainWindow, QApplication, QWidget, QPushButton, QAction, QLineEdit, QMessageBox, QGridLayout, QLabel, QFormLayout
from PyQt5.QtGui import QIntValidator
import PyQt5.QtCore as QtC

import sys
from core import connect

#%% Testing
class ChemyxPumpGUI(QMainWindow):

    def __init__(self, parent=None):
        super().__init__(parent)
        # GUI Formatting
        self.title = 'Chemyx Pump Connector'
        self.left = 100
        self.top = 100
        self.width = 350
        self.height = 400
        
        self.initPumpVar()
        self.initUI()
    def initPumpVar(self):
        # set default Syringe Pump Variables
        self.units='mL/min'     # OPTIONS: 'mL/min','mL/hr','μL/min','μL/hr'
        self.diameter=28.6      # 28.6mm diameter - can be set in pump GUI
        self.volume=1                # 1 mL volume
        self.rate=1                  # 1 mL/min flow rate
        self.runtime=self.volume/self.rate     # this is calculated implictly by pump
        self.delay=0.5               # 30 second delay
        
    def initUI(self):
        self.setWindowTitle(self.title)
        self.setGeometry(self.left, self.top, self.width, self.height)

        # Rate
        self.RateLabel=QLabel("Flow Rate")   
        #self.RateLabel.setText('Flow Rate')
        self.RateWidget=QLineEdit()
        #self.RateWidget.move(30, 30)
        #self.onlyInt = QIntValidator()      # only allow INT input
        #self.RateWidget.setValidator(self.onlyInt)
        
        fbox = QFormLayout()
        fbox.addRow(self.RateLabel,self.RateWidget)
        
        # Add to layout
        self.setLayout(fbox)
        self.show()


#%% Main
if __name__ == '__main__':
    app = QApplication(sys.argv)
    ex = ChemyxPumpGUI()
    ex.show()
    sys.exit(app.exec_())