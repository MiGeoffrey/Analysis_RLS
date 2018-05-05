%% ----- Routine Analysis RLS -----
addpath('/home/ljp/Science/Projects/RLS/Programs')

%% Parameters
date = '2018-01-31';
run_number = 6;
Layers_stack_ref = [10:12];%Layers used to create the reference stack to perform the drift correction
Layers = [3:20];
ind_Refstack = 10; % determine index of reference brain scan for drift correction
binsize = 1;
%%

rename(0,date,run_number, '/media/Dream/RLS/');

Routines.Config(date, run_number);

F = getFocus(date, run_number);

create_contour_RLS(Layers, F, ind_Refstack,binsize);

AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'false');

AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'true');

segmentation(Layers,F);

create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack);

DFF_bg(Layers,F);

SaveFor3DViewer(Layers,F);

%%
run_number = 6;
F = getFocus(date, run_number);
F
create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack);
F
DFF_bg(Layers,F);

run_number = 8;
F = getFocus(date, run_number);
F
create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack);
F
DFF_bg(Layers,F);
