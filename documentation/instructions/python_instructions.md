**CHEMYX Syringe Pump Python GUI Instructions**

To send commands to your CHEMYX syringe pump using a python-integrated GUI, follow these steps.

**Installation and Setup**
	1. **Basic Installation**
		1. Download latest Python3 version from https://www.python.org/downloads.
		2. Open downloaded file and follow prompts to install Python.
	2. **Ensure that necessary packages are installed in your Python environment.**
		1. Open Command Prompt (Windows) or Terminal Application (Mac)
		2. serial - "python -m pip install serial" (required for serial connection)
		2. PyQT5 - "python -m pip install PyQT5" (required for GUI interfacing)

**Create Run using Python Script**
	1. Example scripts are provided and can be modified to match study design parameters.
		+ singlestep.py				Single step run on single-channel pumps
		+ multistep.py	 			Multi step run on single-channel pumps
		+ 2channel_singlestep.py	Single step run on dual-channel pumps
		+ 2channel_multistep.py		Multi step run on dual-channel pumps
		+ 2channel_cycle.py			Cycle mode run on dual-channel pumps
	2. Baud rate in script **MUST** match value of the syringe pump, which can be found and changed in “System Settings”
	3. After running the script, serial connection will remain open until disconnected.
		1. Call “conn.closeConnection()” to close connection to pump.
		2. Alternatively, unplugging Syringe Pump from USB port will close the connection.

**Using the Python GUI**
	GUI can be started by opening relevant GUI.py file.
	1. **Connect to pump**
		1. When starting GUI, serial port dropdown will auto-populate with any open serial ports. Press "Scan for Open Ports" to rescan and repopulate dropdown.
		2. Set the Baud Rate using dropdown. This rate **MUST** match the rate set on the pump (System Settings).
		3. Press "Connect" to connect to pump using defined settings. If successful, the "DISCONNECTED" text will change to say "CONNECTED" and the connection variables will be locked until disconnected from the pump.
	2. **Set Run Variables**
		1. Set each pump variable according to specifications of the run.
		2. Run variables are not sent to pump until user hits "Start" in run controls.
		3. Set Single-Step Pump Variables
		4. Set Multi-Step Pump Variables
			1. Only one diameter must be entered, and this is immutable between steps.
			2. Enter each variable into relevant cell, with commas separating step values.
			3. Ex: **Volume: 10,-3,5** -> Volumes **Step1: 10** , **Step2: -3** , **Step3:5**
			4. For variable flow rates, use slash between rates within a step:
			5. Ex: **Flow Rate: 10/15, 5/10** -> Rates **Step1: 10-15** , **Step2: 5-10**
		5. Set Cycle Mode Variables
	3. **Send Run Variables to Pump**
	4. **Start run and user control**
		1. Press "Start" to begin run with defined pump variables.
			1. An error will be thrown if any specific variables are outside the pump's operational range.
		2. Press "Pause" to temporarily pause run. Press "Unpause" to continue run.
		3. Press "Stop" to halt the current run.
	5. **Disconnect from Pump**
		1. Press "Disconnect" in Connection Variables section to disconnect from pump.
		2. Alternatively, closing the GUI will close the connection to the pump.