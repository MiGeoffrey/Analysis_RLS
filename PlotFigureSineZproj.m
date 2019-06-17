
%% Path
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_178layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration
out_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region'];
FigureOutPath = ['/home/ljp/SSD/RLS/Data/2019-05-17/'];
mkdir(FigureOutPath);


%% Path Brighton
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_198layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration

MainPath = '/media/Dream/home/ljp/SSD/';
out_path = [MainPath, 'Data/AveragedPhaseMaps/stack_brain_region'];
FigureOutPath = [MainPath, 'Data/AveragedPhaseMaps/Figure3Sine/'];
mkdir(FigureOutPath);

%% Crop images
CL = 10; % Crop Left Must be > 0
CR = 5; % Crop Right
CT = 60; % Crop Top  Must be > 0
CB = 270; % Crop Bottom 

%% Figure_4F
% clear stack_path FigureName
% SaveNameFigure = 'PhaseMapAverageZproj';
% stack_path{1} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithEyes']; % stack of .tif images
% FigureName{1} = 'Phase Map Average (n=8)';
% ExpSaturation{1} = 2.5;
% 
% stack_path{2} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithoutEyes']; % stack of .tif images
% FigureName{2} = 'Phase Map Average Enucleated Larvae (n=9)';
% ExpSaturation{2} = 4;
% 
% BrainRegions = {'Mesencephalon - Torus Longitudinalis' ...
%                 'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' ...
%                 'Mesencephalon - Oculomotor Nucleus nIII' ...
%                 'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' ...
%                 'Rhombencephalon - Oculomotor Nucleus nIV' ...
%                 'Rhombencephalon - Spinal Backfill Vestibular Population' ...
%                 'Rhombencephalon - Tangential Vestibular Nucleus' ...
%                 'Rhombencephalon - Rhombomere 1' ...
%                 'Rhombencephalon - Rhombomere 2' ...
%                 'Rhombencephalon - Rhombomere 3' ...
%                 'Rhombencephalon - Rhombomere 4' ...
%                 'Rhombencephalon - Rhombomere 5' ...
%                 'Rhombencephalon - Rhombomere 6' ...
%                 'Rhombencephalon - Rhombomere 7' };
% 
% ColorMap = lines(size(BrainRegions, 2)-7);
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     if i <= (size(BrainRegions, 2)-7)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
%     else
%         BrainRegionsColors{i} = {[0.99 0.99 0.99]};
%         BrainRegionsLineStyle{i} = ':';
%     end
% end
% Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_4D
% clear stack_path FigureName
% SaveNameFigure = 'PhaseMapZprojRun7';
% 
% stack_path{3} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_magenta-green']; % stack of .tif images
% FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
% ExpSaturation{3} = 1.5;
% 
% stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_red-cyan']; % stack of .tif images
% FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
% ExpSaturation{1} = 1.5;
%  
% stack_path{4} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_redmag-cyangreen']; % stack of .tif images
% FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
% ExpSaturation{4} = 1.5;
% 
% stack_path{2} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB_yellow-blue']; % stack of .tif images
% FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
% ExpSaturation{2} = 1.5;
% 
% BrainRegions = {'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_S2
% clear stack_path FigureName
%%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%
% 
% SaveNameFigure = 'PhaseMapAverageZprojMoreRegions';
% stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 07/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{1} = 'Fish 1 (6dpf)';
% ExpSaturation{1} = 1;
% 
% stack_path{2} = [MainPath, 'RLS/Data/2018-05-24/Run 12/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{2} = 'Fish 2 (6dpf)';
% ExpSaturation{2} = ExpSaturation{1};
% 
% stack_path{3} = [MainPath, 'RLS/Data/2018-05-24/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{3} = 'Fish 3 (6dpf)';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{4} = [MainPath, 'RLS/Data/2018-05-24/Run 21/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{4} = 'Fish 4 (6dpf)';
% ExpSaturation{4} = ExpSaturation{1};

% SaveNameFigure = 'PhaseMapAverageZprojMoreRegions_2';
% stack_path{1} = [MainPath, 'RLS/Data/2018-05-24/Run 25/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{1} = 'Fish 5 (6dpf)';
% ExpSaturation{1} = 1;
% 
% stack_path{2} = [MainPath, 'RLS/Data/2018-06-14/Run 15/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{2} = 'Fish 6 (6dpf)';
% ExpSaturation{2} = ExpSaturation{1};
% 
% stack_path{3} = ['/media/RED/Science/Projects/RLS1P/Data/2018-05-25/Run 11/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{3} = 'Fish 7 (7dpf)';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{4} = ['/media/RED/Science/Projects/RLS1P/Data/2018-05-25/Run 15/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{4} = 'Fish 8 (7dpf)';
% ExpSaturation{4} = ExpSaturation{1};
% 
% BrainRegions = {'Diencephalon - Pretectum' ...
%                 'Diencephalon - Ventral Thalamus' ...
%                 'Telencephalon - Pallium' ...
%                 'Telencephalon - Subpallium' ...
%                 'Mesencephalon - Torus Semicircularis' ...
%                 };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% % Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_S3
% clear stack_path FigureName
%%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%

% SaveNameFigure = 'PhaseMapAverageZprojWithoutEyesMoreRegions';
% stack_path{1} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 28/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{1} = 'Fish 1 (6dpf)';
% ExpSaturation{1} = 1.5;
% 
% stack_path{2} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 24/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{2} = 'Fish 2 (6dpf)';
% ExpSaturation{2} = ExpSaturation{1};
% 
% stack_path{3} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-21/Run 09/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{3} = 'Fish 3 (6dpf)';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{4} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-28/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{4} = 'Fish 4 (6dpf)';
% ExpSaturation{4} = ExpSaturation{1};
% 
% SaveNameFigure = 'PhaseMapAverageZprojWithoutEyesMoreRegions_2';
% stack_path{1} = ['/media/RED/Science/Projects/RLS1P/Data/2018-06-28/Run 26/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{1} = 'Fish 5 (6dpf)';
% ExpSaturation{1} = 1.5;
% 
% stack_path{2} = [MainPath, 'RLS/Data/2018-06-11/Run 04/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{2} = 'Fish 6 (5dpf)';
% ExpSaturation{2} = ExpSaturation{1};
% 
% stack_path{3} = [MainPath, 'RLS/Data/2018-06-14/Run 12/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{3} = 'Fish 7 (6dpf)';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{4} = [MainPath, 'RLS/Data/2018-06-14/Run 08/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{4} = 'Fish 8 (6dpf)';
% ExpSaturation{4} = ExpSaturation{1};
% 
% stack_path{5} = [MainPath, 'RLS/Data/2018-06-14/Run 03/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb']; % stack of .tif images
% FigureName{5} = 'Fish 9 (6dpf)';
% ExpSaturation{5} = 2;
% 
% 
% BrainRegions = {'Diencephalon - Pretectum' ...
%                 'Diencephalon - Ventral Thalamus' ...
%                 'Telencephalon - Pallium' ...
%                 'Telencephalon - Subpallium' ...
%                 'Mesencephalon - Torus Semicircularis' ...
%                 };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% % Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_S5A
% clear stack_path FigureName
% %%%%%%%%%%% Plot in two figure beacause of a bug when we save the figure in svg %%%%%%%%%%%
% 
% SaveNameFigure = 'PhaseMapAverageZprojCytoplasmic';
% stack_path{1} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_CytoEyeFreePhaseShifted-0 .07_Figure_S5_2']; % stack of .tif images
% FigureName{1} = 'PhaseMapAverageZprojCytoplasmic';
% ExpSaturation{1} = 7;
% 
% BrainRegions = {'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' ...
%                 };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% % Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_S5B
% clear stack_path FigureName
% SaveNameFigure = 'CytoplasmicPhaseMapAverage4clusters';
% 
% stack_path{3} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/mg2']; % stack of .tif images
% FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
% ExpSaturation{1} = 7;
% 
% stack_path{1} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/rc2']; % stack of .tif images
% FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
% ExpSaturation{2} = ExpSaturation{1};
%  
% stack_path{4} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/rmcg2']; % stack of .tif images
% FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{2} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack/yb2']; % stack of .tif images
% FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
% ExpSaturation{4} = ExpSaturation{1};
% 
% BrainRegions = {'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% %Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

%% Figure_S5C
% clear stack_path FigureName
% SaveNameFigure = 'NuclearWithoutEyesPhaseMapAverage4clusters';
% 
% stack_path{3} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/mg']; % stack of .tif images
% FigureName{3} = 'Phase Map: Pi/2 to 3Pi/4 and 3Pi/2 to 7Pi/4 Phase cluster';
% ExpSaturation{1} = 4;
% 
% stack_path{1} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/rc']; % stack of .tif images
% FigureName{1} = 'Phase Map: 0 to Pi/4 and Pi to 5Pi/4 Phase cluster';
% ExpSaturation{2} = ExpSaturation{1};
%  
% stack_path{4} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/rmcg']; % stack of .tif images
% FigureName{4} = 'Phase Map: 3Pi/4 to Pi and 7Pi/4 to 0 Phase cluster';
% ExpSaturation{3} = ExpSaturation{1};
% 
% stack_path{2} = ['/home/ljp/Science/Projects/RLS/Data/AveragedPhaseMaps/stack_NucWithoutEyes_Figure_S4/yb']; % stack of .tif images
% FigureName{2} = 'Phase Map: Pi/4 to Pi and Pi/2 to 0 Phase cluster';
% ExpSaturation{4} = ExpSaturation{1};
% 
% BrainRegions = {'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% %Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);

% %% Path Multi-Sensory
% clear stack_path FigureName
% SaveNameFigure = 'Figure_MultiSensory';
% 
% %%%%% PhaseMap_1
% stack_path{1} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap1/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB']; % stack of .tif images
% ExpSaturation{1} = 0.7;
% FigureName{1} = '2019-05-16/Run 01: Vestibular';
% 
% %%%%% PhaseMap_2
% stack_path{2} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap2/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB']; % stack of .tif images
% FigureName{2} = '2019-05-16/Run 01: Vestibular and Visual';
% ExpSaturation{2} = ExpSaturation{1};
% 
% %%%%% PhaseMap_3
% stack_path{3} = ['/home/ljp/SSD/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap3/wrap_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_RGB'];
% FigureName{3} = '2019-05-16/Run 01: Visual';
% ExpSaturation{3} = ExpSaturation{1};
% 
% BrainRegions = {'Mesencephalon - Tegmentum' ...
%                 'Mesencephalon - Tectum Stratum Periventriculare' ...
%                 'Diencephalon - Habenula' ...
%                 'Rhombencephalon - Cerebellum' ...
%                 'Rhombencephalon - Inferior Olive' ...
%                 'Mesencephalon - Oculomotor Nucleus nIII' ...
%                 'Rhombencephalon - Tangential Vestibular Nucleus' ....
%                 'Rhombencephalon - Medial Vestibular Nucleus' ...
%                 'Rhombencephalon - Oculomotor Nucleus nIV' ...
%                 'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' };
% 
% ColorMap = lines(size(BrainRegions, 2));
% BrainRegionsColors = cell(1,size(BrainRegions, 2));
% BrainRegionsLineStyle = cell(1,size(BrainRegions, 2));
% for i = 1:size(BrainRegions, 2)
%     BrainRegionsColors{i} = {ColorMap(i,:)};
%     BrainRegionsLineStyle{i} = '-';
% end
% %Subplot parameters
% SBLineNb = 1;
% SBColumnNb = 3*size(stack_path, 2);
%% Path Multi-Sensory
clear stack_path FigureName
SaveNameFigure = 'Figure_MultiSensory_Vest_Visual';

%%%%% PhaseMap_1
stack_path{1} = ['/home/ljp/Science/Projects/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/PhaseMap1_PhaseMap3']; % stack of .tif images
ExpSaturation{1} = 1;
FigureName{1} = '2019-05-17/Run 01: Vestibular';

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
%% Countours of the brain regions
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
CountourBrainRegions = cell(1,size(BrainRegions, 2));
CountourBrainRegionsX = cell(1,size(BrainRegions, 2));
BrainRegionStack = zeros(height, width, 3, Zs);
CountourBrainRegionsStack = cell(size(BrainRegions, 2),Zs);
for br = 1:size(BrainRegions, 2)
    clc;
    disp(['Brain regions: ', num2str(br), '/', num2str(size(BrainRegions, 2))]);
    img_br = zeros(height, width);
    img_brX = zeros(height, Zs);
    for layer = 1:Zs
        brain_region = find(ismember(MaskDatabaseNames,BrainRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_br(img_brain_region == 1) = 1;
        img_brX(:, layer) = max(img_brain_region,[], 2);
    end
    CountourBrainRegions{br} = bwboundaries(img_br);
    CountourBrainRegionsX{br} = bwboundaries(repelem(img_brX, 1, 2, 1));
end
%% Countours of the brain
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
BrainCountourRegions = {'Diencephalon -' 'Rhombencephalon -' 'Mesencephalon -' 'Spinal Cord' 'Telencephalon -'...
                'Mesencephalon - Torus Longitudinalis' ...
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
                'Rhombencephalon - Rhombomere 7' ...
                'Ganglia - Statoacoustic Ganglion'};

img_br = zeros(height, width);
for layer = 1:Zs
    clc
    disp(['Layer: ', num2str(layer), '/', num2str(Zs) ]);
    img_br_tmp = zeros(height, width);
    for br = 1:size(BrainCountourRegions, 2)
        brain_region = find(ismember(MaskDatabaseNames,BrainCountourRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabase(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_br_tmp(flip(img_brain_region,2) == 1) = 1; % Flip2 brain regions
        img_br(img_brain_region == 1) = 1;
    end
end
CountourBrain = bwboundaries(img_br);
disp('Finish Brain Countours')

% X-projection countour
img_brX = zeros(height, Zs);
img_brX_tmp = zeros(height, Zs);
for br = 1:size(BrainCountourRegions, 2)
    clc
    disp(br);
    for layer = 1:Zs
        brain_region = find(ismember(MaskDatabaseNames,BrainCountourRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabase(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_brX_tmp(:, layer) = max(img_brain_region,[], 2);
    end
    img_brX(img_brX_tmp == 1) = 1;
end
CountourBrainX = bwboundaries(repelem(img_brX, 1, 2, 1));
disp('Finish X-projection Brain Countours')
%% Generate figure
clf
%set(0,'DefaultFigureWindowStyle', 'normal');
F1 = figure('Name', 'PhaseMapAverageZproj');
F1.Position = [0,0,(1000*size(stack_path, 2))+(CT+CB),1800/size(stack_path, 2)];
for Exp = 1:size(stack_path, 2)
    %% Add the brain regions selected
    %%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
    imgstack = uint8(zeros(height, width,3, Zs));
    imgGreyStack = uint8(zeros(height, width,3, Zs));
    for layer = 20:Zs
        clc;disp(['Exp ' num2str(Exp) ': layer = ' num2str(layer)])
%         % Create an RGB image of the brain regions selected
%         img_br = zeros(height, width);
%         for br = 1:size(BrainRegions, 2)
%             brain_region = find(ismember(MaskDatabaseNames,BrainRegions{br}));
%             MaskDatabaseNames(brain_region);
%             img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
%             img_brain_region = reshape(img_brain_region, [height, width]);
%             img_brain_region = full(img_brain_region);
%             img_br(img_brain_region == 1) = 1;
%         end
%         % Add the brain regions selected to the stack


       % VB  img = imread([stack_path{Exp}, '/layer', num2str(layer, '%02d'), '.tif']);
     
 %%%%%% Correction to plot the PhaseMap recorded in 2P-mode on RLS2P %%%%%%%%%%%%%%%%%%%%%%%%
                %file = dir([stack_path{Exp}, '/layer', '*.tif']);
                img = imread([stack_path{Exp}, '/Layer', num2str(layer, '%03d') '.tif']) ;
               % img = imtranslate(img, [-20 20]);%  [ rechts oben ]
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        imgstack(:,:, :, Zs-layer+1) = flip(img, 1);
%         img_grey = imread([grey_stack_path, num2str((layer-1), '%04d'), '.tif']);
%         img_grey = cat(3, img_grey, img_grey, img_grey);
%         imgGreyStack(:,:, :, Zs-layer+1) = flip(uint8(img_grey/400), 1);
%         % Save Images 
%         img_grey = img + (uint8(img_grey/(400)) - img);
%         img_brain_region_RGB = imrotate(cat(3, img_br, img_br, img_br), 180);
%         img_grey(flip(img_brain_region_RGB, 2) == 1) = inf;
%         imwrite(img_grey, [out_path, '/layer', num2str(layer, '%02d'), '.tif']);
    end
    %% Plot Grey Stack
    subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
    GreyStackZProj = max(imgGreyStack,[], 4);
    im1 = image(GreyStackZProj(CT:height-CB,CL:width-CR,:));
    axis off;
    hold on;
    subplot(SBLineNb,SBColumnNb,1+3*(Exp-1));
    LeftImgGreystack = imgGreyStack(:, (1:(width/2)), :, :);
    LeftImgGreystack = permute(LeftImgGreystack, [4, 1, 3, 2]);
    GreyStackXProj = max(LeftImgGreystack,[], 4);
    GreyStackXProj = repelem(GreyStackXProj, 2, 1, 1);
    im1 = image(imrotate(GreyStackXProj(:,CT:height-CB,:),-90));
    axis off;
    hold on;
    
    %% Phase Map Z-Projection and Left X-Projection
    %%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
    subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
    imgZProj = max(imgstack,[], 4);
    im2 = image(imgZProj(CT:height-CB,CL:width-CR,:)*ExpSaturation{Exp});
    %im2.AlphaData = max(imgZProj(CT:height-CB,CL:width-CR,:), [], 3)*1.3;
    hold on;
    axis off;
    pbaspect([(size(imgZProj(CT:height-CB,CL:width-CR,:), 2)/size(imgZProj(CT:height-CB,CL:width-CR,:), 1)) 1 1]);
    
    % Plot Brain Countour
    C = [CountourBrain{1, 1}];
    B = plot(C(:,2)-CL,C(:,1)-CT)
    B.Color = [0.99 0.99 0.99];
    B.LineWidth = 2;
    B.LineStyle = '-';
    clear C;
    
    % Plot Scale bar
    x = 540-(CL+CR);
    y = 1360-(CB+CT);
    RatioPixMicron = 0.8;
    ScaleBar = 50; % Micron
    patch([x, x, (x+ScaleBar/RatioPixMicron), (x+ScaleBar/RatioPixMicron)], [y, y+10, y+10, y], 'w');
%     T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
%     T.HorizontalAlignment = 'center';
%     T.Color = [0.99 0.99 0.99];
%     T.VerticalAlignment = 'top';
%     T.LineStyle = '-';
    
    % Plot Brain Regions Countours
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegions{1,br},1)
            C = [CountourBrainRegions{1,br}{i,1}];
            P = plot(C(:,2)-CL,C(:,1)-CT)
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = BrainRegionsLineWidth{br};
            P.LineStyle = BrainRegionsLineStyle{br};
        end
        clear C;
    end
    clear C;
    title(FigureName{Exp})
    
    %% Phase Map Left X-Projection
    %%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
    subplot(SBLineNb,SBColumnNb,1+3*(Exp-1));
    LeftImgstack = imgstack(:, (1:(width/2)), :, :);
    LeftImgstack = permute(LeftImgstack, [4, 1, 3, 2]);
    imgXProj = max(LeftImgstack,[], 4);
    imgXProj = repelem(imgXProj, 2, 1, 1);
    im2 = image((imrotate(imgXProj(:,CT:height-CB,:), -90))*ExpSaturation{Exp});
    %im2.AlphaData = max(imrotate(imgXProj, -90), [], 3)*1.3;
    axis off;
    hold on;
    pbaspect([(size(imgXProj(:,CT:height-CB,:), 1)*(1/0.8)/size(imgXProj(:,CT:height-CB,:), 2)) 1 1]);
    
    % Plot Brain Countour
    C = [CountourBrainX{1, 1}];
    B = plot(C(:,2)-CL,C(:,1)-CT)
    B.Color = [0.99 0.99 0.99];
    B.LineWidth = 2;
    B.LineStyle = '-';
    clear C;
    
    % Plot Scale bar
    x = 10;
    y = 1360-(CB+CT);
    RatioPixMicron = 1;
    ScaleBar = 50; % Micron
    patch([x, x, (x+ScaleBar/RatioPixMicron), (x+ScaleBar/RatioPixMicron)], [y, y+10, y+10, y], 'w');
%     T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
%     T.HorizontalAlignment = 'center';
%     T.Color = [0.99 0.99 0.99];
%     T.VerticalAlignment = 'top';
%     T.LineStyle = '-';
    
    % Plot Brain Regions Countours
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegionsX{1,br},1)
            C = [CountourBrainRegionsX{1,br}{i,1}];
            P = plot(C(:,2)-CL,C(:,1)-CT);
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = BrainRegionsLineWidth{br};
            P.LineStyle = BrainRegionsLineStyle{br};
        end
        clear C;
    end
    clear C;
end
%% Plot Brain Region Name with Color Code
for br = 1:size(BrainRegions, 2) 
    T = text(0, (height-(CT+CB)-500)+br*30, BrainRegions{br});
    T.HorizontalAlignment = 'center';
    T.Color = [BrainRegionsColors{br}{1}];
    T.VerticalAlignment = 'top';
    T.LineStyle = '-';
    T.FontSize = 5;
end

%% Save Figures
% Local
saveas(F1, [FigureOutPath, '/', SaveNameFigure, '.fig']);
saveas(F1, [FigureOutPath, '/',  SaveNameFigure, '.svg']);
%%
