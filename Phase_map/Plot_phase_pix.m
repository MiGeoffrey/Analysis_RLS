function Plot_phase_pix(v_max, tresh, fstim, First_layer)

% Plot the phase map per mixel with the file "out_all.mat".
% v_max: Max value (Max(value(:))/2)
% tresh: Treshold value

%% ---- Plot phase map per pixel -----

F = getFocus;

if nargin == 0
    v_max       = 1; % Max(value(:))/2;
    tresh       = 0;
    fstim       = 0.2;
    First_layer = 1;
end
if nargin == 1
    v_max       = 1; % Max(value(:))/2;
    tresh       = 0;
    fstim       = 0.2;
end
if nargin == 2
    v_max       = 1; % Max(value(:))/2;
    tresh       = 0;
end

load([F.Files 'Phase_map/PhaseMap_DFF_pix_fstim', num2str(fstim), '/out_all.mat']);

for layer = First_layer:numel(F.sets);
    
    % Phase shift
    phi_GCaMP = 0;%- 0.6916;                        % Phase shift because of the response of the GCaMP, get with the convolution of the stimulus with a Kernel
    phi_layer = layer*(F.dt*2*pi)*fstim*0.001; % Phase shift because of the delay time between each layer (F.dt)
    phase_delay = phi_GCaMP + phi_layer;    % (pi/2 - 0.8796) Phase shift of sinusodial stimulus
    
    phi      = out_all(layer).phi;
    %deltaphi = out_all(layer).deltaphi;
    deltaphi = (phi - phase_delay + pi);  % calculated phase  (phi) corrected for time delay between layers (phase_delay) and calculated relative to stimulus which is a -cos and thus needs a phase shift of pi  
    value    = out_all(layer).value;
    ind      = out_all(layer).ind;
    im       = out_all(layer).im;
    
    % Initialize im
    I1 = im*0;
    I2 = im*0;
    I3 = im*0;
    
  %  v_max       = max(value(:));
    for i = 1 : length(ind)
        I1(ind(i)) =  mod(deltaphi(i),2*pi)/(2*pi);
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
    
    % Save parameters
    parameters.header = 'Parameters of the function Plot_phase__pix: v_max = Max(value(:))/2) and tresh = treshold value';
    parameters.max    = v_max;
    parameters.tresh  = tresh;
    
    % Save images
    outdir = [F.Data 'Files/Phase_map/PhaseMap_DFF_pix_fstim', num2str(fstim), '/Images/'];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(layer) '.' F.IP.extension])
end

% Save parameters
outdir_all = [F.Data 'Files/Phase_map/PhaseMap_DFF_pix_fstim', num2str(fstim)];
save([outdir_all '/parameters.mat'],'parameters');

