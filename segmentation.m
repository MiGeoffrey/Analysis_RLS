function segmentation(Layers,F)

% === Parameters ==========================================================

dataDir = [F.Data];

Nuc = false;
prefin = [dataDir 'Files/grey_stack/Image_'];
suffin = '.tif';

dmask = 50;                 % Parameters for the brain mask
sizeRange = [3 200];        % Size filter (pixels)
thCorr = 0.05;              % Correlation filter

% =========================================================================

for layer = Layers
    
    
    clear Img Mask Pre Pos coeff
    % --- Load ---------------------------------------------------------------- 
    if ~exist('Img', 'var')
        D = dir([prefin '*' suffin]);
        Img = double(imread([D(layer-2).folder filesep D(layer-2).name])); 
    end
 
    % --- Mask ----------------------------------------------------------------   
    if ~exist('Mask', 'var')
        try
            tic;load([dataDir, 'Files/signal_stacks/',num2str(layer) ,'/sig.mat']);toc
            Mask = DD.imgref*0;
            Mask(DD.index) = 1;
            Mask(~DD.index) = 0;
            Mask = logical(Mask);figure(100),imshow(Mask);
        catch
            load([F.Files 'signal_stacks/',num2str(layer) ,'/contour.mat'])
            Mask = zeros(F.IP.height, F.IP.width);
            Mask(w)=1;
            imshow(Mask)
        end
    end

    % --- Pre-process ---------------------------------------------------------
    if ~exist('Pre', 'var')
        A = ordfilt2(Img, 5, ones(10));
        B = ordfilt2(Img, 95, ones(10));
        if Nuc
            Pre = (B-Img)./(B-A);
        else
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
        figure(1);imshow(Mem_Wat);hold on;plot(round(pos(:,1)), round(pos(:,2)),'g*');
        
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
    plot(round(pos(:,1)), round(pos(:,2)),'r*');
    
    % --- Display -------------------------------------------------------------
    figure(2);hold on;
    Resc = (Img-min(Img(:)))/(max(Img(:))-min(Img(:)));
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