function DFF_bg(Layers, F)

switch nargin
    case 0
        Layers = 1;
        F=getFocus;
    case 1
        F=getFocus;
end
% Parameters
dt = ((F.dt)/1000)*F.sets(end).id; % [s] time interval between two data points

if nargin == 0
    dt = ((F.dt)/1000)*F.sets(end).id; % [s] time interval between two data points
    Layers = 1;
end
    
if nargin == 1
    dt = ((F.dt)/1000)*F.sets(end).id; % [s] time interval between two data points
end;


for l = Layers%:F.sets(end).id;
    F.select(l);
    
    % load signal stack
    l = int2str(l);
    data_in = load([F.Files 'signal_stacks/' l '/sig.mat']); % matrix with the raw pixel fluorescence time
    
    % get background
    Img1 = F.iload(1);  
    bg = Img1.background;

%     h = 0;
%     
%     Bin = 2;
%     for w = 0:Bin:round(F.IP.width)
%         data(w/Bin+1) = find(150 < data_in.DD.index/F.IP.width < 155);
%         index(W/Bin);
%     end;
        
    dff =  quantile_dff(data_in.DD.signal_stack(:,1:end),dt,bg) ;
    %clear data_in;
    % Save
    Dmat = F.matfile(['signal_stacks', '/', l, '/', 'DFF_bg']);
    Dmat.save('DFF_pix'     , dff   , 'DFF = (F(i,t)-baseline(i,t))/(baseline(i,t)-background(t))'); 
    Dmat.save('background'  , bg   , 'background = Img1.background'); 
    index = data_in.DD.index;
    Dmat.save('index'  , index   , 'index of all pixels in brain contour'); 
    clear Dmat dff;
end
