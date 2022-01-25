%%  Creating 2bar mechanism via MATLAB commands
%   Author: Ivolga Dmitriy
%   Version: 1.0

%% Creating file
fname = 'two_link_mech';

%Check if the file already exists
if exist(fname, 'file') == 4   
    if bdIsLoaded(fname)
        close_system(fname,0); % Close if file found
    end
    delete([fname, '.mdl']); % And delete it
end

new_system(fname);
set_param(fname, 'StopTime', '15');
open_system(fname);

%% Adding block
add_block('sm_lib/Frames and Transforms/World Frame', [fname,'/WorldFrame'], 'Position', [0 0 30 32]);
add_block('nesl_utility/Solver Configuration', [fname,'/SolverConf'], 'Position', [0 60 30 92]);
add_block('sm_lib/Utilities/Mechanism Configuration', [fname,'/MechConfig'], 'Position', [0 120 30 152]);

add_block('sm_lib/Joints/Revolute Joint', [fname,'/Joint1'], 'Position', [60 60 90 92]);
add_block('sm_lib/Frames and Transforms/Rigid Transform', [fname,'/RT1'], 'Position', [120 60 150 92]);
add_block('sm_lib/Body Elements/Cylindrical Solid', [fname,'/Link1'], 'Position', [180 120 210 120+32]);
add_block('sm_lib/Frames and Transforms/Rigid Transform', [fname,'/RT2'], 'Position', [240 60 240+30 92]);

add_block('sm_lib/Joints/Revolute Joint', [fname,'/Joint2'], 'Position', [300 60 330 92]);
add_block('sm_lib/Frames and Transforms/Rigid Transform', [fname,'/RT3'], 'Position', [360 60 390 92]);
add_block('sm_lib/Body Elements/Cylindrical Solid', [fname,'/Link2'], 'Position', [390 120 420 120+32]);

%% Adding lines
add_line(fname,'WorldFrame/RConn 1','SolverConf/RConn 1','autorouting','on');
add_line(fname,'SolverConf/RConn 1','MechConfig/RConn 1','autorouting','on');
add_line(fname,'SolverConf/RConn 1','Joint1/LConn 1','autorouting','on');
add_line(fname,'Joint1/RConn 1','RT1/LConn 1','autorouting','on');
add_line(fname,'RT1/RConn 1','RT2/LConn 1','autorouting','on');
add_line(fname,'RT1/RConn 1','Link1/RConn 1','autorouting','on');
add_line(fname,'RT2/RConn 1','Joint2/LConn 1','autorouting','on');
add_line(fname,'Joint2/RConn 1','RT3/LConn 1','autorouting','on');
add_line(fname,'RT3/RConn 1','Link2/RConn 1','autorouting','on');


%% Setting parameters
set_param([fname, '/MechConfig'], 'GravityVector', '[-9.80665 0 0]');

set_param([fname, '/Link1'], 'CylinderLength', '0.15', ...
            'CylinderRadius', '0.15/10', 'Density', '2780', ...
            'GraphicDiffuseColor', '[0.2 0.2 1.0]');

set_param([fname, '/Link2'], 'CylinderLength', '0.15', ...
            'CylinderRadius', '0.15/10', 'Density', '2780', ...
            'GraphicDiffuseColor', '[0.2 0.2 1.0]');

set_param([fname, '/RT1'], 'RotationMethod', 'StandardAxis', ...
    'RotationStandardAxis', '+X', 'RotationAngle', '-90', ...
   'TranslationMethod', 'StandardAxis', 'TranslationStandardAxis', '+Y',...
   'TranslationStandardOffset', '0.15/2');

set_param([fname, '/RT2'], 'RotationMethod', 'StandardAxis', ...
    'RotationStandardAxis', '+X', 'RotationAngle', '90', ...
   'TranslationMethod', 'StandardAxis', 'TranslationStandardAxis', '+Z',...
   'TranslationStandardOffset', '0.15/2');

set_param([fname, '/RT3'], 'RotationMethod', 'StandardAxis', ...
    'RotationStandardAxis', '+X', 'RotationAngle', '-90', ...
   'TranslationMethod', 'StandardAxis', 'TranslationStandardAxis', '+Y',...
   'TranslationStandardOffset', '0.15/2');

%% Creating control ports
set_param([fname, '/Joint1'], 'TorqueActuationMode', 'ComputedTorque', ...
    'MotionActuationMode', 'InputMotion');

set_param([fname, '/Joint2'], 'TorqueActuationMode', 'ComputedTorque', ...
    'MotionActuationMode', 'InputMotion');

%% Generating trajectory
StopTime = 15; % simulation time
t = (0:0.1:StopTime); % time
l = 0.15;

phi = 0:(2*pi / size(t,2)):(2*pi - 2*pi / size(t,2));
p = [l / 4 * cos(phi) + l;... % curve
     l / 4 * sin(phi) + l];

r = sqrt(p(1,:).^2 + p(2,:).^2);
theta = [ atan( p(2,:) ./ p(1,:) ); ...
    acos( (p(1,:).^2 + p(2,:).^2 - l^2 - l^2) / (2 * l * l))];

trajp = timeseries(theta.',t.'); % trajectory
%% Adding transfer blocks of trajectory
add_block('simulink/Sources/From Workspace', [fname, '/FrWS'], 'Position', [0 180 50 210]);
add_block('simulink/Commonly Used Blocks/Demux', [fname, '/Demux1'], 'Position', [100 180 105 210]);
add_block('nesl_utility/Simulink-PS Converter', [fname, '/PSC1'], 'Position', [130 170 140 180]);
add_block('nesl_utility/Simulink-PS Converter', [fname, '/PSC2'], 'Position', [130 210 140 220]);

add_line(fname,'FrWS/1', 'Demux1/1', 'autorouting','on');
add_line(fname,'Demux1/1', 'PSC1/1', 'autorouting','on');
add_line(fname,'Demux1/2', 'PSC2/1', 'autorouting','on');
add_line(fname,'PSC1/RConn 1', 'Joint1/LConn 2', 'autorouting','on');
add_line(fname,'PSC2/RConn 1', 'Joint2/LConn 2', 'autorouting','on');

set_param([fname, '/FrWS'], 'VariableName', 'trajp');
set_param([fname, '/PSC1'], 'Unit', 'rad', ...
    'FilteringAndDerivatives', 'filter', ...
    'SimscapeFilterOrder', '2');
set_param([fname, '/PSC2'], 'Unit', 'rad', ...
    'FilteringAndDerivatives', 'filter', ...
    'SimscapeFilterOrder', '2');

%% Modeling
save_system(fname);
sim(fname);

%% Waiting close command
input('Press ENTER to close experiment...');
close_system(fname);
delete([fname, '.slx']);