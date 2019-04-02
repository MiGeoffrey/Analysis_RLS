function [Tracking_sig, Tracking_time] = tracking_signal(Path)

%% =========== Load tracking signal
%file = dir([Path,'*Tracking.dat']);
fileID = fopen(Path);
Data = fread(fileID,[ 2, Inf ],'single=>single','ieee-le');
fclose(fileID);

Tracking = Data(2,2:2:end);
TimeTracking = Data(1,2:2:end);

TimeOffset = TimeTracking(1);
TimeTracking = TimeTracking - TimeOffset;

%% =========== Out put
Tracking_sig = Tracking;
Tracking_time = TimeTracking;
