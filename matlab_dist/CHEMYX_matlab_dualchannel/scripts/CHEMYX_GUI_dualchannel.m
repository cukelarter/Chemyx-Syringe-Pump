classdef CHEMYX_GUI_dualchannel < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        Image                       matlab.ui.control.Image
        ConnectionVariablesPanel    matlab.ui.container.Panel
        SerialPortDropDownLabel     matlab.ui.control.Label
        SerialPortDropDown          matlab.ui.control.DropDown
        ScanButton                  matlab.ui.control.Button
        BaudRateDropDownLabel       matlab.ui.control.Label
        BaudRateDropDown            matlab.ui.control.DropDown
        StatusLampLabel             matlab.ui.control.Label
        StatusLamp                  matlab.ui.control.Lamp
        ConnectButton               matlab.ui.control.Button
        RunControlsPanel            matlab.ui.container.Panel
        StartButton                 matlab.ui.control.Button
        PauseButton                 matlab.ui.control.Button
        StopButton                  matlab.ui.control.Button
        TabGroup                    matlab.ui.container.TabGroup
        SingleStepTab               matlab.ui.container.Tab
        DelayEditField_3Label       matlab.ui.control.Label
        DelayEditField              matlab.ui.control.NumericEditField
        delayLabel                  matlab.ui.control.Label
        RateEditField_3Label        matlab.ui.control.Label
        RateEditField               matlab.ui.control.NumericEditField
        rateLabel                   matlab.ui.control.Label
        volLabel                    matlab.ui.control.Label
        VolumeEditField_3Label      matlab.ui.control.Label
        VolumeEditField             matlab.ui.control.NumericEditField
        DiameterEditField_5Label    matlab.ui.control.Label
        DiameterEditField           matlab.ui.control.NumericEditField
        UnitsDropDown_5Label        matlab.ui.control.Label
        UnitsDropDown               matlab.ui.control.DropDown
        mmLabel                     matlab.ui.control.Label
        delayLabel_3                matlab.ui.control.Label
        rateLabel_3                 matlab.ui.control.Label
        volLabel_3                  matlab.ui.control.Label
        mmLabel_2                   matlab.ui.control.Label
        UnitsDropDown_3Label        matlab.ui.control.Label
        UnitsDropDown_3             matlab.ui.control.DropDown
        DelayEditField_3Label_2     matlab.ui.control.Label
        DelayEditField_3            matlab.ui.control.NumericEditField
        RateEditField_3Label_2      matlab.ui.control.Label
        RateEditField_3             matlab.ui.control.NumericEditField
        VolumeEditField_3Label_2    matlab.ui.control.Label
        VolumeEditField_3           matlab.ui.control.NumericEditField
        DiameterEditField_3Label    matlab.ui.control.Label
        DiameterEditField_3         matlab.ui.control.NumericEditField
        Pump1Label                  matlab.ui.control.Label
        Pump2Label                  matlab.ui.control.Label
        MultiStepTab                matlab.ui.container.Tab
        DiameterEditField_4Label    matlab.ui.control.Label
        DiameterEditField_2         matlab.ui.control.NumericEditField
        UnitsDropDown_4Label        matlab.ui.control.Label
        UnitsDropDown_2             matlab.ui.control.DropDown
        RateEditField_4Label        matlab.ui.control.Label
        RateEditField_2             matlab.ui.control.EditField
        VolumeEditField_4Label      matlab.ui.control.Label
        VolumeEditField_2           matlab.ui.control.EditField
        volLabel_2                  matlab.ui.control.Label
        rateLabel_2                 matlab.ui.control.Label
        delayLabel_2                matlab.ui.control.Label
        DelayEditField_4Label       matlab.ui.control.Label
        DelayEditField_2            matlab.ui.control.EditField
        volLabel_4                  matlab.ui.control.Label
        rateLabel_4                 matlab.ui.control.Label
        delayLabel_4                matlab.ui.control.Label
        UnitsDropDown_4Label_2      matlab.ui.control.Label
        UnitsDropDown_4             matlab.ui.control.DropDown
        DiameterEditField_4Label_2  matlab.ui.control.Label
        DiameterEditField_4         matlab.ui.control.NumericEditField
        RateEditField_4Label_2      matlab.ui.control.Label
        RateEditField_4             matlab.ui.control.EditField
        DelayEditField_4Label_2     matlab.ui.control.Label
        DelayEditField_4            matlab.ui.control.EditField
        VolumeEditField_4Label_2    matlab.ui.control.Label
        VolumeEditField_4           matlab.ui.control.EditField
        mmLabel_4                   matlab.ui.control.Label
        mmLabel_5                   matlab.ui.control.Label
        Pump1Label_2                matlab.ui.control.Label
        Pump2Label_2                matlab.ui.control.Label
        CycleModeTab                matlab.ui.container.Tab
        delayLabel_5                matlab.ui.control.Label
        rateLabel_5                 matlab.ui.control.Label
        volLabel_5                  matlab.ui.control.Label
        mmLabel_3                   matlab.ui.control.Label
        DelayEditField_5Label       matlab.ui.control.Label
        DelayEditField_5            matlab.ui.control.NumericEditField
        RateEditField_5Label        matlab.ui.control.Label
        RateEditField_5             matlab.ui.control.NumericEditField
        VolumeEditField_5Label      matlab.ui.control.Label
        VolumeEditField_5           matlab.ui.control.NumericEditField
        DiameterEditField_5Label_2  matlab.ui.control.Label
        DiameterEditField_5         matlab.ui.control.NumericEditField
        UnitsDropDown_5Label_2      matlab.ui.control.Label
        UnitsDropDown_5             matlab.ui.control.DropDown
    end

    
    properties (Access = private)
        CONNECTION = connection; % Chemyx syringe pump
        connected = false;% track connection status
    end
  
    methods (Access = private)
        function app = sendUnitsFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setUnits(value);
        end
        function app = sendDiameterFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setDiameter(value);
        end
        function app = sendVolumeFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setVolume(value);
        end
        function app = sendRateFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setRate(value);
        end
        function app = sendDelayFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setDelay(value);
        end
        function app = mstep_sendUnitsFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setUnits(value);
        end
        function app = mstep_sendDiameterFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            app.CONNECTION.setDiameter(value);
        end
        function app = mstep_sendVolumeFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            % need to reformat to enter valid command
            value=split(value,",");
            app.CONNECTION.setVolume(value);
        end
        function app = mstep_sendRateFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            % need to reformat to enter valid command
            value=split(value,",");
            app.CONNECTION.setRate(value);
        end
        function app = mstep_sendDelayFromGUI(app,value,pump)
            if app.CONNECTION.currentpump~=pump
                app.CONNECTION.setPump(pump)
            end
            % need to reformat to enter valid command
            value=split(value,",");
            app.CONNECTION.setDelay(value);
        end
    end

    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: ScanButton
        function ScanPorts(app, event)
            % retreive open ports
            ports=getAvailableComPort();
            % populate dropdown
            app.SerialPortDropDown.Items=ports;
        end

        % Button pushed function: ConnectButton
        function ChangeConnection(app, event)
            if app.connected
                % Disconnect by resetting connection class - not necessary
                % openConnection being called again will overwrite
                % basically just locks some variables 
                app.CONNECTION.closeConnection();
                % change GUI display
                app.StatusLamp.Color=[1.00,0.00,0.00]; % set status to red
                app.ConnectButton.Text='Connect';
                app.connected=false;
                % enable connection fields
                app.SerialPortDropDown.Enable=1;
                app.ScanButton.Enable=1;
                app.BaudRateDropDown.Enable=1;
                % disable run controls
                app.StartButton.Enable=0;
                app.PauseButton.Enable=0;
                app.StopButton.Enable=0;
            else
                % Attempt to connect
                port = app.SerialPortDropDown.Value;
                baudrate=str2num(app.BaudRateDropDown.Value);
                try
                    app.CONNECTION.openConnection(port,baudrate,'multipump',true);
                    % if successful, change GUI display
                    app.StatusLamp.Color=[0.00,1.00,0.00]; % set status to green
                    app.ConnectButton.Text='Disconnect';
                    app.connected=true;
                    % disable connection fields
                    app.SerialPortDropDown.Enable=0;
                    app.ScanButton.Enable=0;
                    app.BaudRateDropDown.Enable=0;
                    % enable run controls
                    app.StartButton.Enable=1;
                    app.PauseButton.Enable=1;
                    app.StopButton.Enable=1;
                catch ME
                    warning('Failed to connect to pump.')
                    rethrow(ME)
                end
            end
        end

        % Value changed function: UnitsDropDown
        function p1_sstep_UnitsDropDownValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI(app.UnitsDropDown.Value,1);
            end
            units=app.UnitsDropDown.Value;
            app.volLabel.Text=units(1:2);
            app.rateLabel.Text=units(4:end);
            app.delayLabel.Text=units(4:end);
        end

        % Value changed function: DiameterEditField
        function p1_sstep_DiameterEditFieldValueChanged(app, event)
            if app.connected
                app.sendDiameterFromGUI(app.DiameterEditField.Value,1);
            end
        end

        % Value changed function: VolumeEditField
        function p1_sstep_VolumeEditFieldValueChanged(app, event)
            if app.connected
                app.sendVolumeFromGUI(app.VolumeEditField.Value,1);
            end
        end

        % Value changed function: RateEditField
        function p1_sstep_RateEditFieldValueChanged(app, event)
            if app.connected
                app.sendRateFromGUI(app.RateEditField.Value,1);
            end
        end

        % Value changed function: DelayEditField
        function p1_sstep_DelayEditFieldValueChanged(app, event)
            if app.connected
                app.sendDelayFromGUI(app.DelayEditField.Value,1);
            end
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            if app.connected
                % resend pump variables
                if app.TabGroup.SelectedTab==app.SingleStepTab
                    % start pump in single step mode
                    app.CONNECTION.startPump();
                    % update pause button label
                    app.PauseButton.Text='Pause';
                    
                elseif app.TabGroup.SelectedTab==app.MultiStepTab
                    % start pump in multistep mode
                    app.CONNECTION.startPump('multistep',true);
                    % update pause button label
                    app.PauseButton.Text='Pause';
                    
                elseif app.TabGroup.SelectedTab==app.CycleModeTab
                    % start pump in cycle mode
                    app.CONNECTION.startPump('mode',3);
                    % update pause button label
                    app.PauseButton.Text='Pause';
                end
            end
        end

        % Button pushed function: PauseButton
        function PauseButtonPushed(app, event)
            if app.connected
                if all(length(app.PauseButton.Text)==5)
                    app.CONNECTION.pausePump();
                    % update pause button label
                    app.PauseButton.Text='Unpause';
                else
                    app.CONNECTION.startPump();
                    % update pause button label
                    app.PauseButton.Text='Pause';
                end
            end
        end

        % Button pushed function: StopButton
        function StopButtonPushed(app, event)
            if app.connected
                app.CONNECTION.stopPump();
                % update pause button label
                app.PauseButton.Text='Pause';
            end
        end

        % Value changed function: VolumeEditField_2
        function p1_mstep_VolumeEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendVolumeFromGUI(app.VolumeEditField_2.Value,1);
            end
        end

        % Value changed function: RateEditField_2
        function p1_mstep_RateEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendRateFromGUI(app.RateEditField_2.Value,1);
            end
        end

        % Value changed function: DelayEditField_2
        function p1_mstep_DelayEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendDelayFromGUI(app.DelayEditField_2.Value,1);
            end
        end

        % Value changed function: UnitsDropDown_2
        function p1_mstep_UnitsDropDown_2ValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI(app.UnitsDropDown_2.Value,1);
            end
            units=app.UnitsDropDown_2.Value;
            app.volLabel_2.Text=units(1:2);
            app.rateLabel_2.Text=units(4:end);
            app.delayLabel_2.Text=units(4:end);
        end

        % Value changed function: DiameterEditField_2
        function p1_mstep_DiameterEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendDiameterFromGUI(app.DiameterEditField_2.Value,1);
            end
        end

        % Value changed function: UnitsDropDown_3
        function p2_sstep_UnitsDropDown_3ValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI(app.UnitsDropDown_3.Value,2);
            end
            units= app.UnitsDropDown_3.Value;
            app.volLabel_3.Text=units(1:2);
            app.rateLabel_3.Text=units(4:end);
            app.delayLabel_3.Text=units(4:end);
        end

        % Value changed function: DiameterEditField_3
        function p2_sstep_DiameterEditField_3ValueChanged(app, event)
            if app.connected
                app.sendDiameterFromGUI(app.DiameterEditField_3.Value,2);
            end
        end

        % Value changed function: VolumeEditField_3
        function p2_sstep_VolumeEditField_3ValueChanged(app, event)
            if app.connected
                app.sendVolumeFromGUI(app.VolumeEditField_3.Value,2);
            end
        end

        % Value changed function: RateEditField_3
        function p2_sstep_RateEditField_3ValueChanged(app, event)
            if app.connected
                app.sendRateFromGUI(app.RateEditField_3.Value,2);
            end
        end

        % Value changed function: DelayEditField_3
        function p2_sstep_DelayEditField_3ValueChanged(app, event)
            if app.connected
                app.sendDelayFromGUI(app.DelayEditField_3.Value,2);
            end
        end

        % Value changed function: UnitsDropDown_4
        function p2_mstep_UnitsDropDown_4ValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI(app.UnitsDropDown_4.Value,2);
            end
            units=app.UnitsDropDown_4.Value;
            app.volLabel_4.Text=units(1:2);
            app.rateLabel_4.Text=units(4:end);
            app.delayLabel_4.Text=units(4:end);
        end

        % Value changed function: DiameterEditField_4
        function p2_mstep_DiameterEditField_4ValueChanged(app, event)
            if app.connected
                app.sendDiameterFromGUI(app.DiameterEditField_4.Value,2);
            end
        end

        % Value changed function: VolumeEditField_4
        function p2_mstep_VolumeEditField_4ValueChanged(app, event)
            if app.connected
                app.sendVolumeFromGUI(app.VolumeEditField_4.Value,2);
            end
        end

        % Value changed function: RateEditField_4
        function p2_mstep_RateEditField_4ValueChanged(app, event)
            if app.connected
                app.sendRateFromGUI(app.RateEditField_4.Value,2);
            end
        end

        % Value changed function: DelayEditField_4
        function p2_mstep_DelayEditField_4ValueChanged(app, event)
            if app.connected
                app.sendDelayFromGUI(app.DelayEditField_4.Value,2);
            end
        end

        % Value changed function: UnitsDropDown_5
        function cycle_UnitsDropDown_5ValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI(app.UnitsDropDown_5.Value,3);
            end
            units=app.UnitsDropDown_5.Value;
            app.volLabel_5.Text=units(1:2);
            app.rateLabel_5.Text=units(4:end);
            app.delayLabel_5.Text=units(4:end);
        end

        % Value changed function: DiameterEditField_5
        function cycle_DiameterEditField_5ValueChanged(app, event)
            if app.connected
                app.sendDiameterFromGUI(app.DiameterEditField_5.Value,3);
            end
        end

        % Value changed function: VolumeEditField_5
        function cycle_VolumeEditField_5ValueChanged(app, event)
            if app.connected
                app.sendVolumeFromGUI(app.VolumeEditField_5.Value,3);
            end
        end

        % Value changed function: RateEditField_5
        function cycle_RateEditField_5ValueChanged(app, event)
            if app.connected
                app.sendRateFromGUI(app.RateEditField_5.Value,3);
            end
        end

        % Value changed function: DelayEditField_5
        function cycle_DelayEditField_5ValueChanged(app, event)
            if app.connected
                app.sendDelayFromGUI(app.DelayEditField_5.Value,3);
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 707 479];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [47 375 607 62];
            app.Image.ImageSource = 'logo-with-tagline@500px.png';

            % Create ConnectionVariablesPanel
            app.ConnectionVariablesPanel = uipanel(app.UIFigure);
            app.ConnectionVariablesPanel.Title = 'Connection Variables';
            app.ConnectionVariablesPanel.Position = [47 216 230 143];

            % Create SerialPortDropDownLabel
            app.SerialPortDropDownLabel = uilabel(app.ConnectionVariablesPanel);
            app.SerialPortDropDownLabel.Position = [13 91 59 22];
            app.SerialPortDropDownLabel.Text = 'Serial Port';

            % Create SerialPortDropDown
            app.SerialPortDropDown = uidropdown(app.ConnectionVariablesPanel);
            app.SerialPortDropDown.Items = {};
            app.SerialPortDropDown.Tag = 'app_serialport';
            app.SerialPortDropDown.Tooltip = {'Select connected serial port'};
            app.SerialPortDropDown.Position = [97 91 77 22];
            app.SerialPortDropDown.Value = {};

            % Create ScanButton
            app.ScanButton = uibutton(app.ConnectionVariablesPanel, 'push');
            app.ScanButton.ButtonPushedFcn = createCallbackFcn(app, @ScanPorts, true);
            app.ScanButton.Position = [182 91 38 22];
            app.ScanButton.Text = 'Scan';

            % Create BaudRateDropDownLabel
            app.BaudRateDropDownLabel = uilabel(app.ConnectionVariablesPanel);
            app.BaudRateDropDownLabel.Position = [13 53 59 22];
            app.BaudRateDropDownLabel.Text = 'Baud Rate';

            % Create BaudRateDropDown
            app.BaudRateDropDown = uidropdown(app.ConnectionVariablesPanel);
            app.BaudRateDropDown.Items = {'9600', '14400', '19200', '38400', '57600', '115200'};
            app.BaudRateDropDown.Tooltip = {'Baud rate must match rate set on pump under "System Settings"'};
            app.BaudRateDropDown.Position = [97 53 119 22];
            app.BaudRateDropDown.Value = '9600';

            % Create StatusLampLabel
            app.StatusLampLabel = uilabel(app.ConnectionVariablesPanel);
            app.StatusLampLabel.Position = [13 14 40 22];
            app.StatusLampLabel.Text = 'Status';

            % Create StatusLamp
            app.StatusLamp = uilamp(app.ConnectionVariablesPanel);
            app.StatusLamp.Tooltip = {'Connection status'};
            app.StatusLamp.Position = [52 13 23 23];
            app.StatusLamp.Color = [1 0 0];

            % Create ConnectButton
            app.ConnectButton = uibutton(app.ConnectionVariablesPanel, 'push');
            app.ConnectButton.ButtonPushedFcn = createCallbackFcn(app, @ChangeConnection, true);
            app.ConnectButton.Position = [97 14 124 22];
            app.ConnectButton.Text = 'Connect';

            % Create RunControlsPanel
            app.RunControlsPanel = uipanel(app.UIFigure);
            app.RunControlsPanel.Title = 'Run Controls';
            app.RunControlsPanel.Position = [47 20 624 84];

            % Create StartButton
            app.StartButton = uibutton(app.RunControlsPanel, 'push');
            app.StartButton.ButtonPushedFcn = createCallbackFcn(app, @StartButtonPushed, true);
            app.StartButton.Enable = 'off';
            app.StartButton.Position = [14 13 169 40];
            app.StartButton.Text = 'Start';

            % Create PauseButton
            app.PauseButton = uibutton(app.RunControlsPanel, 'push');
            app.PauseButton.ButtonPushedFcn = createCallbackFcn(app, @PauseButtonPushed, true);
            app.PauseButton.Enable = 'off';
            app.PauseButton.Position = [227 13 169 40];
            app.PauseButton.Text = 'Pause';

            % Create StopButton
            app.StopButton = uibutton(app.RunControlsPanel, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Enable = 'off';
            app.StopButton.Position = [438 13 169 40];
            app.StopButton.Text = 'Stop';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [290 118 382 241];

            % Create SingleStepTab
            app.SingleStepTab = uitab(app.TabGroup);
            app.SingleStepTab.Title = 'Single-Step';

            % Create DelayEditField_3Label
            app.DelayEditField_3Label = uilabel(app.SingleStepTab);
            app.DelayEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DelayEditField_3Label.Position = [6 11 36 22];
            app.DelayEditField_3Label.Text = 'Delay';

            % Create DelayEditField
            app.DelayEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.DelayEditField.ValueChangedFcn = createCallbackFcn(app, @p1_sstep_DelayEditFieldValueChanged, true);
            app.DelayEditField.Position = [67 11 62 22];

            % Create delayLabel
            app.delayLabel = uilabel(app.SingleStepTab);
            app.delayLabel.Position = [135 11 34 22];
            app.delayLabel.Text = {'delay'; ''};

            % Create RateEditField_3Label
            app.RateEditField_3Label = uilabel(app.SingleStepTab);
            app.RateEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.RateEditField_3Label.Position = [6 46 31 22];
            app.RateEditField_3Label.Text = 'Rate';

            % Create RateEditField
            app.RateEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.RateEditField.ValueChangedFcn = createCallbackFcn(app, @p1_sstep_RateEditFieldValueChanged, true);
            app.RateEditField.Position = [67 46 62 22];

            % Create rateLabel
            app.rateLabel = uilabel(app.SingleStepTab);
            app.rateLabel.Position = [135 45 26 22];
            app.rateLabel.Text = 'rate';

            % Create volLabel
            app.volLabel = uilabel(app.SingleStepTab);
            app.volLabel.Position = [135 85 25 22];
            app.volLabel.Text = 'vol';

            % Create VolumeEditField_3Label
            app.VolumeEditField_3Label = uilabel(app.SingleStepTab);
            app.VolumeEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.VolumeEditField_3Label.Position = [6 85 45 22];
            app.VolumeEditField_3Label.Text = 'Volume';

            % Create VolumeEditField
            app.VolumeEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.VolumeEditField.ValueChangedFcn = createCallbackFcn(app, @p1_sstep_VolumeEditFieldValueChanged, true);
            app.VolumeEditField.Position = [67 85 62 22];

            % Create DiameterEditField_5Label
            app.DiameterEditField_5Label = uilabel(app.SingleStepTab);
            app.DiameterEditField_5Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_5Label.Position = [7 123 54 22];
            app.DiameterEditField_5Label.Text = 'Diameter';

            % Create DiameterEditField
            app.DiameterEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.DiameterEditField.ValueChangedFcn = createCallbackFcn(app, @p1_sstep_DiameterEditFieldValueChanged, true);
            app.DiameterEditField.Position = [68 123 62 22];

            % Create UnitsDropDown_5Label
            app.UnitsDropDown_5Label = uilabel(app.SingleStepTab);
            app.UnitsDropDown_5Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_5Label.Position = [7 157 33 22];
            app.UnitsDropDown_5Label.Text = 'Units';

            % Create UnitsDropDown
            app.UnitsDropDown = uidropdown(app.SingleStepTab);
            app.UnitsDropDown.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown.ValueChangedFcn = createCallbackFcn(app, @p1_sstep_UnitsDropDownValueChanged, true);
            app.UnitsDropDown.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown.Position = [46 157 81 22];
            app.UnitsDropDown.Value = 'mL/min';

            % Create mmLabel
            app.mmLabel = uilabel(app.SingleStepTab);
            app.mmLabel.Position = [135 123 25 22];
            app.mmLabel.Text = 'mm';

            % Create delayLabel_3
            app.delayLabel_3 = uilabel(app.SingleStepTab);
            app.delayLabel_3.Position = [331 11 34 22];
            app.delayLabel_3.Text = {'delay'; ''};

            % Create rateLabel_3
            app.rateLabel_3 = uilabel(app.SingleStepTab);
            app.rateLabel_3.Position = [331 45 26 22];
            app.rateLabel_3.Text = 'rate';

            % Create volLabel_3
            app.volLabel_3 = uilabel(app.SingleStepTab);
            app.volLabel_3.Position = [331 85 25 22];
            app.volLabel_3.Text = 'vol';

            % Create mmLabel_2
            app.mmLabel_2 = uilabel(app.SingleStepTab);
            app.mmLabel_2.Position = [331 123 25 22];
            app.mmLabel_2.Text = 'mm';

            % Create UnitsDropDown_3Label
            app.UnitsDropDown_3Label = uilabel(app.SingleStepTab);
            app.UnitsDropDown_3Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_3Label.Position = [202 157 33 22];
            app.UnitsDropDown_3Label.Text = 'Units';

            % Create UnitsDropDown_3
            app.UnitsDropDown_3 = uidropdown(app.SingleStepTab);
            app.UnitsDropDown_3.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown_3.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown_3.ValueChangedFcn = createCallbackFcn(app, @p2_sstep_UnitsDropDown_3ValueChanged, true);
            app.UnitsDropDown_3.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_3.Position = [241 157 81 22];
            app.UnitsDropDown_3.Value = 'mL/min';

            % Create DelayEditField_3Label_2
            app.DelayEditField_3Label_2 = uilabel(app.SingleStepTab);
            app.DelayEditField_3Label_2.Tooltip = {'Diameter of syringe (mm)'};
            app.DelayEditField_3Label_2.Position = [202 11 36 22];
            app.DelayEditField_3Label_2.Text = 'Delay';

            % Create DelayEditField_3
            app.DelayEditField_3 = uieditfield(app.SingleStepTab, 'numeric');
            app.DelayEditField_3.ValueChangedFcn = createCallbackFcn(app, @p2_sstep_DelayEditField_3ValueChanged, true);
            app.DelayEditField_3.Position = [263 11 62 22];

            % Create RateEditField_3Label_2
            app.RateEditField_3Label_2 = uilabel(app.SingleStepTab);
            app.RateEditField_3Label_2.Tooltip = {'Diameter of syringe (mm)'};
            app.RateEditField_3Label_2.Position = [202 46 31 22];
            app.RateEditField_3Label_2.Text = 'Rate';

            % Create RateEditField_3
            app.RateEditField_3 = uieditfield(app.SingleStepTab, 'numeric');
            app.RateEditField_3.ValueChangedFcn = createCallbackFcn(app, @p2_sstep_RateEditField_3ValueChanged, true);
            app.RateEditField_3.Position = [263 46 62 22];

            % Create VolumeEditField_3Label_2
            app.VolumeEditField_3Label_2 = uilabel(app.SingleStepTab);
            app.VolumeEditField_3Label_2.Tooltip = {'Diameter of syringe (mm)'};
            app.VolumeEditField_3Label_2.Position = [202 85 45 22];
            app.VolumeEditField_3Label_2.Text = 'Volume';

            % Create VolumeEditField_3
            app.VolumeEditField_3 = uieditfield(app.SingleStepTab, 'numeric');
            app.VolumeEditField_3.ValueChangedFcn = createCallbackFcn(app, @p2_sstep_VolumeEditField_3ValueChanged, true);
            app.VolumeEditField_3.Position = [263 85 62 22];

            % Create DiameterEditField_3Label
            app.DiameterEditField_3Label = uilabel(app.SingleStepTab);
            app.DiameterEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_3Label.Position = [203 123 54 22];
            app.DiameterEditField_3Label.Text = 'Diameter';

            % Create DiameterEditField_3
            app.DiameterEditField_3 = uieditfield(app.SingleStepTab, 'numeric');
            app.DiameterEditField_3.ValueChangedFcn = createCallbackFcn(app, @p2_sstep_DiameterEditField_3ValueChanged, true);
            app.DiameterEditField_3.Position = [264 123 62 22];

            % Create Pump1Label
            app.Pump1Label = uilabel(app.SingleStepTab);
            app.Pump1Label.HorizontalAlignment = 'center';
            app.Pump1Label.FontWeight = 'bold';
            app.Pump1Label.Position = [12 189 158 22];
            app.Pump1Label.Text = 'Pump 1';

            % Create Pump2Label
            app.Pump2Label = uilabel(app.SingleStepTab);
            app.Pump2Label.HorizontalAlignment = 'center';
            app.Pump2Label.FontWeight = 'bold';
            app.Pump2Label.Position = [201 189 158 22];
            app.Pump2Label.Text = 'Pump 2';

            % Create MultiStepTab
            app.MultiStepTab = uitab(app.TabGroup);
            app.MultiStepTab.Title = 'Multi-Step';

            % Create DiameterEditField_4Label
            app.DiameterEditField_4Label = uilabel(app.MultiStepTab);
            app.DiameterEditField_4Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_4Label.Position = [7 123 54 22];
            app.DiameterEditField_4Label.Text = 'Diameter';

            % Create DiameterEditField_2
            app.DiameterEditField_2 = uieditfield(app.MultiStepTab, 'numeric');
            app.DiameterEditField_2.ValueChangedFcn = createCallbackFcn(app, @p1_mstep_DiameterEditField_2ValueChanged, true);
            app.DiameterEditField_2.Position = [68 123 85 22];

            % Create UnitsDropDown_4Label
            app.UnitsDropDown_4Label = uilabel(app.MultiStepTab);
            app.UnitsDropDown_4Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_4Label.Position = [6 157 33 22];
            app.UnitsDropDown_4Label.Text = 'Units';

            % Create UnitsDropDown_2
            app.UnitsDropDown_2 = uidropdown(app.MultiStepTab);
            app.UnitsDropDown_2.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown_2.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown_2.ValueChangedFcn = createCallbackFcn(app, @p1_mstep_UnitsDropDown_2ValueChanged, true);
            app.UnitsDropDown_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_2.Position = [53 157 100 22];
            app.UnitsDropDown_2.Value = 'mL/min';

            % Create RateEditField_4Label
            app.RateEditField_4Label = uilabel(app.MultiStepTab);
            app.RateEditField_4Label.Position = [7 45 31 22];
            app.RateEditField_4Label.Text = {'Rate'; ''};

            % Create RateEditField_2
            app.RateEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.RateEditField_2.ValueChangedFcn = createCallbackFcn(app, @p1_mstep_RateEditField_2ValueChanged, true);
            app.RateEditField_2.Position = [68 45 86 22];

            % Create VolumeEditField_4Label
            app.VolumeEditField_4Label = uilabel(app.MultiStepTab);
            app.VolumeEditField_4Label.Position = [6 85 45 22];
            app.VolumeEditField_4Label.Text = 'Volume';

            % Create VolumeEditField_2
            app.VolumeEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.VolumeEditField_2.ValueChangedFcn = createCallbackFcn(app, @p1_mstep_VolumeEditField_2ValueChanged, true);
            app.VolumeEditField_2.Position = [68 85 86 22];

            % Create volLabel_2
            app.volLabel_2 = uilabel(app.MultiStepTab);
            app.volLabel_2.Position = [159 85 25 22];
            app.volLabel_2.Text = 'vol';

            % Create rateLabel_2
            app.rateLabel_2 = uilabel(app.MultiStepTab);
            app.rateLabel_2.Position = [159 45 26 22];
            app.rateLabel_2.Text = 'rate';

            % Create delayLabel_2
            app.delayLabel_2 = uilabel(app.MultiStepTab);
            app.delayLabel_2.Position = [159 11 34 22];
            app.delayLabel_2.Text = {'delay'; ''};

            % Create DelayEditField_4Label
            app.DelayEditField_4Label = uilabel(app.MultiStepTab);
            app.DelayEditField_4Label.Position = [7 11 36 22];
            app.DelayEditField_4Label.Text = 'Delay';

            % Create DelayEditField_2
            app.DelayEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.DelayEditField_2.ValueChangedFcn = createCallbackFcn(app, @p1_mstep_DelayEditField_2ValueChanged, true);
            app.DelayEditField_2.Position = [68 11 86 22];

            % Create volLabel_4
            app.volLabel_4 = uilabel(app.MultiStepTab);
            app.volLabel_4.Position = [349 85 25 22];
            app.volLabel_4.Text = 'vol';

            % Create rateLabel_4
            app.rateLabel_4 = uilabel(app.MultiStepTab);
            app.rateLabel_4.Position = [349 45 26 22];
            app.rateLabel_4.Text = 'rate';

            % Create delayLabel_4
            app.delayLabel_4 = uilabel(app.MultiStepTab);
            app.delayLabel_4.Position = [349 11 34 22];
            app.delayLabel_4.Text = {'delay'; ''};

            % Create UnitsDropDown_4Label_2
            app.UnitsDropDown_4Label_2 = uilabel(app.MultiStepTab);
            app.UnitsDropDown_4Label_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_4Label_2.Position = [195 157 33 22];
            app.UnitsDropDown_4Label_2.Text = 'Units';

            % Create UnitsDropDown_4
            app.UnitsDropDown_4 = uidropdown(app.MultiStepTab);
            app.UnitsDropDown_4.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown_4.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown_4.ValueChangedFcn = createCallbackFcn(app, @p2_mstep_UnitsDropDown_4ValueChanged, true);
            app.UnitsDropDown_4.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_4.Position = [242 157 102 22];
            app.UnitsDropDown_4.Value = 'mL/min';

            % Create DiameterEditField_4Label_2
            app.DiameterEditField_4Label_2 = uilabel(app.MultiStepTab);
            app.DiameterEditField_4Label_2.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_4Label_2.Position = [197 123 54 22];
            app.DiameterEditField_4Label_2.Text = 'Diameter';

            % Create DiameterEditField_4
            app.DiameterEditField_4 = uieditfield(app.MultiStepTab, 'numeric');
            app.DiameterEditField_4.ValueChangedFcn = createCallbackFcn(app, @p2_mstep_DiameterEditField_4ValueChanged, true);
            app.DiameterEditField_4.Position = [258 123 86 22];

            % Create RateEditField_4Label_2
            app.RateEditField_4Label_2 = uilabel(app.MultiStepTab);
            app.RateEditField_4Label_2.Position = [197 45 31 22];
            app.RateEditField_4Label_2.Text = {'Rate'; ''};

            % Create RateEditField_4
            app.RateEditField_4 = uieditfield(app.MultiStepTab, 'text');
            app.RateEditField_4.ValueChangedFcn = createCallbackFcn(app, @p2_mstep_RateEditField_4ValueChanged, true);
            app.RateEditField_4.Position = [258 45 86 22];

            % Create DelayEditField_4Label_2
            app.DelayEditField_4Label_2 = uilabel(app.MultiStepTab);
            app.DelayEditField_4Label_2.Position = [197 11 36 22];
            app.DelayEditField_4Label_2.Text = 'Delay';

            % Create DelayEditField_4
            app.DelayEditField_4 = uieditfield(app.MultiStepTab, 'text');
            app.DelayEditField_4.ValueChangedFcn = createCallbackFcn(app, @p2_mstep_DelayEditField_4ValueChanged, true);
            app.DelayEditField_4.Position = [258 11 86 22];

            % Create VolumeEditField_4Label_2
            app.VolumeEditField_4Label_2 = uilabel(app.MultiStepTab);
            app.VolumeEditField_4Label_2.Position = [196 85 45 22];
            app.VolumeEditField_4Label_2.Text = 'Volume';

            % Create VolumeEditField_4
            app.VolumeEditField_4 = uieditfield(app.MultiStepTab, 'text');
            app.VolumeEditField_4.ValueChangedFcn = createCallbackFcn(app, @p2_mstep_VolumeEditField_4ValueChanged, true);
            app.VolumeEditField_4.Position = [258 85 86 22];

            % Create mmLabel_4
            app.mmLabel_4 = uilabel(app.MultiStepTab);
            app.mmLabel_4.Position = [159 123 25 22];
            app.mmLabel_4.Text = 'mm';

            % Create mmLabel_5
            app.mmLabel_5 = uilabel(app.MultiStepTab);
            app.mmLabel_5.Position = [349 123 25 22];
            app.mmLabel_5.Text = 'mm';

            % Create Pump1Label_2
            app.Pump1Label_2 = uilabel(app.MultiStepTab);
            app.Pump1Label_2.HorizontalAlignment = 'center';
            app.Pump1Label_2.FontWeight = 'bold';
            app.Pump1Label_2.Position = [12 189 158 22];
            app.Pump1Label_2.Text = 'Pump 1';

            % Create Pump2Label_2
            app.Pump2Label_2 = uilabel(app.MultiStepTab);
            app.Pump2Label_2.HorizontalAlignment = 'center';
            app.Pump2Label_2.FontWeight = 'bold';
            app.Pump2Label_2.Position = [201 189 158 22];
            app.Pump2Label_2.Text = 'Pump 2';

            % Create CycleModeTab
            app.CycleModeTab = uitab(app.TabGroup);
            app.CycleModeTab.Title = 'Cycle Mode';

            % Create delayLabel_5
            app.delayLabel_5 = uilabel(app.CycleModeTab);
            app.delayLabel_5.Position = [154 24 34 22];
            app.delayLabel_5.Text = {'delay'; ''};

            % Create rateLabel_5
            app.rateLabel_5 = uilabel(app.CycleModeTab);
            app.rateLabel_5.Position = [154 58 26 22];
            app.rateLabel_5.Text = 'rate';

            % Create volLabel_5
            app.volLabel_5 = uilabel(app.CycleModeTab);
            app.volLabel_5.Position = [154 98 25 22];
            app.volLabel_5.Text = 'vol';

            % Create mmLabel_3
            app.mmLabel_3 = uilabel(app.CycleModeTab);
            app.mmLabel_3.Position = [154 136 25 22];
            app.mmLabel_3.Text = 'mm';

            % Create DelayEditField_5Label
            app.DelayEditField_5Label = uilabel(app.CycleModeTab);
            app.DelayEditField_5Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DelayEditField_5Label.Position = [25 24 36 22];
            app.DelayEditField_5Label.Text = 'Delay';

            % Create DelayEditField_5
            app.DelayEditField_5 = uieditfield(app.CycleModeTab, 'numeric');
            app.DelayEditField_5.ValueChangedFcn = createCallbackFcn(app, @cycle_DelayEditField_5ValueChanged, true);
            app.DelayEditField_5.Position = [86 24 62 22];

            % Create RateEditField_5Label
            app.RateEditField_5Label = uilabel(app.CycleModeTab);
            app.RateEditField_5Label.Tooltip = {'Diameter of syringe (mm)'};
            app.RateEditField_5Label.Position = [25 59 31 22];
            app.RateEditField_5Label.Text = 'Rate';

            % Create RateEditField_5
            app.RateEditField_5 = uieditfield(app.CycleModeTab, 'numeric');
            app.RateEditField_5.ValueChangedFcn = createCallbackFcn(app, @cycle_RateEditField_5ValueChanged, true);
            app.RateEditField_5.Position = [86 59 62 22];

            % Create VolumeEditField_5Label
            app.VolumeEditField_5Label = uilabel(app.CycleModeTab);
            app.VolumeEditField_5Label.Tooltip = {'Diameter of syringe (mm)'};
            app.VolumeEditField_5Label.Position = [25 98 45 22];
            app.VolumeEditField_5Label.Text = 'Volume';

            % Create VolumeEditField_5
            app.VolumeEditField_5 = uieditfield(app.CycleModeTab, 'numeric');
            app.VolumeEditField_5.ValueChangedFcn = createCallbackFcn(app, @cycle_VolumeEditField_5ValueChanged, true);
            app.VolumeEditField_5.Position = [86 98 62 22];

            % Create DiameterEditField_5Label_2
            app.DiameterEditField_5Label_2 = uilabel(app.CycleModeTab);
            app.DiameterEditField_5Label_2.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_5Label_2.Position = [26 136 54 22];
            app.DiameterEditField_5Label_2.Text = 'Diameter';

            % Create DiameterEditField_5
            app.DiameterEditField_5 = uieditfield(app.CycleModeTab, 'numeric');
            app.DiameterEditField_5.ValueChangedFcn = createCallbackFcn(app, @cycle_DiameterEditField_5ValueChanged, true);
            app.DiameterEditField_5.Position = [87 136 62 22];

            % Create UnitsDropDown_5Label_2
            app.UnitsDropDown_5Label_2 = uilabel(app.CycleModeTab);
            app.UnitsDropDown_5Label_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_5Label_2.Position = [25 168 33 22];
            app.UnitsDropDown_5Label_2.Text = 'Units';

            % Create UnitsDropDown_5
            app.UnitsDropDown_5 = uidropdown(app.CycleModeTab);
            app.UnitsDropDown_5.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown_5.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown_5.ValueChangedFcn = createCallbackFcn(app, @cycle_UnitsDropDown_5ValueChanged, true);
            app.UnitsDropDown_5.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_5.Position = [64 168 84 22];
            app.UnitsDropDown_5.Value = 'mL/min';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CHEMYX_GUI_dualchannel

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end