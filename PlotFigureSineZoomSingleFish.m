%% Path
MainPath = '/home/ljp/Science/Projects/';
load([MainPath, 'RLS/Tools/zBrain/MaskDatabase.mat']); % Load the zbrain MaskDatabase.mat file which is in the tools file
grey_stack_path = [MainPath, 'RLS/Data/RefBrains/zBrain_Elavl3-H2BRFP_198layers/zBrain_Elavl3-H2BRFP_198layers']; % The stack used for the registration
out_path = [MainPath, 'RLS/Data/AveragedPhaseMaps/stack_brain_region'];
FigureOutPath = [MainPath, 'RLS/Data/AveragedPhaseMaps/Figure3Sine/'];
mkdir(FigureOutPath);

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
        img_br(flip(img_brain_region,2) == 1) = 1;
        img_br2 = zeros(height, width);
        img_br2((img_brain_region) == 1) = 1;
        CountourBrainRegionsStack{br, Zs-layer+1} = bwboundaries(img_br2);
        img_brX(:, layer) = max(img_brain_region,[], 2);
    end
    CountourBrainRegions{br} = bwboundaries(img_br);
    CountourBrainRegionsX{br} = bwboundaries(repelem(img_brX, 1, 2, 1));
end

%% Countours of the brain
%%%%%%%%%%% WARNING: format RAS %%%%%%%%%%%
BrainCountourRegions = {'Diencephalon -' 'Rhombencephalon -' 'Mesencephalon -' 'Spinal Cord' 'Telencephalon -'};
img_br = zeros(height, width);
img_br_stack = zeros(height, width, Zs);
CountourBrainStack = cell(1,Zs);
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
        img_br_tmp(img_brain_region == 1) = 1;
        img_br(img_brain_region == 1) = 1;
    end
    se = strel('line',10,10);
    img_br_stack(:,:,layer) = imdilate(img_br_tmp,se);
    CountourBrainStack{Zs-layer+1} = bwboundaries(imdilate(img_br_tmp,se), 'noholes');
end
CountourBrain = bwboundaries(img_br);
disp('Finish Brain Countours')

%% Phase Map Run 07
PathPhaseMapRun07 = [MainPath, 'RLS/', 'Data/2018-05-24/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_rgb'];
PathGreyStackRun07 = [MainPath, 'RLS/', 'Data/2018-05-24/Run 16/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/WARP_graystack_ON_zBrain_Elavl3-H2BRFP_198layers.nrrd']; 
%% Load the grey stack of the Run 7
imgGreyStacktmp = flip(uint16(nrrdread(PathGreyStackRun07)),1);
imgGreyStackR7 = uint16(zeros(height, width,3, Zs));
for i = 1:Zs
    imgGreyStackR7(:,:,:,i) = cat(3, imgGreyStacktmp(:,:,i), imgGreyStacktmp(:,:,i), imgGreyStacktmp(:,:,i));
end
%% Load the phase map stack of the Run 7
    imgstack = uint8(zeros(height, width,3, Zs));
    for layer = 1:Zs
        disp(layer)
        img = imread([PathPhaseMapRun07, '/layer', num2str(layer, '%02d'), '.tif']);
        imgstack(:,:, :, Zs-layer+1) = flip(img, 1);
    end
%% Plot Layers of the Run7 with brain regions
clf
F2 = figure('Name', 'PhaseMapSingleFish');
F2.Position = [0,0,600,1500];
It = 1;
layerSelected = [30,35,40,47,54,63,69,75,81]%(35:5:75);
for layer = layerSelected
    disp(layer);
    subplot(size(layerSelected, 2)/3, 3, It)
    
    % Plot Grey Stack
    image(rescalegd2(imgGreyStackR7(:,:,:,Zs-layer+1)-mean2(imgGreyStackR7(:,:,:,Zs-69+1)*(1+layer/70))));
    %hold on;
    
    % Plot Phase map
    Im3 = image(imgstack(:,:,:,layer));
    %Im3.AlphaData = max(imgstack(:,:,:,layer), [], 3)*1.3;
    title(['Layer number ', num2str(layer)]);
    axis off
    hold on;
    pbaspect([(size(imgGreyStackR7(:,:,:,layer), 2)/size(imgGreyStackR7(:,:,:,layer), 1)) 1 1]);
    
    % Plot Brain Regions
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegionsStack{br,layer},1)/2
            clear C
            C = [CountourBrainRegionsStack{br,layer}{i,1}];
            P = plot(C(:,2),C(:,1));
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 0.5;
            P.LineStyle = '-';
        end
    end
    
    % Plot Scale bar
    x = 540;
    y = 1360;
    RatioPixMicron = 0.8;
    ScaleBar = 50; % Micron
    patch([x, x, (x+ScaleBar/RatioPixMicron), (x+ScaleBar/RatioPixMicron)], [y, y+15, y+15, y], 'w');
    T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
    T.HorizontalAlignment = 'center';
    T.Color = [0.99 0.99 0.99];
    T.VerticalAlignment = 'top';
    T.FontSize = 2;
    T.LineStyle = '-';
    
    % Plot Brain Countour
    for i = 1:size(CountourBrainStack{layer},1)
        C = [CountourBrainStack{layer}{i}];
        P = plot(C(:,2),C(:,1));
        P.Color = [0.99 0.99 0.99];
        P.LineWidth = 1;
        P.LineStyle = '-';
    end
    
    It = It + 1;
end

%% Save Figures
% Local
saveas(F2, [FigureOutPath, '/', 'PhaseMapSingleFishR16', '.fig']);
saveas(F2, [FigureOutPath, '/',  'PhaseMapSingleFishR16', '.svg']);
% Nextcloud
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/', 'PhaseMapSingleFishR16', '.fig']);
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/',  'PhaseMapSingleFishR16'], 'svg');

%% Select the ROI Zoom in of the Run7 with it gray stack
layerSelected = [30,35,40,47,54,63,69,75,81];
RectCorner = [100, 400, 300, 300];
Rect = cell(1,Zs);
ROIZoomStack = cell(1,Zs);
try
    load()
catch
    Positions = cell(1,Zs);
    for layer = layerSelected 
    figure(2)
    imshow(imgstack(:,:,:,layer)); 
    Rect{layer} = imrect(gca, [RectCorner(1) RectCorner(2) RectCorner(3) RectCorner(4)]);
    Positions{layer} = round(Rect{layer}.wait)
    end
    %save([FigureOutPath, '/', 'PositionROI', '.mat'],);
end
for layer = layerSelected 
    ROIZoomStack{layer} = imgstack( (Positions{layer}(2):Positions{layer}(2)+Positions{layer}(4)) , (Positions{layer}(1):Positions{layer}(1)+Positions{layer}(3)) ,:,layer);
    ROIZoomGreyStack{layer} = imgGreyStackR7( (Positions{layer}(2):Positions{layer}(2)+Positions{layer}(4)) , (Positions{layer}(1):Positions{layer}(1)+Positions{layer}(3)) ,:,Zs-layer+1);
end
%% Plot the ROI Zoom in of the Run7 with it gray stack
F2 = figure('Name', 'PhaseMapSingleFishROI');
F2.Position = [0,0,700,1500];   
It = 1;
for layer = layerSelected
    % Plot Grey Stack and Phase Map ROI
    P = subplot(size(layerSelected,2)/3,3,It);
    image(rescalegd2( ROIZoomGreyStack{layer} ));
    pbaspect([(size(ROIZoomGreyStack{layer}, 2)/size(ROIZoomGreyStack{layer}, 1)) 1 1]);
    axis off
    hold on;
    Im3 = image(ROIZoomStack{layer});
    Im3.AlphaData = max(ROIZoomStack{layer}, [], 3)*1.3;
    axis off
    hold on;
    
    % Plot Scale bar
    x = size(ROIZoomStack{layer},2)-30;
    y = size(ROIZoomStack{layer},1)-10;
    RatioPixMicron = 0.8;
    ScaleBar = 20; % Micron
    patch([x, x, (x+ScaleBar/RatioPixMicron), (x+ScaleBar/RatioPixMicron)], [y, y+5, y+5, y], 'w');
    T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
    T.HorizontalAlignment = 'center';
    T.Color = [0.99 0.99 0.99];
    T.VerticalAlignment = 'top';
    T.FontSize = 2;
    T.LineStyle = '-';
    
    It = It + 1;
end
%% Save Figures
% Local
saveas(F2, [FigureOutPath, '/', 'PhaseMapSingleFishROI', '.fig']);
saveas(F2, [FigureOutPath, '/',  'PhaseMapSingleFishROI', '.svg']);
% Nextcloud
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/', 'PhaseMapSingleFishROI', '.fig']);
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/',  'PhaseMapSingleFishROI'], 'svg');

%% Plot the ROI Rectangle on the figure "PhaseMapSingleFish"
clf
F2 = figure('Name', 'PhaseMapSingleFish');
F2.Position = [0,0,600,1500];
It = 1;
layerSelected = [30,35,40,47,54,63,69,75,81]%(35:5:75);
for layer = layerSelected
    disp(layer);
    subplot(size(layerSelected, 2)/3, 3, It)
    
    % Plot Grey Stack
    image(rescalegd2(imgGreyStackR7(:,:,:,Zs-layer+1)-mean2(imgGreyStackR7(:,:,:,Zs-69+1)*(1+layer/70))));
    %hold on;
    
    % Plot Phase map
    Im3 = image(imgstack(:,:,:,layer));
    %Im3.AlphaData = max(imgstack(:,:,:,layer), [], 3)*1.3;
    title(['Layer number ', num2str(layer)]);
    axis off
    hold on;
    pbaspect([(size(imgGreyStackR7(:,:,:,layer), 2)/size(imgGreyStackR7(:,:,:,layer), 1)) 1 1]);
    
    % Plot Brain Regions
    for br = 1:size(BrainRegions, 2)
        for i = 1:size(CountourBrainRegionsStack{br,layer},1)/2
            clear C
            C = [CountourBrainRegionsStack{br,layer}{i,1}];
            P = plot(C(:,2),C(:,1));
            P.Color = [BrainRegionsColors{br}{1}];
            P.LineWidth = 0.5;
            P.LineStyle = '-';
        end
    end
    
    % Plot Scale bar
    x = 540;
    y = 1360;
    RatioPixMicron = 0.8;
    ScaleBar = 50; % Micron
    patch([x, x, (x+ScaleBar/RatioPixMicron), (x+ScaleBar/RatioPixMicron)], [y, y+15, y+15, y], 'w');
    T = text((x+(x+ScaleBar/RatioPixMicron))/2, y+10, [num2str(ScaleBar), ' μm']);
    T.HorizontalAlignment = 'center';
    T.Color = [0.99 0.99 0.99];
    T.VerticalAlignment = 'top';
    T.FontSize = 3;
    T.LineStyle = '-';
    
    % Plot Brain Countour
    for i = 1:size(CountourBrainStack{layer},1)
        C = [CountourBrainStack{layer}{i}];
        P = plot(C(:,2),C(:,1));
        P.Color = [0.99 0.99 0.99];
        P.LineWidth = 1;
        P.LineStyle = '-';
    end
    
    % Plot Rectangle of the ROI
    if size(ROIZoomStack{layer}, 2) > 0
        disp('hello')
        P = rectangle('Position',Positions{layer})
        P.EdgeColor = [0.99 0.99 0.99];
        P.LineWidth = 0.5;
        P.LineStyle = ':';
    end
    It = It + 1;
end
%% Save Figures
% Local
saveas(F2, [FigureOutPath, '/', 'PhaseMapSingleFishRectROI', '.fig']);
saveas(F2, [FigureOutPath, '/',  'PhaseMapSingleFishRectROI', '.svg']);
% Nextcloud
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/', 'PhaseMapSingleFishRectROI', '.fig']);
saveas(F2, ['/home/ljp/Nextcloud/Migault et al/CurrentBiology/Figure_3_CB/Review', '/',  'PhaseMapSingleFishRectROI'], 'svg');


