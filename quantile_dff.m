%INPUT:
% data_in: matrix with the raw pixel fluorescence time
% series as ROWS.
% dt = time interval between two data points [s]
% bg = background value (default: 0)
% qq = quantile value for baseline estimation (default:0.08)
% tt = time window for baseline estimation in seconds (default: 50)
% fast = use parallel computing for dff calculation (default: true)

function dff = quantile_dff(data_in,dt,bg,qq, tt, fast)

switch nargin
    case 2
        bg = 0;
        qq = 0.08;
        tt = 50;
        fast = true;
    case 3
        qq = 0.08;
        tt = 50;
        fast = true;
    case 4
        tt = 50;
        fast = true;
    case 5
        fast = true;
end

%extract DFF
data_in = single(data_in)-single(bg);
clear bg
dff = single ( zeros(size(data_in))  );

tic
if size(data_in,1)>10000
    for n = 0:10000:size(data_in,1)
        disp( ['extracting dff, pixel ' num2str(n) ' out of ' num2str(size(data_in,1))] )
        toc
        range = n+1: min((n+10000),size(data_in,1));
        bl = fast_baseline(data_in(range,:),qq,round(tt/dt),fast);
        bl(bl==0) = 1;%%%%%%%%%%%%%/!\
        dff(range,:) = single( (data_in(range,:)-bl)./bl );
    end
else
    bl = fast_baseline(data_in,qq,round(tt/dt),fast);
    bl(bl==0) = 1;%%%%%%%%%%%%/!\
    dff = single( (data_in-bl)./bl );
    clear data_in
end

end