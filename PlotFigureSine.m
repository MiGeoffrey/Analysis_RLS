%% Path
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
stack_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stackNuc51WithEyes']; % stack of .tif images
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_198layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration
out_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region'];
mkdir([MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region']);
PathBrainCountour = [MainPath, 'RLS/RefBrains/zBrainMask/zBrainContour_x-y-z_RAS_OrigineBottomLeft_MaximumProjection_Outline.tif'];
%% Parameters
BrainRegions = {'Diencephalon -' 'Rhombencephalon - Cerebellum' 'Mesencephalon - Tectum Stratum Periventriculare' ...
                'Rhombencephalon - Inferior Olive' 'Rhombencephalon - Spinal Backfill Vestibular Population' };
            
% brain_regions = {'Diencephalon -' 'Diencephalon - Habenula' 'Mesencephalon - Torus Longitudinalis' 'Rhombencephalon - Cerebellum' 'Rhombencephalon - Inferior Olive' ...
%                 'Rhombencephalon - Oculomotor Nucleus nIV' 'Rhombencephalon - Spinal Backfill Vestibular Population' 'Rhombencephalon - Tangential Vestibular Nucleus' ...
%                 'Rhombencephalon - Valvula Cerebelli' 'Ganglia - Eyes' 'Mesencephalon - NucMLF (nucleus of the medial longitudinal fascicle)' ...
%                 'Mesencephalon - Oculomotor Nucleus nIII', 'Mesencephalon - Tectum Stratum Periventriculare', 'Mesencephalon - Tegmentum', 'Ganglia - Statoacoustic Ganglion'};

%% Add the brain regions selected
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
imstack = uint8(zeros(height, width,3, Zs));
for layer = 1:Zs
    disp(layer)
    % Create an RGB image of the brain regions selected
    img_br = zeros(height, width);
    for br = 1:size(BrainRegions, 2)
        brain_region = find(ismember(MaskDatabaseNames,BrainRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_br(img_brain_region == 1) = 1;
    end
    % Add the brain regions selected to the stack
    img = imread([stack_path, '/layer', num2str(layer, '%02d'), '.tif']);
    img_brain_region_RGB = imrotate(cat(3, img_br, img_br, img_br), 180);
    imgstack(:,:, :, Zs-layer+1) = flip(img, 1);
    img(img_brain_region_RGB == 1) = inf;
    img_grey = imread([grey_stack_path, num2str((layer-1), '%04d'), '.tif']);
    img_grey = cat(3, img_grey, img_grey, img_grey);
    img_grey = img + (uint8(img_grey/(300)) - img);
    imwrite(img_grey, [out_path, '/layer', num2str(layer, '%02d'), '.tif']);
end
%% Countours of the brain regions
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%

for br = 1:size(BrainRegions, 2)
    img_br = zeros(height, width);
    for layer = 1:Zs
        brain_region = find(ismember(MaskDatabaseNames,BrainRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_br(img_brain_region == 1) = 1;
    end
    CountourBrainRegions{br} = bwboundaries(img_br);
end
%% Countours of the brain
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
BrainCountourRegions = {'Diencephalon -' 'Rhombencephalon -' 'Mesencephalon -' 'Spinal Cord' 'Telencephalon -'};
img_br = zeros(height, width);
img_brX = zeros(height, Zs);
img_brX_tmp = zeros(height, Zs);
for br = 1:size(BrainCountourRegions, 2)
    for layer = 1:Zs
        brain_region = find(ismember(MaskDatabaseNames,BrainCountourRegions{br}));
        MaskDatabaseNames(brain_region);
        img_brain_region = MaskDatabaseOutlines(height*width*(layer-1)+1:height*width*(layer),brain_region);
        img_brain_region = reshape(img_brain_region, [height, width]);
        img_brain_region = full(img_brain_region);
        img_br(img_brain_region == 1) = 1;
        img_brX_tmp(:, layer) = max(img_brain_region,[], 2);
    end
    img_brX(img_brX_tmp == 1) = 1;
end
CountourBrain = bwboundaries(img_br);
CountourBrainX = bwboundaries(repelem(img_brX, 1, 2, 1));
%% Phase Map Z-Projection and Left X-Projection
%%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
imgZProj = max(imgstack,[], 4);
imshow(imgZProj);
hold on;

% Plot Brain Countour
C = [CountourBrain{1, 1}];
B = plot(C(:,2),C(:,1));
B.Color = [1,1,1];
B.LineWidth = 2;
B.LineStyle = '-';
clear C;

% Plot Scale bar
x = 540;
y = 1360;
RatioPixMicron = 0.8;
ScaleBar = 50; % Micron
patch([x, x, (x+ScaleBar/0.8), (x+ScaleBar/0.8)], [y, y+10, y+10, y], 'w');
T = text((x+(x+ScaleBar/0.8))/2, y+10, [num2str(ScaleBar), ' μm']);
T.HorizontalAlignment = 'center';
T.Color = 'w';
T.VerticalAlignment = 'top'

% Plot Brain Regions Countours
for br = 1:size(BrainRegions, 2)
    for i = 1:size(CountourBrainRegions{1,br},1)
        C = [CountourBrainRegions{1,br}{i,1}];
        P = plot(C(:,2),C(:,1));
        P.Color = [1,1,1];
        P.LineWidth = 2;
        P.LineStyle = '--';
    end
    clear C;
end
clear C;

%% Phase Map Left X-Projection
%%%%%%%%%%% WARNING: format paper? %%%%%%%%%%%
clf
LeftImgstack = imgstack(:, (1:(width/2)), :, :);
LeftImgstack = permute(LeftImgstack, [4, 1, 3, 2]);
imgXProj = max(LeftImgstack,[], 4);
imgXProj = repelem(imgXProj, 2, 1, 1);
imshow(imrotate(imgXProj, -90));
hold on;

% Plot Brain Countour
C = [CountourBrain{1, 1}];
B = plot(C(:,2),C(:,1));
B.Color = [1,1,1];
B.LineWidth = 2;
B.LineStyle = '-';
clear C;

% Plot Scale bar
x = 540;
y = 1360;
RatioPixMicron = 0.8;
ScaleBar = 50; % Micron
patch([x, x, (x+ScaleBar/0.8), (x+ScaleBar/0.8)], [y, y+10, y+10, y], 'w');
T = text((x+(x+ScaleBar/0.8))/2, y+10, [num2str(ScaleBar), ' μm']);
T.HorizontalAlignment = 'center';
T.Color = 'w';
T.VerticalAlignment = 'top'

% Plot Brain Regions Countours
for br = 1:size(BrainRegions, 2)
    for i = 1:size(CountourBrainRegions{1,br},1)
        C = [CountourBrainRegions{1,br}{i,1}];
        P = plot(C(:,2),C(:,1));
        P.Color = [1,1,1];
        P.LineWidth = 2;
        P.LineStyle = '--';
    end
    clear C;
end
clear C;

