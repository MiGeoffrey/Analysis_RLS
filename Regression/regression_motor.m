
function regression_tracking(StartLayer,pstim)
driftcorrection = 0; % 1 = no exclution of bad times
StartLayer = 3;

F = getFocus;
nlayer = F.sets(end).id;

% --- Files
datapath = F.Files;
suff = F.IP.extension;

f = 1/F.dt * 1000;

for layer=StartLayer:nlayer;
    
    disp(layer)
    % load signal matrix
    %load([datapath 'IP/' num2str(layer) '/Neurohexs.mat']); % Load fluo from Neurohexs
    load([datapath 'signal_stacks/' num2str(layer) '/sig.mat']); % Load fluo from pixel
    imgref=DD.imgref;
    
    sigstack=DD.signal_stack;
    index=DD.index;
    
    if driftcorrection == 1
    % load drift matrix to eliminate motion artrifacts
    clear drift
    drift = load([datapath 'IP/' num2str(layer) '/Drifts.mat']);
    end
    
    % save files
    save_pos_top=[datapath 'Regression/Regression_tracking/red_Pos_top_stack']; %left/right
    save_vit_top=[datapath 'Regression/Regression_tracking/magenta_Vit_top_stack']; %left/right
    save_pos_bottom=[datapath 'Regression/Regression_tracking/blue_Pos_bottom_stack'];
    save_vit_bottom=[datapath 'Regression/Regression_tracking/cyan_Vit_bottom_stack'];
    mkdir(save_pos_top);
    mkdir(save_vit_top);
    mkdir(save_pos_bottom);
    mkdir(save_vit_bottom);
    
    %%
    % ------------- get the "good times" == no motion
    if driftcorrection == 1
        drift = [[drift.dx]' [drift.dy]'];
        motion_times = extract_motion_times(drift, 10, fix(1*f/nlayer));
        disp([num2str(numel(motion_times)) ' frames discarded']);
        % the value 10 correspond to number of stdv - should be less for neuro
        tt = ones(size(drift,1),1);
        tt(motion_times)=0;

        good_times=find(tt==1);
    else
        good_times= [ 1 : 1 : length(F.sets(20).frames) ];
    end
  

% ------ Import Motor data
filename = [F.Data,'Stimulus.txt'];
delimiter = '\t';
formatSpec = '%f%f%f%[^\n\r]';

fileID = fopen(filename,'r');
dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,NaN, 'ReturnOnError', false);
fclose(fileID);

TimeMotor = dataArray{:, 2};
TimeMotor = TimeMotor - TimeMotor(1);
Motor = dataArray{:, 3};

clearvars filename delimiter formatSpec fileID dataArray ans;

%     
    % Data filter
%     N=5;b=ones(1,N)/N;
%     Tracking_filt = filtfilt(b,1,double(Tracking(1:end)'));
    Time = [0:1/f:pstim.p/pstim.f];
   % Time = [(layer-1)*1/f : 1/f : pstim.p/pstim.f - (nlayer - layer+1)*1/f];

    Tracking_ip = interp1(TimeMotor(1:end),Motor(1:end),Time);
   % Tracking_ip(Tracking_ip < 0) = 0;
    
%     % Plot Data
%     figure;
%     plot(Time,Tracking_ip,'r');
%     ylabel 'Tracking (degree)';
%     title([F.date, ' Run=', num2str(F.run)  ]);
        
    for eye = [3 6]
        
        sigstack = DD.signal_stack;
        
        if eye == 3
            lpos = Tracking_ip(1:end-1)';
            lpos(lpos < 0) = 0; 
        end
        
        if eye == 6
            lpos = -Tracking_ip(1:end-1)';
            lpos(lpos < 0) = 0;
        end
        
        if layer == 2
            figure;
            plot(Time,Tracking_ip);
        end
        
        lvit=diff(lpos);
        
        % threshold velocity on 3xstdv
        vord=sort(lvit);
        vord=vord([1:fix(0.9*numel(vord))]);
        st=std(vord(:));
        %w=find(lvit<3*st);
        %lvit(w)=0;
        lvit=[0,lvit']';
        
        % convolve with calcium signal
        Ntimes=1000;
        time=[1:Ntimes]/f;
        ker=exp(-time/0.8).*(1-exp(-time/.1));
        lvit2=conv([zeros(Ntimes/2,1)' lvit' zeros(Ntimes/2,1)'],ker,'same');
        lvit=lvit2(1:end-Ntimes)';
        lpos2=conv([zeros(Ntimes/2,1)' lpos' zeros(Ntimes/2,1)'],ker,'same');
        lpos=lpos2(1:end-Ntimes)';
        
        
        % normalize and limit to good times
        lpos_layer=lpos(layer:nlayer:end);  % ATTENTION, pas pour la correlation avec oscillateur
        good_times(good_times>length(lpos_layer))=[];
        good_times(isnan(lpos_layer))=[];
        
        lpos_norm=lpos_layer(good_times)-mean(lpos_layer(good_times));
        lvit_layer=lvit(layer:nlayer:end);
        lvit_norm=lvit_layer(good_times)-mean(lvit_layer(good_times));
        for n=0:10000:size(sigstack,1) % perform calculation by blocks to avoid memory overload
            range=[n+1: min((n+10000),size(sigstack,1))];
            sigstack(range,good_times) = bsxfun(@minus,double(sigstack(range,good_times)),mean(sigstack(range,good_times),2));
        end
        sigstack=sigstack(:,good_times);
        sig_mean=mean(sigstack,1)'; % mean fluorescence signal acroos all pixels
        
        % ---------- orthogonalize the vectors
        A=[lpos_norm,lvit_norm,sig_mean];
        B=Gram_Schmidt_Process(A);
        
        
        % ---------- project signal on each vector to get the best regression coefficients
        proj=[];
        for n=0:10000:size(sigstack,1)
            range=[n+1: min((n+10000),size(sigstack,1))];
            proj(range,:)=double(double(sigstack(range,:))*B);
        end
        
        var_residu=zeros(size(sigstack,1),1);
        for n=0:10000:size(sigstack,1)
            range=[n+1: min((n+10000),size(sigstack,1))];
            residu=double(sigstack(range,:))-proj(range,:)*B';
            var_residu(range)=sqrt(sum(residu.^2,2))/sqrt(size(residu,2)-3);
        end
        
        Tscore_pos=proj(:,1)./var_residu;
        Tscore_vit=proj(:,2)./var_residu;
        
        % normalize by the std of the central part of the Tscore distribtion
        % position
        st=std(Tscore_pos);
        m=mean(Tscore_pos);
        ww=find(abs(Tscore_pos-m)<st); % select data within one std from the mean
        [mu,sigma]=normfit(Tscore_pos(ww)); % normal distribution fitting;
        Tscore_pos_norm=(Tscore_pos-mu)/sigma; % normalize the score
        Tscore_pos_norm(find(Tscore_pos_norm<1))=0; % keep only positive correlations
        imgTposnorm=zeros(size(imgref));
        imgTposnorm(index)=Tscore_pos_norm;
        
        % velocity
        st=std(Tscore_vit);
        m=mean(Tscore_vit);
        ww=find(abs(Tscore_vit-m)<st); % select data within one std from the mean
        [mu,sigma]=normfit(Tscore_vit(ww)); % normal distribution fitting;
        Tscore_vit_norm=(Tscore_vit-mu)/sigma; % normalize the score
        Tscore_vit_norm(find(Tscore_vit_norm<1))=0; % keep only positive correlations
        imgTvitnorm=zeros(size(imgref));
        imgTvitnorm(index)=Tscore_vit_norm;
        
        % save
        suff=num2str(1000+layer);suff=suff(2:4);
        if eye==3
            savename=[save_pos_bottom '/Tposnorm_bottom_' suff '.tif'];
            imwrite(uint16(100*imgTposnorm),savename);
            savename=[save_vit_bottom '/Tvitnorm_bottom_' suff '.tif'];
            imwrite(uint16(100*imgTvitnorm),savename);
        end
        
        if eye==6
            savename=[save_pos_top '/Tposnorm_top_' suff '.tif'];
            imwrite(uint16(100*imgTposnorm),savename);
            savename=[save_vit_top '/Tvitnorm_top_' suff '.tif'];
            imwrite(uint16(100*imgTvitnorm),savename);
        end
        
        
        % figure;
        % subplot(2,1,1);
        % imshow(0.2*rescalegd(imgTposnorm));
        % subplot(2,1,2);
        % imshow(0.2*rescalegd(imgTvitnorm));
        
    end
    
end
