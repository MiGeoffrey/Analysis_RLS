function new_coord = convertCoordinates_RLS(coordinates, xformlist, param3)
% Store.convertCoordinates. This function uses streamxform from cmtk to 
% convert a set of x,y,z points coordinates from target to source 
% (or source to target), using an xform list produced by cmtk registration.
%
% INPUT :
% coordinates           a Nx3 array of points coordinates
% xformlist             the complete xformlist directory name
%
% optional parameter
% param3                if this parameter is "inverse', perform the inverse
%                       conversion (source to target)
%
% OUTPUT
% new_coord             a Nx3 array of new points coordinates
%
% Note: with the inverse mode, it may happen that some points are beyond
% the volume that can be converted (for wrap registration), and the
% conversion fails. The converted coordinates are then set to NaN. The
% number of failed points is displayed.
%
% Georges Debregeas 2018-05-30

cmtkbindir = '/usr/local/lib/cmtk/bin'; % cmtk bin directory, where to find streamxform

wfin = find(isfinite(coordinates(:, 1)));   % get indices of real coordinates (non NaN)
wnan = find(isnan(coordinates(:, 1)));       % get indices of NaN coordinates
fin_coordinates = coordinates(wfin, :);
Npoints = size(fin_coordinates, 1);          % number of points to be converted

% if size(wnan>0)
%     disp([num2str(length(wnan)) ' points are NaN'])
% end

Nmax=2500;  % block-size - this is to avoid memory issues when converting large number of points

% testing if 'inverse' keyword is present
if ~exist('param3','var')
    param3 = '';
end
if strcmp(param3, 'inverse')
    param3 = '--inverse';
end


fin_new_coord = [];
fail = 0;

%loop on blocks of max size Nmax
for p = 0:floor(Npoints/Nmax)
    
    % Build char list containing coordinates to transform
    coord=[];
    for n=(p*Nmax+1):min(Npoints,(p+1)*Nmax)
        XYZ = [num2str(fin_coordinates(n, 1)) ' ' , ...
            num2str(fin_coordinates(n, 2)) ' ' num2str(fin_coordinates(n, 3)) '\n'];
        coord = [coord XYZ];
    end
    
%     disp(['converted ', num2str(n), ' points out of ', num2str(Npoints)]);
    
    command = ['echo -e "' coord '" | "' cmtkbindir filesep 'streamxform" ' '-- ' param3 ' ' xformlist ];
    [~, cmdout] = unix(command);
    
    % extract the result, and detect non-converted points
    a = textscan(cmdout,'%s','Delimiter','\n');
    np = min(Npoints,(p+1)*Nmax)-(p*Nmax+1)+1; % number of points
    
    for index = 1:np
        b = a{1}{index};
        c = textscan(b, '%s');
        if size(c{1}, 1) == 4 % this happens when a FAILED is returned
            fail = fail + 1;
            fin_new_coord = vertcat(fin_new_coord, [NaN NaN NaN]);
        else
            nn = strread(b);
            fin_new_coord = vertcat(fin_new_coord, nn(:,1:3));
        end
    end
end


new_coord = zeros(size(coordinates));
if ~isempty(wnan)>0
    new_coord(wnan, :) = NaN*ones(length(wnan),3); % put NaN where the original coordinates were NaN
end

fprintf('Conversion failed for %i points.\n', fail);
new_coord(wfin, :) = fin_new_coord; % get the converted values
end