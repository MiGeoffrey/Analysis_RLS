%% Path
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_198layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration
out_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region'];
FigureOutPath = [MainPath, 'RLS/Data/AveragedPhaseMaps/Figure3Sine/'];
mkdir(FigureOutPath);

%% Crop images
CL = 1%10; % Crop Left Must be > 0
CR = 0%5; % Crop Right
CT = 60; % Crop Top  Must be > 0
CB = 270; % Crop Bottom 

%% Figure Phase Map Average Zpro
% clear stack_path FigureName
% SaveNameFigure = 'Step_BrainCountours';
% stack_path{1,1} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/example_xy_raw.tiff']; % stack of .tif images
% stack_path{1,2} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/example_yz_raw.tiff'];
% FigureName{1} = 'Run 08 (24-05-2018)';
% ExpSaturation{1} = 1;
% 
% stack_path{2,1} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/average_witheyes_xy_raw.tiff']; % stack of .tif images
% stack_path{2,2} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/average_witheyes_yz_raw.tiff']; % stack of .tif images
% FigureName{2} = 'Average';
% ExpSaturation{2} = 1;
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

%% Figure Phase Map Average Zpro
clear stack_path FigureName
SaveNameFigure = 'Step_BrainCountours_WithoutEyes';
stack_path{1,1} = ['/home/ljp/Science/Projects/RLS/Data/2017-02-08/Run 08/Analysis/StepROIRun08.tif']; % stack of .tif images
stack_path{1,2} = ['/home/ljp/Science/Projects/RLS/Data/2017-02-08/Run 08/Analysis/StepROIRun08.tif'];
%stack_path{1,1} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/average_withouteyes_xy_raw.tiff']; % stack of .tif images
%stack_path{1,2} = ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_5_CB/Review/average_withouteyes_yz_raw.tiff'];
FigureName{1} = 'Run 08 (24-05-2018)';
ExpSaturation{1} = 1;

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
%% Figure Phase Map Zproj Run7
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

%% Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 1);
%% Countours of the brain regions
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
CountourBrainRegions = cell(1,size(BrainRegions, 2));
CountourBrainRegionsX = cell(1,size(BrainRegions, 2));
BrainRegionStack = zeros(height, width, 3, Zs);
CountourBrainRegionsStack = cell(size(BrainRegions, 2),Zs);
for br = 1:size(BrainRegions, 2)
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
    disp(layer);
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

%%
clf
%set(0,'DefaultFigureWindowStyle', 'normal');
F1 = figure('Name', 'PhaseMapAverageZproj');
F1.Position = [0,0,(1000*size(stack_path, 2))+(CT+CB),800];
for Exp = 1:size(stack_path, 1)
%     %% Add the brain regions selected
%     %%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
%     imgstack = uint8(zeros(height, width,3, Zs));
%     imgGreyStack = uint8(zeros(height, width,3, Zs));
%     for layer = 1:Zs
%         clc;disp(['Exp ' num2str(Exp) ': layer = ' num2str(layer)])
% %         % Create an RGB image of the brain regions selected
% %         img_br = zeros(height, width);
% %         for br = 1:size(BrainRegions, 2)
% %             brain_region = find(ismember(MaskDatabaseNames,BrainRegions{br}));
% %             MaskDatabaseNames(brain_region);
% %             img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
% %             img_brain_region = reshape(img_brain_region, [height, width]);
% %             img_brain_region = full(img_brain_region);
% %             img_br(img_brain_region == 1) = 1;
% %         end
% %         % Add the brain regions selected to the stack
%         img = imread([stack_path{Exp}, '/layer', num2str(layer, '%02d'), '.tif']);
%         imgstack(:,:, :, Zs-layer+1) = flip(img, 1);
%         img_grey = imread([grey_stack_path, num2str((layer-1), '%04d'), '.tif']);
%         img_grey = cat(3, img_grey, img_grey, img_grey);
%         imgGreyStack(:,:, :, Zs-layer+1) = flip(uint8(img_grey/400), 1);
% %         % Save Images 
% %         img_grey = img + (uint8(img_grey/(400)) - img);
% %         img_brain_region_RGB = imrotate(cat(3, img_br, img_br, img_br), 180);
% %         img_grey(flip(img_brain_region_RGB, 2) == 1) = inf;
% %         imwrite(img_grey, [out_path, '/layer', num2str(layer, '%02d'), '.tif']);
%     end
     %% Plot Grey Stack
%     subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
%     GreyStackZProj = max(imgGreyStack,[], 4);
%     im1 = image(GreyStackZProj(CT:height-CB,CL:width-CR,:));
%     axis off;
%     hold on;
%     subplot(SBLineNb,SBColumnNb,1+3*(Exp-1));
%     LeftImgGreystack = imgGreyStack(:, (1:(width/2)), :, :);
%     LeftImgGreystack = permute(LeftImgGreystack, [4, 1, 3, 2]);
%     GreyStackXProj = max(LeftImgGreystack,[], 4);
%     GreyStackXProj = repelem(GreyStackXProj, 2, 1, 1);
%     im1 = image(imrotate(GreyStackXProj(:,CT:height-CB,:),-90));
%     axis off;
%     hold on;
    
    %% Phase Map Z-Projection and Left X-Projection
    %%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
    subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
    imgZProj = imread(stack_path{Exp,1});
    imgZProj = imgZProj(:,:,1:3);
    im2 = image(imgZProj(CT:height-CB,CL:width-CR,:))    %im2.AlphaData = max(imgZProj(CT:height-CB,CL:width-CR,:), [], 3)*1.3;
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
    T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
    T.HorizontalAlignment = 'center';
    T.Color = [0.99 0.99 0.99];
    T.VerticalAlignment = 'top';
    T.LineStyle = '-';
    
    % Plot Brain Regions Countours
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegions{1,br},1)
            C = [CountourBrainRegions{1,br}{i,1}];
            P = plot(C(:,2)-CL,C(:,1)-CT)
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 1.5;
            P.LineStyle = BrainRegionsLineStyle{br};
        end
        clear C;
    end
    clear C;
    title(FigureName{Exp})
    
    %% Phase Map Left X-Projection
    %%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
    subplot(SBLineNb,SBColumnNb,1+3*(Exp-1));
    imgXProj = imread(stack_path{Exp,2});
    imgXProj = (imgXProj(:,:,1:3));
    im2 = image(imrotate(imgXProj(:,CT:height-CB,:), -90));
    %im2.AlphaData = max(imrotate(imgXProj, -90), [], 3)*1.3;
    axis off;
    hold on;
    pbaspect([((size(imgXProj(:,CT:height-CB,:), 1)*(1/0.8))/size(imgXProj(:,CT:height-CB, :), 2)) 1 1]);
    
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
    T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
    T.HorizontalAlignment = 'center';
    T.Color = [0.99 0.99 0.99];
    T.VerticalAlignment = 'top';
    T.LineStyle = '-';
    
    % Plot Brain Regions Countours
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegionsX{1,br},1)
            C = [CountourBrainRegionsX{1,br}{i,1}];
            P = plot(C(:,2)-CL,C(:,1)-CT);
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 1.5;
            P.LineStyle = BrainRegionsLineStyle{br};
        end
        clear C;
    end
    clear C;
end
% %% Plot Brain Region Name with Color Code
% for br = 1:size(BrainRegions, 2) 
%     T = text(0, (height-(CT+CB)-500)+br*30, BrainRegions{br});
%     T.HorizontalAlignment = 'center';
%     T.Color = [BrainRegionsColors{br}{1}];
%     T.VerticalAlignment = 'top';
%     T.LineStyle = '-';
%     T.FontSize = 5;
% end

%% Save Figures
% Local
saveas(F1, [FigureOutPath, '/', SaveNameFigure, '.fig']);
saveas(F1, [FigureOutPath, '/',  SaveNameFigure, '.svg']);
% Nextcloud
saveas(F1, ['/home/ljp/Nextcloud/ForGeoffrey/Manuscript/Migault et al/CurrentBiology/Figure_5_CB/Review', '/', SaveNameFigure, '.fig']);
saveas(F1, ['/home/ljp/Nextcloud/ForGeoffrey/Manuscript/Migault et al/CurrentBiology/Figure_5_CB/Review', '/',  SaveNameFigure], 'svg');
%%
