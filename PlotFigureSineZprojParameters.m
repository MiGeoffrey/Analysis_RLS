% Figure_4F
clear stack_path FigureName
SaveNameFigure = 'PhaseMapAverageZproj';
stack_path{1} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithEyes']; % stack of .tif images
FigureName{1} = 'Phase Map Average (n=8)';
ExpSaturation{1} = 2.5;

stack_path{2} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithoutEyes']; % stack of .tif images
FigureName{2} = 'Phase Map Average Enucleated Larvae (n=9)';
ExpSaturation{2} = 4;

BrainRegions = {'Mesencephalon - Torus Longitudinalis' ...
                'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' ...
                'Mesencephalon - Oculomotor Nucleus nIII' ...
                'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' ...
                'Rhombencephalon - Oculomotor Nucleus nIV' ...
                'Rhombencephalon - Spinal Backfill Vestibular Population' ...
                'Rhombencephalon - Tangential Vestibular Nucleus' ...
                'Rhombencephalon - Rhombomere 1' ...
                'Rhombencephalon - Rhombomere 2' ...
                'Rhombencephalon - Rhombomere 3' ...
                'Rhombencephalon - Rhombomere 4' ...
                'Rhombencephalon - Rhombomere 5' ...
                'Rhombencephalon - Rhombomere 6' ...
                'Rhombencephalon - Rhombomere 7' };

ColorMap = lines(size(BrainRegions, 2)-7);
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    if i <= (size(BrainRegions, 2)-7)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
    else
        BrainRegionsColors{i} = {[0.99 0.99 0.99]};
        BrainRegionsLineStyle{i} = ':';
    end
end
Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_4D
clear stack_path FigureName
SaveNameFigure = 'PhaseMapZprojRun7';

stack_path{3} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_magenta-green']; % stack of .tif images
FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
ExpSaturation{3} = 1.5;

stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_red-cyan']; % stack of .tif images
FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
ExpSaturation{1} = 1.5;
 
stack_path{4} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_redmag-cyangreen']; % stack of .tif images
FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
ExpSaturation{4} = 1.5;

stack_path{2} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_yellow-blue']; % stack of .tif images
FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
ExpSaturation{2} = 1.5;

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_S2
clear stack_path FigureName
%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%

SaveNameFigure = 'PhaseMapAverageZprojMoreRegions';
stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{1} = 'Fish 1 (6dpf)';
ExpSaturation{1} = 1;

stack_path{2} = [MainPath, 'RLS/Data/2018-05-24/Run 12/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{2} = 'Fish 2 (6dpf)';
ExpSaturation{2} = ExpSaturation{1};

stack_path{3} = [MainPath, 'RLS/Data/2018-05-24/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{3} = 'Fish 3 (6dpf)';
ExpSaturation{3} = ExpSaturation{1};

stack_path{4} = [MainPath, 'RLS/Data/2018-05-24/Run 21/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{4} = 'Fish 4 (6dpf)';
ExpSaturation{4} = ExpSaturation{1};

SaveNameFigure = 'PhaseMapAverageZprojMoreRegions_2';
stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 25/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{1} = 'Fish 5 (6dpf)';
ExpSaturation{1} = 1;

stack_path{2} = [MainPath, 'RLS/Data/2018-06-14/Run 15/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{2} = 'Fish 6 (6dpf)';
ExpSaturation{2} = ExpSaturation{1};

stack_path{3} = ['/media/RED/Science/Projects/RLS1P/Data/2018-05-25/Run 11/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{3} = 'Fish 7 (7dpf)';
ExpSaturation{3} = ExpSaturation{1};

stack_path{4} = ['/media/RED/Science/Projects/RLS1P/Data/2018-05-25/Run 15/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{4} = 'Fish 8 (7dpf)';
ExpSaturation{4} = ExpSaturation{1};

BrainRegions = {'Diencephalon - Pretectum' ...
                'Diencephalon - Ventral Thalamus' ...
                'Telencephalon - Pallium' ...
                'Telencephalon - Subpallium' ...
                'Mesencephalon - Torus Semicircularis' ...
                };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
% Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_S3
clear stack_path FigureName
%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%

SaveNameFigure = 'PhaseMapAverageZprojWithoutEyesMoreRegions';
stack_path{1} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 28/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{1} = 'Fish 1 (6dpf)';
ExpSaturation{1} = 1.5;

stack_path{2} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 24/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{2} = 'Fish 2 (6dpf)';
ExpSaturation{2} = ExpSaturation{1};

stack_path{3} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 09/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{3} = 'Fish 3 (6dpf)';
ExpSaturation{3} = ExpSaturation{1};

stack_path{4} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-28/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{4} = 'Fish 4 (6dpf)';
ExpSaturation{4} = ExpSaturation{1};

SaveNameFigure = 'PhaseMapAverageZprojWithoutEyesMoreRegions_2';
stack_path{1} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-28/Run 26/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{1} = 'Fish 5 (6dpf)';
ExpSaturation{1} = 1.5;

stack_path{2} = [MainPath, 'RLS/Data/2018-06-11/Run 04/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{2} = 'Fish 6 (5dpf)';
ExpSaturation{2} = ExpSaturation{1};

stack_path{3} = [MainPath, 'RLS/Data/2018-06-14/Run 12/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{3} = 'Fish 7 (6dpf)';
ExpSaturation{3} = ExpSaturation{1};

stack_path{4} = [MainPath, 'RLS/Data/2018-06-14/Run 08/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{4} = 'Fish 8 (6dpf)';
ExpSaturation{4} = ExpSaturation{1};

stack_path{5} = [MainPath, 'RLS/Data/2018-06-14/Run 03/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
FigureName{5} = 'Fish 9 (6dpf)';
ExpSaturation{5} = 2;


BrainRegions = {'Diencephalon - Pretectum' ...
                'Diencephalon - Ventral Thalamus' ...
                'Telencephalon - Pallium' ...
                'Telencephalon - Subpallium' ...
                'Mesencephalon - Torus Semicircularis' ...
                };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
% Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_S5A
clear stack_path FigureName
%%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%

SaveNameFigure = 'PhaseMapAverageZprojCytoplasmic';
stack_path{1} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_CytoEyeFreePhaseShifted-0 .07_Figure_S5_2']; % stack of .tif images
FigureName{1} = 'PhaseMapAverageZprojCytoplasmic';
ExpSaturation{1} = 7;

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' ...
                };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
% Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_S5B
clear stack_path FigureName
SaveNameFigure = 'CytoplasmicPhaseMapAverage4clusters';

stack_path{3} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/mg2']; % stack of .tif images
FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
ExpSaturation{1} = 7;

stack_path{1} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/rc2']; % stack of .tif images
FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
ExpSaturation{2} = ExpSaturation{1};
 
stack_path{4} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/rmcg2']; % stack of .tif images
FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
ExpSaturation{3} = ExpSaturation{1};

stack_path{2} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/yb2']; % stack of .tif images
FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
ExpSaturation{4} = ExpSaturation{1};

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
%Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

% Figure_S5C
clear stack_path FigureName
SaveNameFigure = 'NuclearWithoutEyesPhaseMapAverage4clusters';

stack_path{3} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/mg']; % stack of .tif images
FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
ExpSaturation{1} = 4;

stack_path{1} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/rc']; % stack of .tif images
FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
ExpSaturation{2} = ExpSaturation{1};
 
stack_path{4} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/rmcg']; % stack of .tif images
FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
ExpSaturation{3} = ExpSaturation{1};

stack_path{2} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/yb']; % stack of .tif images
FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
ExpSaturation{4} = ExpSaturation{1};

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
%Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

%% Path Multi-Sensory
clear stack_path FigureName
SaveNameFigure = 'Figure_MultiSensory';

%%%%% PhaseMap_1
stack_path{1} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap1/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB']; % stack of .tif images
ExpSaturation{1} = 0.7;
FigureName{1} = '2019-05-16/Run 01: Vestibular';

%%%%% PhaseMap_2
stack_path{2} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap2/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB']; % stack of .tif images
FigureName{2} = '2019-05-16/Run 01: Vestibular and Visual';
ExpSaturation{2} = ExpSaturation{1};

%%%%% PhaseMap_3
stack_path{3} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap3/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB'];
FigureName{3} = '2019-05-16/Run 01: Visual';
ExpSaturation{3} = ExpSaturation{1};

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' ...
                'Mesencephalon - Oculomotor Nucleus nIII' ...
                'Rhombencephalon - Tangential Vestibular Nucleus' ....
                'Rhombencephalon - Medial Vestibular Nucleus' ...
                'Rhombencephalon - Oculomotor Nucleus nIV' ...
                'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
end
%Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);

%% Path Multi-Sensory
clear stack_path FigureName
SaveNameFigure = 'Figure_MultiSensory_Vest_Visual';

clear stack_path FigureName
stack_path{1} = ['/Users/migault/PhD/Presentations/2019/Toscany/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_Value']; % stack of .tif images
FigureName{1} = 'Response Map';
ExpSaturation{1} = 1;

stack_path{2} = ['/Users/migault/PhD/Presentations/2019/Toscany/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_Left']; % stack of .tif images
FigureName{2} = 'Phase Map Left';
ExpSaturation{2} = ExpSaturation{1};
 
stack_path{3} = ['/Users/migault/PhD/Presentations/2019/Toscany/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_Right']; % stack of .tif images
FigureName{3} = 'Phase Map Right';
ExpSaturation{3} = ExpSaturation{1};

BrainRegions = {'Mesencephalon - Tegmentum' ...
                'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Diencephalon - Habenula' ...
                'Rhombencephalon - Cerebellum' ...
                'Rhombencephalon - Inferior Olive' ...
                'Mesencephalon - Oculomotor Nucleus nIII' ...
                'Rhombencephalon - Tangential Vestibular Nucleus' ....
                'Rhombencephalon - Medial Vestibular Nucleus' ...
                'Rhombencephalon - Oculomotor Nucleus nIV' ...
                'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' };

ColorMap = lines(size(BrainRegions, 2));
BrainRegionsColors = cell(1,size(BrainRegions, 2));
BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
    BrainRegionsLineStyle{i} = '-';
    BrainRegionsLineWidth{i} = 2;
end
%Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);