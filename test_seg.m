clc

% === Parameters ==========================================================

dataDir = '/home/ljp/Science/Projects/Neurofish/Data/Segmentation/Cytoplasmic/CY44/2017-11-15/Run_06/';
% dataDir = '/home/ljp/Science/Projects/Neurofish/Data/Segmentation/Cytoplasmic/CY44/2018-01-31/Run_03/';
% dataDir = '/home/ljp/Science/Projects/Neurofish/Data/Segmentation/Cytoplasmic/GCamp6f/2018-01-10/Run_03/';
% dataDir = '/home/ljp/Science/Projects/Neurofish/Data/Segmentation/Nuclear/2017-11-29/Run_01/';

Nuc = false;

prefin = [dataDir 'MeanImages/Image_'];
suffin = '.tif';

dmask = 50;                 % Parameters for the brain mask
sizeRange = [3 150];        % Size filter (pixels)
thCorr = 0.05;              % Correlation filter

% =========================================================================

for layer = 10 %1:20
    
    clear Img Mask Pre Pos coeff
    
    % --- Load ----------------------------------------------------------------
    
    if ~exist('Img', 'var')
        
        fprintf('Loading image ...');
        tic
        
        D = dir([prefin '*' suffin]);
        Img = double(imread([D(layer).folder filesep D(layer).name]));
        
%         Img(1:15,:) = 410 + round(3*randn(size(Img(1:15,:))));
%         Img(:,end-5:end) = 410 + round(3*randn(size(Img(:,end-5:end))));
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
%     clf
%     imshow(Img)
%     caxis auto
%     return
    
    % --- Mask ----------------------------------------------------------------
    
    if ~exist('Mask', 'var')
        
        fprintf('computing mask ...');
        tic
        
        Mask = imfill((stdfilt(Img, ones(dmask-1)) >= dmask/2), 'holes');
        Mask = imerode(Mask, ones(dmask/2));
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
    
    % --- Pre-process ---------------------------------------------------------
    
    if ~exist('Pre', 'var')
        
        fprintf('Pre-process ...');
        tic
        
        A = ordfilt2(Img, 5, ones(10));
        B = ordfilt2(Img, 95, ones(10));
        
        if Nuc
            Pre = (B-Img)./(B-A);
        else
            Pre = (Img-A)./(B-A);
        end
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
    
    % --- Watershed -----------------------------------------------------------
    
    if ~exist('Pos', 'var')
        
        fprintf('Watershed\n');
        
        fprintf('\tPreparation ...');
        tic
        
        % Prepare for watershed
        Wat = Pre;
        Wat(~Mask) = Inf;
        
        fprintf(' %.02f sec\n', toc);
        
        fprintf('\tComputing ...');
        tic
        
        L = watershed(Wat);
        
        fprintf(' %.02f sec\n', toc);
        
        fprintf('\tPost-process .');
        tic
        
        R = regionprops(L, {'Centroid', 'Area', 'PixelIdxList'});
        
        Pos = reshape([R(:).Centroid], [2 numel(R)])';
        Area = [R(:).Area];
        Plist = {R(:).PixelIdxList};
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
    % --- Filters -------------------------------------------------------------
    
    if ~exist('coeff', 'var')
        
        fprintf('Filtering\n');
        
        pos = Pos;
        area = Area;
        plist = Plist;
        
        % --- Mask
        
        fprintf('\tMask ...');
        tic
        
        I = Mask(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1))));
        
        area = area(I);
        pos = pos(I,:);
        plist = plist(I);
        
        fprintf(' %.02f sec\n', toc);
        
        % --- Size range
        
        fprintf('\tSize ...');
        tic
        
        I = area>=sizeRange(1) & area<=sizeRange(2);
        area = area(I);
        pos = pos(I,:);
        plist = plist(I);
        
        fprintf(' %.02f sec\n', toc);
        
        
        % --- Correlation
        
        fprintf('\tCorrelation .');
        tic
        
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
        
        fprintf(' %.02f sec\n', toc);
        
    end
    
    % --- Shape extraction ----------------------------------------------------
    
    fprintf('Shape extraction\n');
    
    fprintf('\tWatershed ...');
    tic
    
    Raw = zeros(size(Img));
    Raw(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1)))) = 1;
    Wat = bwdist(Raw);
    L = watershed(Wat);
    
    R = regionprops(L, {'Centroid', 'Area', 'PixelIdxList'});
    
    pos = reshape([R(:).Centroid], [2 numel(R)])';
    area = [R(:).Area];
    plist = {R(:).PixelIdxList};
    
    fprintf(' %.02f sec\n', toc);
    
    fprintf('\tMask ...');
    tic
    
    I = Mask(sub2ind(size(Img), round(pos(:,2)), round(pos(:,1))));
    
    area = area(I);
    pos = pos(I,:);
    plist = plist(I);
    
    fprintf(' %.02f sec\n', toc);
    
    fprintf('\tSize ...');
    tic
    
    I = area>=sizeRange(1) & area<=sizeRange(2);
    area = area(I);
    pos = pos(I,:);
    plist = plist(I);
    
    fprintf(' %.02f sec\n', toc);
    
    % --- Display -------------------------------------------------------------
    
    clf
    hold on
    
    % % % imshow(Img)
    % % % caxis auto
    % % % colorbar
    % % % axis on image
    % % % colormap(gray)
    % % %
    % % % % scatter(pos(:,1), pos(:,2), 'y+');
    % % %
    % % % bins = linspace(0,1,64);
    % % % cm = hot(64);
    % % % for i = 1:numel(bins)-1
    % % %
    % % %     I = coeff>=bins(i) & coeff<bins(i+1);
    % % %
    % % %     scatter(pos(I,1), pos(I,2), 'MarkerFaceColor', cm(i,:), ...
    % % %         'MarkerEdgeColor', 'none');
    % % %
    % % % end
    
    
    Resc = (Img-min(Img(:)))/(max(Img(:))-min(Img(:)));
    % CD = repmat(Resc, [1 1 3]);
    
    Grid = ones(size(Img))*0.8;
    
    for i = 1:numel(plist)
        Grid(plist{i}) = 1;
    end
    CD = cat(3, Resc, Resc.*Grid, Resc);
    
    imshow(CD)
    
    % --- Save ----------------------------------------------------------------
    
    outDir = [dataDir 'Segmented/'];
    
    if ~exist(outDir, 'dir')
        mkdir(outDir)
    end
    imwrite(CD, [dataDir 'Segmented/Layer_' num2str(layer) '.png'])
    
    outname = [outDir 'Layer_' num2str(layer) '.mat'];
    save(outname, 'pos', 'plist');
    
end