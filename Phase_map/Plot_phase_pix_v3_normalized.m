function Plot_phase_pix_v3_normalized(v_max, tresh, fstim, First_layer, F)

% Plot the phase map per mixel with the file "out_all.mat".
% v_max: Max value (Max(value(:))/2)
% tresh: Treshold value

%% ---- Plot phase map per pixel -----

load([F.Files 'Phase_map_normalized/PhaseMap_DFF_pix_fstim' num2str(fstim) '/out_all.mat']);

for layer = First_layer%3:numel(F.sets);
    
    phi     = out_all(layer).phi;
    deltaphi= out_all(layer).deltaphi;
   % value   = out_all(layer).value;
    value   = out_all(layer).amplitude';
    ind     = out_all(layer).ind;
    im      = out_all(layer).im;  % format double
    
    I1=im*0;
    I2=im*0;
    I3=im*0;
    
    Ia=double(im*0);
    Ib=double(im*0);
    Ia(ind) = value .* cos(phi);
    Ib(ind) = value .* sin(phi);
    
    Ia_stack(:,:,layer-2) = imrotate(Ia, 90);
    Ib_stack(:,:,layer-2) = imrotate(Ib, 90);
    
%% Preview
% clear imhsv
% 
% imhsv(:,:,1) =   mod(atan2(Ib,Ia) , 2*pi) / (2*pi);          %  phi(:,:,l,1);    
% imhsv(:,:,2) =   Ia*0+1;                 %  2^16;  
% imhsv(:,:,3) =   sqrt( Ia.^2 + Ib.^2 )/v_max;                 %  A(:,:,l,1);         
% 
% figure;imshow(hsv2rgb(imhsv))

    
    
    %v_max = v_max; % Max(value(:))/2;
    for i = 1 : length(ind)
        I1(ind(i)) = mod(deltaphi(i),2*pi)/(2*pi);
        tmp = value(i)/v_max;
        if value(i) > tresh
            I3(ind(i)) = tmp;
        end
    end
    I2 = 1;
    
    clear imhsv
    imhsv(:,:,1)= I1;
    imhsv(:,:,2)= I2;
    imhsv(:,:,3)= I3;
    
    parameters.header = 'Parameters of the function Plot_phase_pix_v3_normalized: v_max=vmax and tresh = treshold value and f = frequency at which phase was evaluated';
    parameters.max    = v_max;
    parameters.tresh  = tresh;
    parameters.fstim  = fstim;

    
   %figure;imshow(hsv2rgb(imhsv))
    
    % Save images
    outdir = [F.Files 'Phase_map_normalized/PhaseMap_RGB'];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(layer,'%02d')], F.IP.extension)
    %imwrite(hsv2rgb(imhsv),[outdir '/Image_' num2str(layer) '.tif'])
    
    outdir = [F.Files 'Phase_map_normalized/PhaseMap_phase'];
    mkdir(outdir);
    imwrite(imhsv(:,:,1),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])
    
    outdir = [F.Files 'Phase_map_normalized/PhaseMap_sat'];
    mkdir(outdir);
    imwrite(imhsv(:,:,2),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])

    outdir = [F.Files 'Phase_map_normalized/PhaseMap_value'];
    mkdir(outdir);
    imwrite(imhsv(:,:,3),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])
 
    outdir = [F.Files 'Phase_map_normalized/PhaseMap_a'];
    mkdir(outdir);
    imwrite(imrotate(Ia, 90),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])

    outdir = [F.Files 'Phase_map_normalized/PhaseMap_b'];
    mkdir(outdir);
    imwrite(imrotate(Ib, 90),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])

end

%% Save parameters
outdir_all = [F.Files 'Phase_map_normalized/'];
save([outdir_all 'parameters.mat'],'parameters');


%% save nrrd stacks of Ia and Ib in Registration/floating-stacks/ location

cd(outdir_all)
% define save location of created nrrd stack
outFolder = [F.Files 'Registration/floating-stacks/'];

% settings
param.exp_type = '';
param.binning = [1 1];
param.pix_size = [0.8 0.8 -10];%[F.dx F.sets(2).z - F.sets(1).z] % cmtk space is right-anterior-superior
param.space_type = 'RAS';
param.pixelspacing=...
[param.pix_size(1) param.pix_size(2) param.pix_size(3)].* ...
[param.binning(1)  param.binning(1)  param.binning(2)];
param.origin=[0 0 0];
param.encoding='raw';

% create save folder
[status,message,messageid] =mkdir(outFolder)
    
% save nrrd stacks
inFolder = 'PhaseMap_normalized_a';
outName = [inFolder '_ras'];
nrrdWriter([outFolder filesep outName '.nrrd'], Ia_stack, param.pixelspacing, param.origin, param.encoding, param.space_type);

inFolder = 'PhaseMap_normalized_b';
outName = [inFolder '_ras'];
nrrdWriter([outFolder filesep outName '.nrrd'], Ib_stack, param.pixelspacing, param.origin, param.encoding, param.space_type);

