classdef CHEMYX_GUI < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        Image                     matlab.ui.control.Image
        ConnectionVariablesPanel  matlab.ui.container.Panel
        SerialPortDropDownLabel   matlab.ui.control.Label
        SerialPortDropDown        matlab.ui.control.DropDown
        ScanButton                matlab.ui.control.Button
        BaudRateDropDownLabel     matlab.ui.control.Label
        BaudRateDropDown          matlab.ui.control.DropDown
        StatusLampLabel           matlab.ui.control.Label
        StatusLamp                matlab.ui.control.Lamp
        ConnectButton             matlab.ui.control.Button
        RunControlsPanel          matlab.ui.container.Panel
        StartButton               matlab.ui.control.Button
        PauseButton               matlab.ui.control.Button
        StopButton                matlab.ui.control.Button
        TabGroup                  matlab.ui.container.TabGroup
        SingleStepTab             matlab.ui.container.Tab
        DelayEditField_3Label     matlab.ui.control.Label
        DelayEditField            matlab.ui.control.NumericEditField
        delayLabel                matlab.ui.control.Label
        RateEditField_3Label      matlab.ui.control.Label
        RateEditField             matlab.ui.control.NumericEditField
        rateLabel                 matlab.ui.control.Label
        volLabel                  matlab.ui.control.Label
        VolumeEditField_3Label    matlab.ui.control.Label
        VolumeEditField           matlab.ui.control.NumericEditField
        DiameterEditField_5Label  matlab.ui.control.Label
        DiameterEditField         matlab.ui.control.NumericEditField
        UnitsDropDown_5Label      matlab.ui.control.Label
        UnitsDropDown             matlab.ui.control.DropDown
        mmLabel                   matlab.ui.control.Label
        MultiStepTab              matlab.ui.container.Tab
        DiameterEditField_4Label  matlab.ui.control.Label
        DiameterEditField_2       matlab.ui.control.NumericEditField
        UnitsDropDown_4Label      matlab.ui.control.Label
        UnitsDropDown_2           matlab.ui.control.DropDown
        RateEditField_4Label      matlab.ui.control.Label
        RateEditField_2           matlab.ui.control.EditField
        VolumeEditField_4Label    matlab.ui.control.Label
        VolumeEditField_2         matlab.ui.control.EditField
        volLabel_2                matlab.ui.control.Label
        rateLabel_2               matlab.ui.control.Label
        delayLabel_2              matlab.ui.control.Label
        DelayEditField_4Label     matlab.ui.control.Label
        DelayEditField_2          matlab.ui.control.EditField
    end

    
    properties (Access = private)
        CONNECTION = connection; % Chemyx syringe pump
        connected = false;% track connection status
    end
  
    methods (Access = private)
        function app = sendUnitsFromGUI(app)
            app.CONNECTION.setUnits(app.UnitsDropDown.Value);
        end
        function app = sendDiameterFromGUI(app)
            app.CONNECTION.setDiameter(app.DiameterEditField.Value);
        end
        function app = sendVolumeFromGUI(app)
            app.CONNECTION.setVolume(app.VolumeEditField.Value);
        end
        function app = sendRateFromGUI(app)
            app.CONNECTION.setRate(app.RateEditField.Value);
        end
        function app = sendDelayFromGUI(app)
            app.CONNECTION.setDelay(app.DelayEditField.Value);
        end
        function app = mstep_sendUnitsFromGUI(app)
            app.CONNECTION.setUnits(app.UnitsDropDown_2.Value);
        end
        function app = mstep_sendDiameterFromGUI(app)
            app.CONNECTION.setDiameter(app.DiameterEditField_2.Value);
        end
        function app = mstep_sendVolumeFromGUI(app)
            % need to reformat to enter valid command
            value=split(app.VolumeEditField_2.Value,",");
            app.CONNECTION.setVolume(value);
        end
        function app = mstep_sendRateFromGUI(app)
            % need to reformat to enter valid command
            value=split(app.RateEditField_2.Value,",");
            app.CONNECTION.setRate(value);
        end
        function app = mstep_sendDelayFromGUI(app)
            % need to reformat to enter valid command
            value=split(app.DelayEditField_2.Value,",");
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
                    app.CONNECTION.openConnection(port,baudrate);
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
        function sstep_UnitsDropDownValueChanged(app, event)
            if app.connected
                app.sendUnitsFromGUI();
            end
            units=app.UnitsDropDown.Value;
            app.volLabel.Text=units(1:2);
            app.rateLabel.Text=units(4:end);
            app.delayLabel.Text=units(4:end);
        end

        % Value changed function: DiameterEditField
        function sstep_DiameterEditFieldValueChanged(app, event)
            if app.connected
                app.sendDiameterFromGUI();
            end
        end

        % Value changed function: VolumeEditField
        function sstep_VolumeEditFieldValueChanged(app, event)
            if app.connected
                app.sendVolumeFromGUI();
            end
        end

        % Value changed function: RateEditField
        function sstep_RateEditFieldValueChanged(app, event)
            if app.connected
                app.sendRateFromGUI();
            end
        end

        % Value changed function: DelayEditField
        function sstep_DelayEditFieldValueChanged(app, event)
            if app.connected
                app.sendDelayFromGUI();
            end
        end

        % Button pushed function: StartButton
        function StartButtonPushed(app, event)
            if app.connected
                % resend pump variables
                if app.TabGroup.SelectedTab==app.SingleStepTab
                    % if single step
                    app.sendUnitsFromGUI();
                    app.sendDiameterFromGUI();
                    app.sendVolumeFromGUI();
                    app.sendRateFromGUI();
                    app.sendDelayFromGUI();
                    % start pump
                    app.CONNECTION.startPump();
                    % update pause button label
                    app.PauseButton.Text='Pause';
                elseif app.TabGroup.SelectedTab==app.MultiStepTab
                    % if multi step
                    app.mstep_sendUnitsFromGUI();
                    app.mstep_sendDiameterFromGUI();
                    app.mstep_sendVolumeFromGUI();
                    app.mstep_sendRateFromGUI();
                    app.mstep_sendDelayFromGUI();
                    % start pump in multistep mode
                    app.CONNECTION.startPump('multistep',true);
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
        function mstep_VolumeEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendVolumeFromGUI();
            end
        end

        % Value changed function: RateEditField_2
        function mstep_RateEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendRateFromGUI();
            end
        end

        % Value changed function: DelayEditField_2
        function mstep_DelayEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendDelayFromGUI();
            end
        end

        % Value changed function: UnitsDropDown_2
        function mstep_UnitsDropDown_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendUnitsFromGUI();
            end
            units=app.UnitsDropDown_2.Value;
            app.volLabel_2.Text=units(1:2);
            app.rateLabel_2.Text=units(4:end);
            app.delayLabel_2.Text=units(4:end);
        end

        % Value changed function: DiameterEditField_2
        function mstep_DiameterEditField_2ValueChanged(app, event)
            if app.connected
                app.mstep_sendDiameterFromGUI();
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 427];
            app.UIFigure.Name = 'MATLAB App';

            % Create Image
            app.Image = uiimage(app.UIFigure);
            app.Image.Position = [47 323 548 62];
            app.Image.ImageSource = 'logo-with-tagline@500px.png';

            % Create ConnectionVariablesPanel
            app.ConnectionVariablesPanel = uipanel(app.UIFigure);
            app.ConnectionVariablesPanel.Title = 'Connection Variables';
            app.ConnectionVariablesPanel.Position = [47 164 233 143];

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
            app.RunControlsPanel.Position = [47 31 548 84];

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
            app.PauseButton.Position = [189 13 169 40];
            app.PauseButton.Text = 'Pause';

            % Create StopButton
            app.StopButton = uibutton(app.RunControlsPanel, 'push');
            app.StopButton.ButtonPushedFcn = createCallbackFcn(app, @StopButtonPushed, true);
            app.StopButton.Enable = 'off';
            app.StopButton.Position = [364 13 169 40];
            app.StopButton.Text = 'Stop';

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.Position = [290 131 305 176];

            % Create SingleStepTab
            app.SingleStepTab = uitab(app.TabGroup);
            app.SingleStepTab.Title = 'Single-Step';

            % Create DelayEditField_3Label
            app.DelayEditField_3Label = uilabel(app.SingleStepTab);
            app.DelayEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DelayEditField_3Label.Position = [6 9 36 22];
            app.DelayEditField_3Label.Text = 'Delay';

            % Create DelayEditField
            app.DelayEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.DelayEditField.ValueChangedFcn = createCallbackFcn(app, @sstep_DelayEditFieldValueChanged, true);
            app.DelayEditField.Position = [67 9 62 22];

            % Create delayLabel
            app.delayLabel = uilabel(app.SingleStepTab);
            app.delayLabel.Position = [135 9 34 22];
            app.delayLabel.Text = {'delay'; ''};

            % Create RateEditField_3Label
            app.RateEditField_3Label = uilabel(app.SingleStepTab);
            app.RateEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.RateEditField_3Label.Position = [6 44 31 22];
            app.RateEditField_3Label.Text = 'Rate';

            % Create RateEditField
            app.RateEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.RateEditField.ValueChangedFcn = createCallbackFcn(app, @sstep_RateEditFieldValueChanged, true);
            app.RateEditField.Position = [67 44 62 22];

            % Create rateLabel
            app.rateLabel = uilabel(app.SingleStepTab);
            app.rateLabel.Position = [135 43 26 22];
            app.rateLabel.Text = 'rate';

            % Create volLabel
            app.volLabel = uilabel(app.SingleStepTab);
            app.volLabel.Position = [135 83 25 22];
            app.volLabel.Text = 'vol';

            % Create VolumeEditField_3Label
            app.VolumeEditField_3Label = uilabel(app.SingleStepTab);
            app.VolumeEditField_3Label.Tooltip = {'Diameter of syringe (mm)'};
            app.VolumeEditField_3Label.Position = [6 83 45 22];
            app.VolumeEditField_3Label.Text = 'Volume';

            % Create VolumeEditField
            app.VolumeEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.VolumeEditField.ValueChangedFcn = createCallbackFcn(app, @sstep_VolumeEditFieldValueChanged, true);
            app.VolumeEditField.Position = [67 83 62 22];

            % Create DiameterEditField_5Label
            app.DiameterEditField_5Label = uilabel(app.SingleStepTab);
            app.DiameterEditField_5Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_5Label.Position = [7 121 54 22];
            app.DiameterEditField_5Label.Text = 'Diameter';

            % Create DiameterEditField
            app.DiameterEditField = uieditfield(app.SingleStepTab, 'numeric');
            app.DiameterEditField.ValueChangedFcn = createCallbackFcn(app, @sstep_DiameterEditFieldValueChanged, true);
            app.DiameterEditField.Position = [68 121 62 22];

            % Create UnitsDropDown_5Label
            app.UnitsDropDown_5Label = uilabel(app.SingleStepTab);
            app.UnitsDropDown_5Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_5Label.HorizontalAlignment = 'right';
            app.UnitsDropDown_5Label.FontWeight = 'bold';
            app.UnitsDropDown_5Label.Position = [168 121 34 22];
            app.UnitsDropDown_5Label.Text = 'Units';

            % Create UnitsDropDown
            app.UnitsDropDown = uidropdown(app.SingleStepTab);
            app.UnitsDropDown.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown.ValueChangedFcn = createCallbackFcn(app, @sstep_UnitsDropDownValueChanged, true);
            app.UnitsDropDown.FontWeight = 'bold';
            app.UnitsDropDown.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown.Position = [216 121 81 22];
            app.UnitsDropDown.Value = 'mL/min';

            % Create mmLabel
            app.mmLabel = uilabel(app.SingleStepTab);
            app.mmLabel.Position = [135 121 25 22];
            app.mmLabel.Text = 'mm';

            % Create MultiStepTab
            app.MultiStepTab = uitab(app.TabGroup);
            app.MultiStepTab.Title = 'Multi-Step';

            % Create DiameterEditField_4Label
            app.DiameterEditField_4Label = uilabel(app.MultiStepTab);
            app.DiameterEditField_4Label.Tooltip = {'Diameter of syringe (mm)'};
            app.DiameterEditField_4Label.Position = [6 121 54 22];
            app.DiameterEditField_4Label.Text = 'Diameter';

            % Create DiameterEditField_2
            app.DiameterEditField_2 = uieditfield(app.MultiStepTab, 'numeric');
            app.DiameterEditField_2.ValueChangedFcn = createCallbackFcn(app, @mstep_DiameterEditField_2ValueChanged, true);
            app.DiameterEditField_2.Position = [67 121 62 22];

            % Create UnitsDropDown_4Label
            app.UnitsDropDown_4Label = uilabel(app.MultiStepTab);
            app.UnitsDropDown_4Label.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_4Label.HorizontalAlignment = 'right';
            app.UnitsDropDown_4Label.FontWeight = 'bold';
            app.UnitsDropDown_4Label.Position = [167 121 34 22];
            app.UnitsDropDown_4Label.Text = 'Units';

            % Create UnitsDropDown_2
            app.UnitsDropDown_2 = uidropdown(app.MultiStepTab);
            app.UnitsDropDown_2.Items = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr'};
            app.UnitsDropDown_2.ItemsData = {'mL/min', 'mL/hr', 'ÿL/min', 'ÿL/hr', ''};
            app.UnitsDropDown_2.ValueChangedFcn = createCallbackFcn(app, @mstep_UnitsDropDown_2ValueChanged, true);
            app.UnitsDropDown_2.FontWeight = 'bold';
            app.UnitsDropDown_2.BackgroundColor = [0.9412 0.9412 0.9412];
            app.UnitsDropDown_2.Position = [215 121 81 22];
            app.UnitsDropDown_2.Value = 'mL/min';

            % Create RateEditField_4Label
            app.RateEditField_4Label = uilabel(app.MultiStepTab);
            app.RateEditField_4Label.Position = [6 43 31 22];
            app.RateEditField_4Label.Text = {'Rate'; ''};

            % Create RateEditField_2
            app.RateEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.RateEditField_2.ValueChangedFcn = createCallbackFcn(app, @mstep_RateEditField_2ValueChanged, true);
            app.RateEditField_2.Position = [67 43 196 22];

            % Create VolumeEditField_4Label
            app.VolumeEditField_4Label = uilabel(app.MultiStepTab);
            app.VolumeEditField_4Label.Position = [5 83 45 22];
            app.VolumeEditField_4Label.Text = 'Volume';

            % Create VolumeEditField_2
            app.VolumeEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.VolumeEditField_2.ValueChangedFcn = createCallbackFcn(app, @mstep_VolumeEditField_2ValueChanged, true);
            app.VolumeEditField_2.Position = [67 83 196 22];

            % Create volLabel_2
            app.volLabel_2 = uilabel(app.MultiStepTab);
            app.volLabel_2.Position = [270 83 25 22];
            app.volLabel_2.Text = 'vol';

            % Create rateLabel_2
            app.rateLabel_2 = uilabel(app.MultiStepTab);
            app.rateLabel_2.Position = [270 43 26 22];
            app.rateLabel_2.Text = 'rate';

            % Create delayLabel_2
            app.delayLabel_2 = uilabel(app.MultiStepTab);
            app.delayLabel_2.Position = [270 9 34 22];
            app.delayLabel_2.Text = {'delay'; ''};

            % Create DelayEditField_4Label
            app.DelayEditField_4Label = uilabel(app.MultiStepTab);
            app.DelayEditField_4Label.Position = [6 9 36 22];
            app.DelayEditField_4Label.Text = 'Delay';

            % Create DelayEditField_2
            app.DelayEditField_2 = uieditfield(app.MultiStepTab, 'text');
            app.DelayEditField_2.ValueChangedFcn = createCallbackFcn(app, @mstep_DelayEditField_2ValueChanged, true);
            app.DelayEditField_2.Position = [67 9 196 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = CHEMYX_GUI

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