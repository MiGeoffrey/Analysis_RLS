
%% 138 Layers
MainPath = ('/Users/Projects/RLS/Data');
Path = ('/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers');
Path1 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_3/PhaseMap_Value']; % Visual
Path2 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_Value']; % Vestibular
Path3 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_2/PhaseMap_Value']; % Multi
layers = 1:138;
Thresh = 100;
%% 23 Layers
MainPath = ('/Users/Projects/RLS/Data');
Path = ('/2019-05-17/Run 01/Analysis');
Path1 = [MainPath, Path, '/PhaseMap_3/signal/pixel/amplitude.stack/Stack']; % Visual
Path2 = [MainPath, Path, '/PhaseMap/signal/pixel/amplitude.stack/Stack']; % Vestibular
Path3 = [MainPath, Path, '/PhaseMap_2/signal/pixel/amplitude.stack/Stack']; % Multi
layers = 0:23;
Thresh = 5;
Thresh2 = 100;
%% Visual and Vestibular
close all
for layer = layers
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<Thresh2) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<Thresh2) = 0;
    imgBin = immultiply(imbinarize(imgVest), imbinarize(imgVis));
       
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])/10;
    img1(imgBin == 1) = 255;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif'])/10;
    img2(imgBin == 1) = 255;
    img3 = imgBin*255;
    imgCat = cat(3, img1, img2, img3);
    
    imshow(imgCat);
    mkdir([Path1, '/BinaryValueVestVisual']);
    imwrite(uint32(imgCat), [Path1, '/BinaryValueVestVisual/layer', num2str(layer, '%03d'), '.tif']);
end
%% Vestibular
close all
mkdir([MainPath, Path, '/BinaryValueVest']);
for layer = layers
    disp(layer)
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    img3 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    imgCat = cat(3, img1, img2, img3);
    imshow(imgCat);
    imwrite(uint8(imgCat), [MainPath, Path, '/BinaryValueVest/layer', num2str(layer, '%03d'), '.tif']);
end
%% Visual
close all
mkdir([MainPath, Path, '/BinaryValueVisual']);
for layer = layers
    disp(layer)
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img3 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    imgCat = cat(3, img1, img2, img3);
    imshow(imgCat);
    imwrite(uint8(imgCat), [MainPath, Path, '/BinaryValueVisual/layer', num2str(layer, '%03d'), '.tif']);
end
%% Binary Regions Common
close all
mkdir([Path1, '/BinaryValueCommon']);
for layer = layers
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<Thresh) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<Thresh) = 0;
    imgBin = immultiply(imbinarize(imgVest), imbinarize(imgVis));
       
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img1(imgBin == 1) = 255;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img2(imgBin == 1) = 255;
    img3 = imgBin*255;
    imgCat = cat(3, img1, img2, img3);
    
    imshow(imgCat);
    imwrite(uint8(imgCat), [Path1, '/BinaryValueCommon/layer', num2str(layer, '%03d'), '.tif']);
end

%% Binary Regions Multi
close all
mkdir([MainPath, Path, '/BinaryValue']);
for layer = layers
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<Thresh) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<Thresh) = 0;
    imgMulti = imread([Path3, '/layer', num2str(layer, '%02d'), '.tif']);
    imgMulti(imgMulti<Thresh) = 0;
    imgBinMulti = imbinarize(imgMulti);
    imgBin = imbinarize(imadd(imbinarize(imgVest), imbinarize(imgVis)));
    imgBinMulti(imgBin == 1) = 0;
    
    multi = cat(4, imbinarize(imgVest), imbinarize(imgVis), imbinarize(imgMulti), imgBinMulti);
    montage(multi);
    
    img1 = imgBinMulti*255;
    img2 = imgBinMulti*255;
    img3 = imgBinMulti*255;
    imgCat = cat(3, img1, img2, img3);
    
    %imshow(imgCat);
    mkdir([Path1, '/BinaryValueMulti']);
    imwrite(uint8(imgCat), [ Path1, '/BinaryValueMulti/layer', num2str(layer, '%03d'), '.tif']);
end
