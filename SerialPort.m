% GLOVE SerialPort 
% connection to a virtual usb serial port

% connect to serial port
s = serial('/dev/cu.AmpedUp-AMP-SPP');

% properties
s.Terminator='CR/LF';
s.BaudRate=115200;
s.StopBits=1;
s.DataBits=8;
s.Parity='none';
s.FlowControl='none';

% START_COMMAND
start_command = ['01','02','01','03'];
% STOP_COMMAND
stop_command = ['01','02','00','03'];

% connect
fopen(s);
fwrite(s, start_command);
while 1
    s.BytesAvailable
%     out = fscanf(s);
end

% disconnect
fclose(s);
delete(s);


