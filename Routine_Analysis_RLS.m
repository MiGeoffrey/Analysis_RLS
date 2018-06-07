%% ----- Routine Analysis RLS -----
addpath('/home/ljp/Science/Projects/RLS/Programs')

%% Parameters
date = '2018-05-22';
run_number = 24;
Layers_stack_ref = [3:10];%Layers used to create the reference stack to perform the drift correction
Layers = [15];
ind_Refstack = 10; % determine index of reference brain scan for drift correction
binsize = 1;
fstim = 0.2;
%% Toolbox

ML.Project % In order to use the Focus from the Raphael's Routine

dcimgToMmapToTif_loop_RLS(date, run_number); % A function which transform the DCIMG file in a Tif stack with the good name!

rename(0,date,run_number, '/media/Dream/RLS/');

Routines.Config(date, run_number);

F = getFocus(date, run_number);

create_contour_RLS(Layers, F, ind_Refstack,binsize);

AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'false');

AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'true');

segmentation(Layers,F,1);

create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack); % 1300 seconds for 18 layers

DFF_bg(Layers,F); % 800 seconds for 18 layers

SaveFor3DViewer(Layers,F);

PhaseMap_pix_RLS_value_normlized(fstim, Layers,F); % 500 seconds for 18 layers

Plot_phase_pix_v3_normalized(0.3, 0, 0.2, Layers, F);

regression_motor(StartLayer,pstim);

cmtk_registration_RLS(F, 'Run18_2018-05-22');

convertCoordinates_RLS(coordinates, xformlist, param3)

%% Workbench

for run_number = [7]
    Routines.Config(date, run_number);
    F = getFocus(date, run_number);
    create_contour_RLS(Layers, F, ind_Refstack,binsize);
end

for run_number = [21]
    F = getFocus(date, run_number);
    AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'false');
    AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, 'true');
    create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack);
    DFF_bg(Layers,F);
end

