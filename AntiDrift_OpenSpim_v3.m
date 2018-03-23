function AntiDrift_OpenSpim_v3(Layers_stack_ref, Layers, F, ind_Refstack, execute)

% This function computes the Drift of the stack. It's performed with the z projection of each stack.
% The first stack is chosen like the reference stack.
% In some case, it's better if you use juste the first layers for the z
% projection to get all the countour of the brain.

% Nlayer = varargin{1}; which is the last layer to process
% execute = varargin{2};

%%
N_img_layer = length(F.set.frames); % Number of brain scans to correct

switch execute
    case 'false'
        % --- Define reference image ---
        F.select(F.sets(Layers(1)).id);
        Img1 = F.iload(ind_Refstack);
        tmp3D = zeros(Img1.height,Img1.width,size(Layers_stack_ref,2)); % preallocate tmp3D
        counter = 1;
        for i = Layers_stack_ref
            F.select(F.sets(i).id);
            Ref = F.iload(ind_Refstack);
            tmp3D(:,:,counter) = Ref.pix;
            counter = counter +1;
        end
        Ref.pix = max(tmp3D(:,:,:),[],3);
        figure;imshow(rescalegd2(Ref.pix));
        title([F.name])
%         
%         % --- Select ROI for drift correction ---
%         disp('Please select ROI for drift correction')
%         roi = imrect;
%         wait(roi);
%         pos = getPosition(roi);
%         bbox = [round(pos(1))  round(pos(1) + pos(3)) ...
%             round(pos(2))  round(pos(2) + pos(4))];
%         Ref.region(bbox);
        bbox = [45   914    53   566];
        Ref.region(bbox);
        
        % --- Drift correction ---
        tmp3D(:) = 0;
        dx = zeros(1,N_img_layer);
        dy = zeros(1,N_img_layer);
        for k = 1 : N_img_layer
            % Calculate z-projection of stack at first time point
            counter = 1;
            for i = Layers_stack_ref
                F.select(F.sets(i).id);
                Img = F.iload(k);
                tmp3D(:,:,counter) = Img.pix;
                counter = counter +1;
            end
            Img.pix = max(tmp3D(:,:,:),[],3);
            
            Img.region(bbox);
            
            [DX, DY] = Ref.fcorr(Img);
            Img.translate(-DY, -DX);
            dx(k) = DX;
            dy(k) = DY;
            
            if ~mod(k,50)
                plot(k-49:k,dy(k-49:k),'b*');hold on;plot(k-49:k,dx(k-49:k),'*r');
                title([F.name]);
                pause(0.1)
            end   
        end
        clear tmp3D
        % --- Save ---
        for i = Layers
            % --- Save bbox ---
            Dmat = F.matfile(['IP/', num2str(i) ,'/DriftBox']);
            Dmat.save(bbox, 'Bounding box for drift correction ([x1 x2 y1 y2])');
            % --- Save Drift.mat ---
            dmat = F.matfile(['IP/', num2str(i) ,'/Drifts']);
            dmat.save(dx, 'Drift in the x-direction, at each time step [pix]');
            dmat.save(dy, 'Drift in the y-direction, at each time step [pix]');
        end
end

switch execute
    case 'true'
        f = dir([F.Files 'IP']);
        f = regexp({f.name}, '[0-9]+', 'match');
        f = [f{:}];
        
        load([F.Files 'IP/' f{1} '/Drifts.mat'])
        for k = 1 : N_img_layer
            % Translate all images from stack
            for i = Layers
                F.select(F.sets(i).id);
                % Define reference image
                Img = F.iload(k);
                Img.translate(-dy(k), -dx(k));
                % Save corrected image
                Mtag = ['Images_cor/', num2str(i),'/'];
                itag = [Mtag,F.IP.prefix num2str(k, F.IP.format )];
                F.isave(Img.pix, '', 'bitdepth', 16, 'fname', F.fname(itag, F.IP.extension));
            end
        end
end




