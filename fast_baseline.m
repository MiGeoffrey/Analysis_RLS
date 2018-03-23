function [base_line] = fast_baseline(data_in,qq, ww,fast)

%computes the baseline of the given data vector as the qq quantile on a
%moving window of size ww, with ww odd. The window is centered. The
%quantile on the window at the end of the vector is used for all the
%points closer to the ends of the vector than ww/2.
%%The input should be a matrix with the rows as single voxel fluorescence time
%%series, and the output will be a baseline matrix following the same format
%!NOT OPTIMISED FOR MEMORY CONSUMPTION, DO NOT FEED HUGE MATRICES AS AN INPUT

if ~isfloat(data_in)
    data_in=single(data_in);
end

data_in=data_in';

ww=2*floor(ww/2)+1;
%ww=2*round(ww/2)+1;

base_line=0*data_in;

gap=(ww-1)/2;
q_ini=quantile(data_in(1:ww,:),qq);
q_fin=quantile(data_in(end-gap:end,:),qq);

for i = 1:gap
    base_line(i,:)=q_ini;
    base_line(end-i+1,:)=q_fin;
end
nn=size(data_in,1);

if(fast)
parfor i = 1:nn-ww+1;
    %progression_info(i,nn-ww,100);
    base_line(i+gap,:)=quantile(data_in(i:i+ww-1,:),qq);
end
else
    for i = 1:nn-ww+1;
    %progression_info(i,nn-ww,100);
    base_line(i+gap,:)=quantile(data_in(i:i+ww-1,:),qq);
    end
end

base_line=base_line';
end
%{

ind_qq=round(ww*qq);

if ind_qq==0
    for i = 1:numel(data_in)-ww+1;
        ss=sort(data_in(i:i+ww-1));
        base_line(i+gap)=ss(1);
    end
    return
end


if ind_qq==ww
    for i = 1:numel(data_in)-ww+1;
        ss=sort(data_in(i:i+ww-1));
        base_line(i+gap)=ss(end);
    end
    return
end

aa=ww*qq-ind_qq+0.5
bb=1-aa

for i = 1:numel(data_in)-ww+1;
    ss=sort(data_in(i:i+ww-1));
    base_line(i+gap)=(aa*ss(ind_qq)+bb*ss(ind_qq+1))/2;
end
end
%}