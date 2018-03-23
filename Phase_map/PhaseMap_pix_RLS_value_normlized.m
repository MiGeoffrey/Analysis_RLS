function [out_all] = PhaseMap_pix_RLS_value_normlized(fstim, First_layer,varargin)

% Phase_map_pix compute the Fast Fourier Transform of the DFF_pix matrice
% and return the file "out_all.mat" with the amplitude and phase of
% DFF response and the image's informations usefull to plot the phase images.

% fstim is the frequency of stimulation (frequency of the motor).

% phase_map_pix(fstim, First_layer)
% phase_map_pix(fstim, First_layer,Focus)

%% ----- Load Pix DFF file and compute the Fast Fourier Transform of it -----
if length(varargin) > 0
    F = varargin{1}
else
    F = getFocus;
end
for layer = First_layer%:numel(F.sets);
    layer
    % Select layer to analyse
    F.select(layer);
    
    % Load DFF and signal_stack
%    load([F.Files 'signal_stacks' filesep num2str(layer) filesep 'DFF_bg.mat'])
load([F.Files 'signal_stacks' filesep num2str(layer) filesep 'DFF.mat'])
%         load([F.Files 'signal_stacks' filesep num2str(layer) filesep 'dff.mat'],'dff')
%         DFF_pix = dff.signal_stack;
    load([F.Files 'signal_stacks' filesep num2str(layer) filesep 'sig.mat'],'DD')
    
    % Load gray image
    im = rescalegd2(DD.imgref);
    
    % Define index result in image
    ind = DD.index;
    clear DD;
    
    % Prepare folder for saving
    outdir = [F.Data 'Files/Phase_map_normalized/PhaseMap_DFF_pix_fstim', num2str(fstim), '/Images'];
    mkdir(outdir);
    outdir_all = [F.Data 'Files/Phase_map_normalized/PhaseMap_DFF_pix_fstim', num2str(fstim)];
    
    % Define stimulation parameters
    fstim = fstim;                              % Stimulation frequency
    L = size(F.set.t,2)/2;                        % Number of images per layer
    fs = 1/(F.dt*0.001*size(F.sets, 2));        % Frame rate at which images per layer are acquired
    dt = 1/fs;                                  % Sampling period
    T = L*dt;                                   % Total time of acquisition
    
    % Phase shift
    phi_GCaMP = 0;%-0.6916;                      % Phase shift because of the response of the GCaMP, get with the convolution of the stimulus with a Kernel
    phi_layer = layer*(F.dt*2*pi)*fstim*0.001;   % Phase shift because of the delay time between each layer (F.dt)
    phase_delay = phi_GCaMP + phi_layer;         % (pi/2 - 0.8796) Phase shift of sinusodial stimulus
    
    % Calculate fourier transformation
    Y = fft(DFF_pix(:,1:L),[],2);
    
    
    % Define frequency vector
    f = fs*[0:1:L/2]/L;
    
    % calculate response amplitude
%     [pxx_p,f_p] = periodogram(DFF_pix(:,1:L)',hamming(L),[fstim fstim*2]',fs,'power');
%     amplitude = sqrt(pxx_p(1,:)*2*2);
%     
    [pxx,ff] = periodogram(DFF_pix(:,1:L)',hamming(L),L,fs,'power');
    pxx_p = pxx(find(single(ff)==single(fstim)),:);
    amplitude = sqrt(pxx_p(1,:)*2)*2; % amplitude peak-to-peak

    
    clear DFF_pix;
    % Extract amplitude and phase of DFF response
    f_round = round(f,3);
    ind_fstim = find(f_round==fstim);
    phi       = angle(Y(:,ind_fstim));
    value     = abs(Y(:,ind_fstim));
    
    out_all(layer).phi      = phi;
    out_all(layer).deltaphi = (phi - phase_delay + pi);% -phase_delay = Shift positive of the fluorescence and +pi = because of the fourier transform is done against a cosinus  
    out_all(layer).value    = value;
    out_all(layer).amplitude    = amplitude;
    out_all(layer).ind      = ind;
    out_all(layer).im       = im;
    
    save([outdir_all '/out_all.mat'],'out_all');
    clear Y;
    
    %% ----- Plot phase map in gray image -----
    
    % Initialize im
    I1=im*0;
    I2=im*0;
    I3=im*0;
    
    v_max = 60;
    tresh = 10;
    
    for i = 1 : length(ind)
        I1(ind(i)) =  mod(out_all(layer).deltaphi(i),2*pi)/(2*pi);
        tmp = value(i)/v_max;
        if value(i) > tresh
            I3(ind(i)) = tmp;
        end
    end
    I2 = 1;
    
    clear imhsv, out_all;
    imhsv(:,:,1)= I1;
    imhsv(:,:,2)= I2;
    imhsv(:,:,3)= I3;
    
    % Plot imhsv
    %figure;imshow(hsv2rgb(imhsv))
    
    parameters.header = 'Parameters of the function Plot_phase_pix: v_max = Max(value(:))/2) and tresh = treshold value';
    parameters.max    = v_max;
    parameters.tresh  = tresh;
    
    % Save images
    outdir = [F.Data 'Files/Phase_map_normalized/PhaseMap_DFF_pix_fstim', num2str(fstim), '/Images/'];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(layer) '.tif'], 'tif')
    
end

% Save parameters
outdir_all = [F.Data 'Files/Phase_map_normalized/PhaseMap_DFF_pix_fstim', num2str(fstim)];
save([outdir_all '/parameters.mat'],'parameters');

