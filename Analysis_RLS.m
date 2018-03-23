ML.Projects

%% ----- Rename ----- (Rename images in stack)
rename(1);
%% ----- Configuration -----
Routines.Config;

F = getFocus;
F.select(F.sets(1).id)
Ref = F.iload(1);
%% ----- Routines.IP ----- (Routine Candelier)
Routines.IP;

%% ----- AntiDrift inspired by OpenSpim -----
First_layer = 3;
First_layer_cor = 10;
NlayerProjection = 11;
AntiDrift_OpenSpim(NlayerProjection, First_layer_cor, First_layer); % AntiDrift_OpenSpim(Fisrt_layer, NlayerProjection) : NlayerProjection = Last layer for the z projection, because the drift correction
                      %is better if you have all the countour of the brain.
                      %By default ( NlayerProjection = Number of layer)

% ----- Reorganize images in folders per layers (script)
organizeperlayer(First_layer); % organizeperlayer(Fisrt_layer) : 

%%
%% ----- AntiDrift v2 inspired by OpenSpim -----
F = getFocus;
First_layer = 3;
Last_layer=20;
First_layer_cor = 5;
NlayerProjection = 5;
AntiDrift_OpenSpim_v2(NlayerProjection, First_layer_cor, First_layer, F, Last_layer,'false'); % AntiDrift_OpenSpim(Fisrt_layer, NlayerProjection) : NlayerProjection = Last layer for the z projection, because the drift correction
                      %is better if you have all the countour of the brain.
                      %By default ( NlayerProjection = Number of layer)
%%
F = getFocus('2018-01-31',4);
AntiDrift_OpenSpim_v2(NlayerProjection, First_layer_cor, 8, F, 8,'true');                      
AntiDrift_OpenSpim_v2(NlayerProjection, First_layer_cor, 12, F, 12,'true');


%% ----- Signal stack -----
First_layer = [12];
binsize = 1;
create_signal_stack_RLS(First_layer, binsize);

%% ----- DFF ---- (By Tommaso)
% calculates the DFF per pixels for all images in the selected Run
Layers = 3;
%DFF_bg(First_layer); % variable input: dt
%DFF(First_layer); % variable input: dt
%Plot_DFF(120) % Plot_DFF(Period): you can change the number of period of stimulation, default period = 250 

F=getFocus('2016-12-07',1);
DFF_bg(Layers,F);

%% ----- Calculate Phase map per pixel ----- 
fstim = 1/5;
First_layer = [5:20];
[out_all] = PhaseMap_pix_RLS(fstim, First_layer);

%% ----- Plot phase map per pixel -----
fstim = 0.2;

v_max = 50; % Max value (Max(value(:))/2)
tresh = 1; % Treshold value
First_layer = 5;
Plot_phase_pix(v_max, tresh, fstim, First_layer);
%% ----- Calculate normalized Phase map per pixel ----- 
fstim = 0.2;
First_layer = [3:11];
[out_all] = PhaseMap_pix_RLS_value_normlized(fstim, First_layer);


%% ----- Plot phase map normalized per pixel -----
fstim = 0.2;

v_max = 0.5; % Max value (Max(value(:))/2)
tresh = 0.05; % Treshold value
First_layer = 8;
Plot_phase_pix_v3_normalized(v_max, tresh, fstim, First_layer);

%% ----- Images avg ----- (Calculate mean over periode)
AvgOverStimulus_layer(120); % AvgOverStimulus_layer(Period): you can change the number of period of stimulation, default period = 250 

%% ----- Background subtraction from Images_avg ----- (Calculate mean over periode)
StartLayer = 2;
F = getFocus;
Nlayer = length(F.sets);
% Creat
    %Img = double( imread(files(1).name) );

    for i = 1:length(files)
        Img(:,:,i) =  double( imread(files(i).name) ) ;
    ende folder
[status,message,messageid] = mkdir([F.Files, 'Images_avg_BackgroundSubtracted']);
clear Img ImgAvg ImgBS
Get all PDF files in the current folder
for l = StartLayer:Nlayer
    [status,message,messageid] = mkdir([F.Files, 'Images_avg_BackgroundSubtracted/',num2str(l)]);

    cd([F.Files, 'Images_avg/',num2str(l)])
    files = dir( '*.tif');

    
    ImgAvg = mean(Img,3);
    
    for i = 1:length(files)
        ImgBS = Img(:,:,i) - ImgAvg;
        imwrite( uint16(ImgBS), F.fname(['Images_avg_BackgroundSubtracted' '/' num2str(l) '/' F.IP.prefix, num2str(i,F.IP.format)], F.IP.extension) );
    end
end

% Show stacks as hyperstack:
% open all stacks as virual stacks
% go to image-stacks-toots-concatentate
% go to image-hyperstacks-re-order hyperstack
% go to image-color-ChannelTool-more and select gray
%% ----- CMTK ----- 
%cmtk_ize_test.m
cmtk_registration;
mean_larva.m

%% ----- Files ----- (usefull for the manual drift correction and the regression analysis)
F = getFocus;
fp.ddir = F.Data;
fp.pref = F.IP.prefix;
fp.format = F.IP.format;
fp.suff = F.IP.extension;

fp.binning = 2; % define with the camera Hamamatsu
fp.StartLayer = 2; % start layer to analyse
fp.LasthLayer = 20; % start layer to analyse
fp.background = 400; % average intensity in background
fp.imreg = 1; % imgreg = 1 => deformations are corrected

%% ----- Calculate drift correction ----- (manual, normaly it's done in the routine)
fp.StartLayer = 2;
DriftCorrection_RLS(fp);

%% ----- Correct drift and deformations in images ----- (manual, normaly it's done in the routine)
fp.StartLayer = 2;
create_corrected_sequence_RLS(fp);

%% ----- Perform regression analysis ----- 
%regression_stimulus();
StartLayer = 2;pstim.p = 30; pstim.f = 0.05; %regression_motor(StartLayer,pstim);
feye = 1/0.05;
%regression_tracking(F,fp,feye,pstim);
regression_tracking_step(F,fp,feye,pstim);


%%%%%%%%%%%%%%%%%%%%%%% Visualization with FIJI %%%%%%%%%%%%%%%%%%%%%%%
% open all stacks as virtual stacks: pos_bottom_stack (red); pos_top_stack(blue);
% vit_bottom_stack (magenta); vit_top_stack(cyan); grey stack (grey)
% merge all five stacks with FIJI: Image=>Color=>Merge

%% ----- Average activity in selected ROI ----- 
cd('/home/ljp/Science/Projects/RLS/Data/Vestibular/2016-02-01/Run 02/')
layer = 6;
mean_activity_saccade(layer,DD)

%% ----- Restack images saved in folder per layer into a single stack -----  
fp.ddir = '/home/ljp/Science/Projects/RLS/Data/2016-12-06/Run 04/';
fp.pref = 'Images0_';
fp.format = '%05i';
fp.suff = '.tif';

% old_folder = 'corrected_images/';
% new_folder = 'corrected_images_restacked/';

old_folder = 'Files/Images_cor/';
new_folder = 'Images_cor_restacked/';


restack_RLS(fp, old_folder, new_folder)

%% ---- Registration via CMTK
% download FIJI plugin of CMTK at: https://github.com/jefferis/fiji-cmtk-gui

pos_vit_worksheet_2P_disque_externe_volker_v2.m

% make_nrdd_stack
% create_reformat_command
% 
% convert_coordinates
% add_stack_to_viewer

%% ----- zBrainViewer
ZBrainViewer

%% ----- Correlation analysis (run Routines.IP before)
% date = '2016-03-21';
% Run = 04;
% layer = 2;
   % go in m file and select date and layer !!!!
F=getFocus('2016-12-06',04);
F.select(12);

debug_display_activity_rawsignal_FOCUS
%%
F=getFocus('2016-12-06',04);
F.select(12);


%DFFprime=F.matfile('@DFFprime');
%R=DFFprime.load('R');
%R=R.R';
%Rcor=DFFprime.load('Rcor');
%Rcor=Rcor.Rcor';


%Rcor_prime=DFFprime.load('Rcor_prime');
%Rcor_prime=Rcor_prime.Rcor_prime';

DFF=F.matfile('@DFF');
DFFcor=DFF.load('neurons');
DFFcor=DFFcor.neurons;

im=imread(F.fname('IP/@Mean', 'png'));

Neurons=F.matfile('IP/@Neurons');

Brain=F.matfile('IP/@Brain');

STATS=Neurons.load('ind');
STATS=STATS.ind;

Nneurons=Neurons.load('N');
Nneurons=Nneurons.N;

bbox=Brain.load('bbox');
bbox=bbox.bbox;

L=zeros(bbox(2)-bbox(1)+1,bbox(4)-bbox(3)+1)';
for i=1:Nneurons
L(STATS{1,i})=i;
end;

clear bbox
%%
DFFcorcor=DFFcor;

Rcor=corrcoef(DFFcorcor'); % calculate correlations
figure;hist(Rcor(:))

[donner1,donner2,donner3,donner4,donner5]=correction_bruit_correle_ACP(DFFcorcor); % remove correlated noise
Rcorcor = donner1;
figure;hist(Rcorcor(:),150)

Nimages = 3000;
feye = 40; % Hz  frame rate of the eyes movements measurements
f = feye;

pstim.f = 0.2; % periode/s of stimulus
pstim.A = 1; % amplitude in degree of stimulus
pstim.phase = 0;

t_stim = [1:1:Nimages]'*0.5;
Stimulation = -pstim.A * cos(2*pi * pstim.f * t_stim     );

cartedecorrelation_RLS
%cartedecorrelation_autour_d_un_neurone.m

%% Cluster analysis

% --- Get the correlation matrix
clear Idx Cluster

k=10;

    tic
    Idx = kmeans(Rcor, k, 'distance', 'correlation');
    toc

Cluster = {};

for i = 1:k
    Cluster{i} = find(Idx==i);
   % Time.status
end

%%

% % --- Display
% 
% % ROI = F.IP.load('ROI');
% % sz = [ROI(2)-ROI(1) ROI(4)-ROI(3)];
% % 
% %Img = F.IP.load('mean', 'png');
% % Img.region(ROI([3 4 1 2]));
% %Img.show('range', [0 2000])
% figure;imshow( rescalegd2(im))
% %axis ij
% 
% clear x y J I K
% hold on
% K=Cluster;
% for k = 12
%         
%     for i = 1:numel(K{k})
%         Id = K{i};
%         [I, J] = ind2sub(size(im), STATS{Id});
%         x = J;
%         y = I;
%         
%         c = mean(Rcor(Id, K{k}));
%         
%         scatter(x, y, c, 'o', 'filled')
%     end
%     
% end

%%

display_kmeans_direct(im,STATS,Idx,1)
%%

display_kmeans_steps(im,STATS,Idx,DFFcorcor,0.,1,k)

%%
figure
for i=1:k;
DFF_mean(i,:)=mean(DFFcorcor(find(Idx==i),:));
plot(DFF_mean(i,:));
hold on


for t=1:20;
    DFF_mean_stim(i,t)=mean(DFF_mean(i,t:20:end));
end
end
figure
for i=1:k;
plot(DFF_mean_stim(i,:));
hold on
end

%% ----- Tools ----- 
which('function_name') % => find location 


%% ----- Rotate images ----- 
cd('/home/ljp/Science/Projects/RLS/Data/2016-03-18/Run 01/corrected_images/')
Nimages = numel(dir('2_affine'));

for i = 1 : Nimages
    refname = ['2_affine/',fp.pref num2str(i, fp.format) fp.suff];
    im=imread(refname);
    
    E(i) = IM.get_ellipse(im);
    if E(i).theta < 4 
        E(i).theta = E(i).theta + pi;
    end

    im_r=imrotate(im,(E(i).theta*180/pi)-90,'bilinear');


%     figure;
%     imshow(rescalegd2(im_r));
%     hold on;
%     IM.draw_ellipse(E,'elements','major') 
    
    imwrite(uint16(im_r), ['2/',fp.pref num2str(i, fp.format) fp.suff]);
end

%% Get motor and eye tracking
F = getFocus('2017-02-08',8)

% read tracking data
clear fileID Data TimeTracking Tracking
file = dir([F.Data,'*Tracking.dat']);
fileID = fopen([F.Data file.name]);
Data = fread(fileID,[ 2, Inf ],'single=>single','ieee-le');
fclose(fileID);

% Data
Tracking = Data(2,2:2:end);
TimeTracking = Data(1,2:2:end);

% Time offset
TimeOffset = TimeTracking(1); 
% Subtrack start time
TimeTracking = TimeTracking - TimeOffset;
    
% read motor data
filename = [F.Data,'Stimulus.txt']; % data path and name of where the motor movement is saved
delimiter = '\t';                   % 
formatSpec = '%f%f%f%[^\n\r]';      % formate of the text file

fileID = fopen(filename,'r');       % open text file
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false); % scan text file
fclose(fileID);                     % close text file

TimeMotor = dataArray{:, 2};        
TimeMotor = TimeMotor - TimeOffset;
Motor = dataArray{:, 3};

% plot data
figure

ax(1) = subplot(2,1,1)
plot(TimeMotor,Motor)
xlabel 'Time (s)'
ylabel 'Angle (degree)'
title([F.name])

ax(2) = subplot(2,1,2)
plot(TimeTracking,Tracking)
xlabel 'Time (s)'
ylabel 'Angle (degree)'

linkaxes(ax,'x')


    
