function [Tracking_int] = tracking_interpolate(Time, Path)

%% =========== Load tracking signal
fileID = fopen(Path);
Data = fread(fileID,[ 2, Inf ],'single=>single','ieee-le');
fclose(fileID);

Tracking = Data(2,2:2:end);
TimeTracking = Data(1,2:2:end);

TimeOffset = TimeTracking(1);
TimeTracking = TimeTracking - TimeOffset;

%% =========== Out put
Tracking_int = interp1(TimeTracking(1:3000),Tracking(1:3000),Time); % interpolate tracking signal at time points where images were acquired
