
%%
MainPath = ('/home/ljp/Science/Projects/RLS/Data');
Path = ('/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers');
Path1 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_3/PhaseMap_Value']; % Visual
Path2 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers/PhaseMap_Value']; % Vestibular
Path2 = [MainPath, Path, '/WARP_phasemap_ON_zBrain_Elavl3-H2BRFP_198layers_2/PhaseMap_Value']; % Vestibular
%% Visual and Vestibular
close all
mkdir([MainPath, Path, '/BinaryValueVest']);
for layer = 1:Zs
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<100) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<100) = 0;
    imgBin = immultiply(imbinarize(imgVest), imbinarize(imgVis));
       
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    img1(imgBin == 1) = 255;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    img2(imgBin == 1) = 255;
    img3 = imgBin*255;
    imgCat = cat(3, img1, img2, img3);
    
    imshow(imgCat);
    imwrite(uint8(imgCat), [MainPath, Path, '/BinaryValueVest/layer', num2str(layer, '%03d'), '.tif']);
end
%% Vestibular
close all
mkdir([MainPath, Path, '/BinaryValueVest']);
for layer = 1:Zs
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
for layer = 1:Zs
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
mkdir([MainPath, Path, '/BinaryValue']);
for layer = 1:Zs
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<100) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<100) = 0;
    imgBin = immultiply(imbinarize(imgVest), imbinarize(imgVis));
       
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img1(imgBin == 1) = 255;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img2(imgBin == 1) = 255;
    img3 = imgBin*255;
    imgCat = cat(3, img1, img2, img3);
    
    imshow(imgCat);
    imwrite(uint8(imgCat), [MainPath, Path, '/BinaryValue/layer', num2str(layer, '%03d'), '.tif']);
end

%% Binary Regions Multi
close all
mkdir([MainPath, Path, '/BinaryValue']);
for layer = 1:Zs
    disp(layer)
    imgVest = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVest(imgVest<100) = 0;
    imgVis = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif']);
    imgVis(imgVis<100) = 0;
    imgBin = immultiply(imbinarize(imgVest), imbinarize(imgVis));
       
    BinColor = [0, 255, 0];
    img1 = imread([Path1, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img1(imgBin == 1) = 255;
    img2 = imread([Path2, '/layer', num2str(layer, '%02d'), '.tif'])*0;
    img2(imgBin == 1) = 255;
    img3 = imgBin*255;
    imgCat = cat(3, img1, img2, img3);
    
    imshow(imgCat);
    imwrite(uint8(imgCat), [MainPath, Path, '/BinaryValue/layer', num2str(layer, '%03d'), '.tif']);
end