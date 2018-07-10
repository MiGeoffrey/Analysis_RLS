function [idx, idx_] = select_neurons_manually(pos, R)

% Display
index = 1:size(pos,1);
vars =  struct('pos', pos, 'ind', index);
idx  = 1:(numel(R)-5000);
idx_ = setdiff(1:size(vars.pos,1) , idx);
imshow(rescalegd2(Gray));hold on;


while true
    clc
    fprintf('\t[Right click/two finger click] Free mode (zoom, translation, etc.)\n');
    fprintf('\t[Left click/ click] Switch neuron state (ON/OFF)\n');
    fprintf('\t[+] Group ON\n');
    fprintf('\t[-] Group OFF\n');
    fprintf('\t[s] Group switch (ON/OFF)\n');
    fprintf('\n\t[Middle click/b] Back to general segmentation menu.\n');
    h(1) = scatter(vars.pos(idx,1), vars.pos(idx,2), 'mo');
    hold on
    h(2) = scatter(vars.pos(idx_,1), vars.pos(idx_,2), 1, 'yo');
    
    
    [x, y, button] = ML.ginput(1);
    
    
    if isempty(button), continue; end
    
    
    switch button
        
        
        case 1      % Individual switch
            
            
            [~, mi] = min((vars.pos(:,1)-x).^2 + (vars.pos(:,2)-y).^2);
            if ismember(mi, idx)
                idx = setdiff(idx, mi);
                idx_ = union(idx_, mi);
            else
                idx = union(idx, mi);
                idx_ = setdiff(idx_, mi);
            end
            
            
        case 43    % Group ON
            
            
            % Get polygon
            tmp = imfreehand;%impoly;
            p = tmp.getPosition;
            delete(tmp);
            set(gcf,'Pointer','arrow');
            
            
            I = find(inpolygon(vars.pos(:,1), vars.pos(:,2), p(:,1), p(:,2)));
            idx = union(idx, I);
            idx_ = setdiff(idx_, I);
            
            
        case 45    % Group OFF
            
            
            % Get polygon
            tmp = imfreehand;%impoly;
            p = tmp.getPosition;
            delete(tmp);
            set(gcf,'Pointer','arrow');
            
            
            I = find(inpolygon(vars.pos(:,1), vars.pos(:,2), p(:,1), p(:,2)));
            idx = setdiff(idx, I);
            idx_ = union(idx_, I);
            
            
        case 115    % Group switch
            
            
            % Get polygon
            tmp = impoly;
            p = tmp.getPosition;
            delete(tmp);
            set(gcf,'Pointer','arrow');
            
            
            I = find(inpolygon(vars.pos(:,1), vars.pos(:,2), p(:,1), p(:,2)));
            tf = ismember(I, idx);
            idx = union(setdiff(idx, I(tf)), I(~tf));
            idx_ = union(setdiff(idx_, I(~tf)), I(tf));
            
            
        case 3
            break;
            
            
        case 98
            clc
            fprintf('Zoom mode. Pres [Enter] to resume.\n');
            pause
    end
    
    
    delete(h)
end