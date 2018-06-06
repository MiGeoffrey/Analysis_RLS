%% calculate mean of phase maps
clear all

RefBrain= 'LJPBrain_flipped';
manip{1} = getFocus('2017-07-12',6)
% manip{2} = getFocus('2016-12-07',3)
% manip{3} = getFocus('2016-12-07',3)
for k = 1
    k
    F = manip{k};
    %F = getFocus('2016-12-07',3);
    cd([F.Files 'Registration/reformatted_' RefBrain '/']);
    %cd([F.Files 'Registration/floating-stacks/']);

        
    file = dir('*a_ras*');
    Ia(:,:,:,k) = double(nrrdread(file.name));

    file = dir('*b_ras*');
    Ib(:,:,:,k) = double(nrrdread(file.name));

  %  load([F.Files 'Phase_map/out_all.mat']);

    
% save phase registered phase map 
    clear i
    Z(:,:,:,k) = Ia(:,:,:,k) + i * Ib(:,:,:,k);

    v_max = 50;
    % thres = 5;
    clear imhsv
    for l= 1:size(Z(:,:,:,k),3)
        l
        imhsv(:,:,1) =   mod(atan2(Ib(:,:,l,k),Ia(:,:,l,k)) , 2*pi) / (2*pi);             
        imhsv(:,:,2) =   Ia(:,:,l,1)*0+1;                  
        imhsv(:,:,3) =   sqrt( Ia(:,:,l,k).^2 + Ib(:,:,l,k).^2 )/v_max;                 %       

        %[rows, cols] = find(imhsv(:,:,3) < thres);
        %imhsv(rows,cols,3) = 0;

        % rgb = hsv2rgb(imhsv);
        % figure
        % image(rgb)
        % colorbar

        % Save images
        outdir = [F.Files 'Phase_map/PhaseMap_RGB_' RefBrain];
        [status,message,messageid] = mkdir(outdir);
        imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(l,'%02d') '.' F.IP.extension]);
    end


end

%% Preview
% v_max = 50;
% clear imhsv
% l= 90
% imhsv(:,:,1) =   mod(atan2(Ib(:,:,l,1),Ia(:,:,l,1)) , 2*pi) / (2*pi);          %  phi(:,:,l,1);    
% imhsv(:,:,2) =   Ia(:,:,l,1)*0+1;                 %  2^16;  
% imhsv(:,:,3) =   sqrt( Ia(:,:,l,1).^2 + Ib(:,:,l,1).^2 )/v_max;                 %  A(:,:,l,1);         
% 
% figure;imshow(hsv2rgb(imhsv))

%% calculate mean
clear i
Z(:,:,:,:) = Ia + i * Ib;
Zm = mean(Z,4);
%l=8;
%Zm = Z(:,:,:,1);
%%
v_max = 50;
% thres = 5;
clear imhsv
for l= 1:size(Zm,3)
imhsv(:,:,1) =   mod(atan2(Ib(:,:,l),Ia(:,:,l)) , 2*pi) / (2*pi);             
imhsv(:,:,2) =   Ia(:,:,l,1)*0+1;                  
imhsv(:,:,3) =   sqrt( Ia(:,:,l).^2 + Ib(:,:,l).^2 )/v_max;                 %       


%[rows, cols] = find(imhsv(:,:,3) < thres);
%imhsv(:,:,3) = imhsv(:,:,3)*0.5;
%imhsv(rows,cols,3) = 0;

% rgb = hsv2rgb(imhsv);
% figure
% image(rgb)
% colorbar

  % Save images
    outdir = [F.Files 'Phase_map_mean/PhaseMap_RGB_' RefBrain];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(l,'%02d') '.' F.IP.extension]);
end