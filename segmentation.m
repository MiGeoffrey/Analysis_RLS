function segmentation(Layers,F, Seg_stack)
%% If refstack = 0 => the stack used for the segmentation is the grey_stack
%% If refstack = 1 => the stack used for the segmentation is the long_exp_stack

% === Parameters ==========================================================

dataDir = [F.Data];
Nuc = true;
if Seg_stack == 0
    prefin = [dataDir 'Files/grey_stack/Image_'];
else
    %     prefin = uigetdir(path);
    %     prefin = [prefin, filesep];
    prefin = [dataDir 'Files/Images/Image_'];
end
suffin = '.tif';

dmask = 50;                 % Parameters for the brain mask
sizeRange = [0 1000];        % Size filter (pixels)
thCorr = 0.05;              % Correlation filter

% =========================================================================

for layer = Layers
    
    
    clear Img Mask Pre Pos coeff
    % --- Load ----------------------------------------------------------------
    if ~exist('Img', 'var')
        D = dir([prefin '*' suffin]);
        Img = imread([D(layer).folder filesep D(layer).name]);
        
    end
    
    % --- Mask ----------------------------------------------------------------
%     if ~exist('Mask', 'var')
%         try
%             tic;load([dataDir, 'Files/signal_stacks/',num2str(layer) ,'/sig.mat']);toc
%             Mask = DD.imgref*0;
%             Mask(DD.index) = 1;
%             Mask(~DD.index) = 0;
%             Mask = logical(Mask);figure(100),imshow(Mask);
%         catch
%             load([F.Files 'signal_stacks/',num2str(layer) ,'/contour.mat'])
%             Mask = zeros(size(Img, 1), size(Img, 2));
%             Mask(w)=1;
%             %imshow(Mask)
%         end
%     end
    
    Mask = Img*0+1;
    % --- Pre-process ---------------------------------------------------------
    if ~exist('Pre', 'var')
        if Nuc
            % Remove the dark parts of the brain (Geoffrey)
            img = imread([D(layer).folder filesep D(layer).name]);
            %figure(2);imshow(rangefilt(Img));
            img(rangefilt(Img) < mean2(rangefilt(Img))) = 0;
            [B, L] = bwboundaries(img);
            Img_cor = Img;
            Img_cor(L == 0) = Inf;
%             figure(3);
%             imshowpair(imrotate(Img*5, 90), imrotate(Img_cor, 90), 'montage');

            Img = double(Img);
            Img(Img_cor == Inf) = Inf;
            A = ordfilt2(Img, 5, ones(10));
            B = ordfilt2(Img, 95, ones(10));
            Pre = (B-Img)./(B-A);
            %Pre(L == 0) = 0;
        else
            Img = double(img);
            A = ordfilt2(Img, 5, ones(10));
            B = ordfilt2(Img, 95, ones(10));
            Pre = (Img-A)./(B-A);
        end
    end
    
    % --- Watershed -----------------------------------------------------------
    if ~exist('Pos', 'var')
        
        Wat = Pre;
        Mask = logical(1-Mask);
        Wat(Mask) = Inf;
        Mask = logical(1-Mask);
        Mem_Wat = Wat;
        Wat(isnan(Wat)) = 0;
        L = watershed(Wat);
        R = regionprops(L, {'Centroid', 'Area', 'PixelIdxList'});
        Pos = reshape([R(:).Centroid], [2 numel(R)])';
        Area = [R(:).Area];
        Plist = {R(:).PixelIdxList};
    end
    
    % --- Filters -------------------------------------------------------------
    if ~exist('coeff', 'var')
        pos = Pos;
        area = Area;
        plist = Plist;
        
        % --- Mask
        I = Mask(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1))));
        area = area(I);
        pos = pos(I,:);
        plist = plist(I);
        
        % --- Size range
        I = area>=sizeRange(1) & area<=sizeRange(2);
        area = area(I);
        pos = pos(I,:);
        plist = plist(I);
        
        % --- Correlation
        Raw = zeros(size(Img));
        Raw(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1)))) = 1;
        
        if Nuc
            Res = -bwdist(Raw);
        else
            Res = bwdist(Raw);
        end
        
        w = 3;
        coeff = NaN(size(pos,1), 1);
        for i = 1:size(pos,1)
            x = round(pos(i,1));
            y = round(pos(i,2));
            Sub = Img(max(y-w,1):min(y+w, size(Img,1)), max(x-w,1):min(x+w, size(Img,2)));
            Sub2 = Res(max(y-w,1):min(y+w, size(Img,1)), max(x-w,1):min(x+w, size(Img,2)));
            coeff(i) = corr2(Sub, Sub2);
            if ~mod(i, round(size(pos,1)/10)), fprintf('.'); end
        end
        
        I = coeff>=thCorr;
        coeff = coeff(I);
        area = area(I);
        pos = pos(I,:);
        plist = plist(I);
        %figure(1);imshow(Img/10000);hold on;%plot(round(pos(:,1)), round(pos(:,2)),'g*');
        
    end
    
    % --- Shape extraction ----------------------------------------------------
    Raw = zeros(size(Img));
    Raw(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1)))) = 1;
    Wat = bwdist(Raw);
    L = watershed(Wat);
    R = regionprops(L, {'Centroid', 'Area', 'PixelIdxList'});
    pos = reshape([R(:).Centroid], [2 numel(R)])';
    area = [R(:).Area];
    plist = {R(:).PixelIdxList};
    I = Mask(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1))));
    area = area(I);
    pos = pos(I,:);
    plist = plist(I);
    I = area>=sizeRange(1) & area<=sizeRange(2);
    area = area(I);
    pos = pos(I,:);
    plist = plist(I);
    
    % --- Mask 2
    Mask_2 = imbinarize(Img_cor);
    Mask_2 = logical(1-Mask_2);
    I = Mask_2(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1))));
    area = area(I);
    pos = pos(I,:);
    plist = plist(I);
    %figure(1);plot(round(pos(:,1)), round(pos(:,2)),'r*');
    
    
%    [idx, idx_] = select_neurons_manually(pos, R);
    
    
    % --- Display -------------------------------------------------------------
    Resc = (Img-min(Img(:)))/(max(Img(:))-min(Img(:)));
    Grid = ones(size(Img))*0.8;
    for i = 1:numel(plist)
        Grid(plist{i}) = 1;
    end
    figure(1);hold on;
    title(['Layer: ' num2str(layer)])
    Img_grid = Img;
    Img_grid(imbinarize(Grid)==0) = max(max(Img));
    Img_cor(Mask == 0) = Inf;
    subplot(1,3,1);
    imshow(imrotate(uint16(Img)*2, 90));    
    subplot(1,3,2);
    imshow(imrotate(Img_cor*2, 90));
    subplot(1,3,3);
    CD = cat(3, Resc, Resc.*Grid, Resc)*1.5;
    imshow(imrotate(CD, 90));
    %imshow(imrotate(uint16(Img_grid)*2, 90));
    %imshowpair(imrotate(uint16(Img)*5, 90), imrotate(Img_cor*7, 90), 'montage');
    pause(1)
    
%     figure(2);hold on;
    %CD = uint16(Img_grid)*5;


    % --- Save ----------------------------------------------------------------
    outDir = [dataDir 'Segmented/'];
    if ~exist(outDir, 'dir')
        mkdir(outDir)
    end
    savefig([outDir, 'Segmentation', num2str(layer)]);
    saveas(gcf, [outDir, 'Segmentation', num2str(layer), '.svg']);
    imwrite(CD, [dataDir 'Segmented/Layer_' num2str(layer) '.tif'])
    outname = [outDir 'Layer_' num2str(layer) '.mat'];
    save(outname, 'pos', 'plist');
    
end