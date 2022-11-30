**CHEMYX Syringe Pump Python GUI Instructions**

To send commands to your CHEMYX syringe pump using a python-integrated GUI, follow these steps.

**Installation and Setup**
	1. **Basic Installation**
		1. Download latest Python3 version from https://www.python.org/downloads.
		2. Open downloaded file and follow prompts to install Python.
	2. **Ensure that necessary packages are installed in your Python environment.**
		1. Open Command Prompt (Windows) or Terminal Application (Mac)
		2. PyQT5 - "python -m pip install PyQT5"
		3. serial - "python -m pip install serial"

**Using the Python GUI**
	1. **Connect to pump**
		1. When starting GUI, serial port dropdown will auto-populate with any open serial ports. Press "Scan for Open Ports" to rescan and repopulate dropdown.
		2. Set the Baud Rate using dropdown. This rate **MUST** match the rate set on the pump (System Settings).
		3. Press "Connect" to connect to pump using defined settings. If successful, the "DISCONNECTED" text will change to say "CONNECTED" and the connection variables will be locked until disconnected from the pump.
	2. **Set Run Variables**
		1. Set each pump variable according to specifications of the run.
		2. _Run variables are not sent to pump until user hits "Start" in run controls._
		3. Set Single-Step Pump Variables
		4. Set Multi-Step Pump Variables
			1. Only one diameter must be entered, and this is immutable between steps.
			2. Enter each variable into relevant cell, with commas separating step values.
			3. Ex: **Volume: 10,-3,5** -\> Volumes **Step1: 10** , **Step2: -3** , **Step3:5**
			4. For variable flow rates, use slash between rates within a step:
			5. Ex: **Flow Rate: 10/15, 5/10** -\> Rates **Step1: 10-15** , **Step2: 5-10**
		5. Set Cycle Mode Variables
	3. **Send Run Variables to Pump**
	4. **Start run and user control**
		1. Press "Start" to begin run with defined pump variables.
			1. _An error will be thrown if any specific variables are outside the pump's operational range._
		2. Press "Pause" to temporarily pause run. Press "Unpause" to continue run.
		3. Press "Stop" to halt the current run.
	5. **Disconnect from Pump**
	  1. Press "Disconnect" in Connection Variables section to disconnect from pump.
	  2. Alternatively, closing the GUI will close the connection to the pump.