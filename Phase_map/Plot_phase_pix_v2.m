function Plot_phase_pix(v_max, tresh, fstim)

% Plot the phase map per mixel with the file "out_all.mat".
% v_max: Max value (Max(value(:))/2)
% tresh: Treshold value

%% ---- Plot phase map per pixel -----

F = getFocus;

load([F.Files 'Phase_map/out_all.mat']);

for layer = 3:numel(F.sets);
    
    phi     = out_all(layer).phi;
    deltaphi= out_all(layer).deltaphi;
    value   = out_all(layer).value;
    ind     = out_all(layer).ind;
    im      = out_all(layer).im;
    
    I1=im*0;
    I2=im*0;
    I3=im*0;
    
    
    v_max = v_max; % Max(value(:))/2;
    for i = 1 : length(ind)
        I1(ind(i)) = mod(deltaphi(i),2*pi)/(2*pi);
        tmp = value(i)/v_max;
        if value(i) > tresh;
            I3(ind(i)) = tmp;
        end
    end
    I2 = 1;
    
    clear imhsv
    imhsv(:,:,1)= I1;
    imhsv(:,:,2)= I2;
    imhsv(:,:,3)= I3;
    
    parameters.header = 'Parameters of the function Plot_phase__pix: v_max = Max(value(:))/2) and tresh = treshold value and f = frequency at which phase was evaluated';
    parameters.max    = v_max;
    parameters.tresh  = tresh;
    parameters.fstim  = fstim;

    
   figure;imshow(hsv2rgb(imhsv))
    
    % Save images
    outdir = [F.Files 'Phase_map/PhaseMap_RGB'];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(layer,'%02d')], F.IP.extension)
    %imwrite(hsv2rgb(imhsv),[outdir '/Image_' num2str(layer) '.tif'])
    
    outdir = [F.Files 'Phase_map/PhaseMap_phase'];
    mkdir(outdir);
    imwrite(imhsv(:,:,1),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])
    
    outdir = [F.Files 'Phase_map/PhaseMap_sat'];
    mkdir(outdir);
    imwrite(imhsv(:,:,2),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])

    outdir = [F.Files 'Phase_map/PhaseMap_value'];
    mkdir(outdir);
    imwrite(imhsv(:,:,3),[outdir '/' F.IP.prefix, num2str(layer,'%02d') '.' F.IP.extension])
    
end

% Save parameters
outdir_all = [F.Files 'Phase_map/'];
save([outdir_all 'parameters.mat'],'parameters');

% create nrrd stacks
param.exp_type = '';
param.binning = [1 1];
param.pix_size = [-0.8 -0.8 -10];%[F.dx F.sets(2).z - F.sets(1).z] % cmtk space is right-anterior-superior
param.space_type = 'RAS';

% save phase, saturation, value as nrrd files in
% Registration/floating-stacks folder
cd(outdir_all)
    % define save location of created nrrd stack
    outFolder = [F.Files '/Registration/floating-stacks/'];

% make nrrd of phase image
    % define in and output folders
    inFolder = 'PhaseMap_phase';
    outName = [inFolder '_ras'];
    
    % calculate and save nrrd stack
    make_nrdd_stack_RLS_v2(inFolder,outFolder,outName, param);

% make nrrd of sat image
    % define in and output folders
    inFolder = 'PhaseMap_sat';
    outName = [inFolder '_ras'];
        
    % calculate and save nrrd stack
    make_nrdd_stack_RLS_v2(inFolder,outFolder,outName, param);

% make nrrd of value image
    % define in and output folders
    inFolder = 'PhaseMap_value';
    outName = [inFolder '_ras'];
        
    % calculate and save nrrd stack
    make_nrdd_stack_RLS_v2(inFolder,outFolder,outName, param);

