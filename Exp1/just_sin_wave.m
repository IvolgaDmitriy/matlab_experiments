%%  Creating simple Simulink Model via Matlab script
%   Author: Ivolga Dmitriy
%   Version: 1.0

%% Creating file
fname = 'test_system';

%Check if the file already exists
if exist(fname, 'file') == 4   

    if bdIsLoaded(fname)
        close_system(fname,0);
    end

    delete([fname, '.mdl']);    
end

new_system(fname);
set_param(fname, 'Solver', 'ode15s', 'StopTime', '15');
open_system(fname);

%% Adding block
add_block('simulink/Sinks/Scope', [fname,'/MyScope'], 'Position', [350 94 380 126]);
add_block('simulink/Sources/Sine Wave', [fname, '/MySin'], 'Position', [200 94 230 126]);
add_block('simulink/Commonly Used Blocks/Gain', [fname, '/MyGain'], 'Position', [275 94 305 126]);

add_line(fname,'MySin/1','MyGain/1','autorouting','on');
add_line(fname,'MyGain/1','MyScope/1','autorouting','on');

%% Setting parameters
set_param([fname,'/MySin'], 'Amplitude', '10', 'Frequency', '60');
set_param([fname,'/MyGain'], 'Gain', '1/10');

%% Modeling
save_system(fname);
sim(fname);
open_system([fname, '/MyScope']);

%% Waiting close command
input('Press any key to close experiment...');
close_system(fname);
