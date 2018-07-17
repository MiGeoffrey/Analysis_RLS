%% Path
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_198layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration
out_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region'];
FigureOutPath = [MainPath, 'RLS/Data/AveragedPhaseMaps/Figure3Sine/'];
mkdir(FigureOutPath);

clear stack_path FigureName
stack_path{1} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithEyes']; % stack of .tif images
FigureName{1} = 'Phase Map Average With Eyes (n=6)';
ExpSaturation{1} = 1;

stack_path{2} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithoutEyes']; % stack of .tif images
FigureName{2} = 'Phase Map Average Without Eyes (n=9)';
ExpSaturation{2} = 2;
 
%stack_path{3} = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithEyesFree']; % stack of .tif images
%FigureName{3} = 'PhaseMapAverageWithEyesFree';

%% Parameters
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
                'Rhombencephalon - Rhombomere 7' ...
                'Ganglia - Statoacoustic Ganglion'};
ColorMap = lines(size(BrainRegions, 2));
for i = 1:size(BrainRegions, 2)
    BrainRegionsColors{i} = {ColorMap(i,:)};
end

% brain_regions = {'Diencephalon -' 'Diencephalon - Habenula' 'Mesencephalon - Torus Longitudinalis' 'Rhombencephalon - Cerebellum' 'Rhombencephalon - Inferior Olive' ...
%                 'Rhombencephalon - Oculomotor Nucleus nIV' 'Rhombencephalon - Spinal Backfill Vestibular Population' 'Rhombencephalon - Tangential Vestibular Nucleus' ...
%                 'Rhombencephalon - Valvula Cerebelli' 'Ganglia - Eyes' 'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' ...
%                 'Mesencephalon - Oculomotor Nucleus nIII', 'Mesencephalon - Tectum Stratum Periventriculare', 'Mesencephalon - Tegmentum', 'Ganglia - Statoacoustic Ganglion'};

%% Subplot parameters
SBLineNb = 1;
SBColumnNb = 3*size(stack_path, 2);
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
F1.Position = [0,0,(1000*size(stack_path, 2)),1000];
for Exp = 1:size(stack_path, 2)
    %% Add the brain regions selected
    %%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
    imgstack = uint8(zeros(height, width,3, Zs));
    imgGreyStack = uint8(zeros(height, width,3, Zs));
    for layer = 1:Zs
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
        img = imread([stack_path{Exp}, '/layer', num2str(layer, '%02d'), '.tif']);
        imgstack(:,:, :, Zs-layer+1) = flip(img, 1);
        img_grey = imread([grey_stack_path, num2str((layer-1), '%04d'), '.tif']);
        img_grey = cat(3, img_grey, img_grey, img_grey);
        imgGreyStack(:,:, :, Zs-layer+1) = flip(uint8(img_grey/400), 1);
%         % Save Images 
%         img_grey = img + (uint8(img_grey/(400)) - img);
%         img_brain_region_RGB = imrotate(cat(3, img_br, img_br, img_br), 180);
%         img_grey(flip(img_brain_region_RGB, 2) == 1) = inf;
%         imwrite(img_grey, [out_path, '/layer', num2str(layer, '%02d'), '.tif']);
    end
    %% Plot Grey Stack
    subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
    GreyStackZProj = max(imgGreyStack,[], 4);
    im1 = image(GreyStackZProj);
    axis off;
    hold on;
    subplot(SBLineNb,SBColumnNb,1+3*(Exp-1));
    LeftImgGreystack = imgGreyStack(:, (1:(width/2)), :, :);
    LeftImgGreystack = permute(LeftImgGreystack, [4, 1, 3, 2]);
    GreyStackXProj = max(LeftImgGreystack,[], 4);
    GreyStackXProj = repelem(GreyStackXProj, 2, 1, 1);
    im1 = image(imrotate(GreyStackXProj,-90));
    axis off;
    hold on;
    
    %% Phase Map Z-Projection and Left X-Projection
    %%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
    subplot(SBLineNb,SBColumnNb,2+3*(Exp-1):3+3*(Exp-1));
    imgZProj = max(imgstack,[], 4);
    im2 = image(imgZProj*ExpSaturation{Exp});
    %im2.AlphaData = max(imgZProj, [], 3)*1.3;
    hold on;
    axis off;
    pbaspect([(width/height) 1 1]);
    
    % Plot Brain Countour
    C = [CountourBrain{1, 1}];
    B = plot(C(:,2),C(:,1));
    B.Color = [0.99 0.99 0.99];
    B.LineWidth = 2;
    B.LineStyle = '-';
    clear C;
    
    % Plot Scale bar
    x = 540;
    y = 1360;
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
            P = plot(C(:,2),C(:,1));
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 1;
            P.LineStyle = '-';
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
    im2 = image(imrotate(imgXProj, -90)*ExpSaturation{Exp});
    %im2.AlphaData = max(imrotate(imgXProj, -90), [], 3)*1.3;
    axis off;
    hold on;
    pbaspect([(size(imgXProj, 1)*(1/0.8)/size(imgXProj, 2)) 1 1]);
    
    % Plot Brain Countour
    C = [CountourBrainX{1, 1}];
    B = plot(C(:,2),C(:,1));
    B.Color = [0.99 0.99 0.99];
    B.LineWidth = 2;
    B.LineStyle = '-';
    clear C;
    
    % Plot Scale bar
    x = 10;
    y = 1360;
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
            P = plot(C(:,2),C(:,1));
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 1;
            P.LineStyle = '-';
        end
        clear C;
    end
    clear C;
end
%% Save Figures
% Local
saveas(F1, [FigureOutPath, '/', 'PhaseMapAverageZproj', '.fig']);
saveas(F1, [FigureOutPath, '/',  'PhaseMapAverageZproj', '.svg']);
% Nextcloud
saveas(F1, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/', 'PhaseMapAverageZproj', '.fig']);
saveas(F1, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/',  'PhaseMapAverageZproj'], 'svg');