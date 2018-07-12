%% calculate mean of phase maps
clear all
%% Brains
RefBrain= 'Run18_2018-05-22';

manip{1} = NT.Focus(root, study, '2018-05-29', 7, Analysis);
manip{2} = NT.Focus(root, study, '2018-05-29', 7, Analysis);
manip{3} = NT.Focus(root, study, '2018-05-29', 7, Analysis);

%% 
for k = (1:size(manip, 2))
    display(['Manip = ' num2str(k)]);
    F = manip{k};
    cd([F.Files 'Registration/reformatted_' RefBrain '/']);
    
    file = dir('*a_ras*');
    Ia(:,:,:,k) = double(nrrdread(file.name));
    
    file = dir('*b_ras*');
    Ib(:,:,:,k) = double(nrrdread(file.name));
    
    % Save phase registered phase map
    clear i
    Z(:,:,:,k) = Ia(:,:,:,k) + i * Ib(:,:,:,k);
    
    v_max = 0.3;
    clear imhsv
    for l = 1:size(Z(:,:,:,k),3)
        imhsv(:,:,1) =   mod(atan2(Ib(:,:,l,k),Ia(:,:,l,k)) , 2*pi) / (2*pi);
        imhsv(:,:,2) =   Ia(:,:,l,1)*0+1;
        imhsv(:,:,3) =   sqrt( Ia(:,:,l,k).^2 + Ib(:,:,l,k).^2 )/v_max;
        outdir = [F.Files 'Phase_map/PhaseMap_RGB_' RefBrain];
        [status,message,messageid] = mkdir(outdir);
    end
end

%% Calculate mean
clear i
Ia_mean = mean(Ia,4);
Ib_mean = mean(Ib,4);

%% Save RGB images
v_max = 0.3;
clear imhsv
for l = 1:size(Zm,3)
    imhsv(:,:,1) =   mod(atan2(Ib_mean(:,:,l),Ia_mean(:,:,l)) , 2*pi) / (2*pi);
    imhsv(:,:,2) =   Ia_mean(:,:,l,1)*0+1;
    imhsv(:,:,3) =   sqrt( Ia_mean(:,:,l).^2 + Ib_mean(:,:,l).^2 )/v_max;
    outdir = [F.Files 'Phase_map_mean/PhaseMap_RGB_' RefBrain];
    mkdir(outdir);
    imwrite(hsv2rgb(imhsv),[outdir '/' F.IP.prefix, num2str(l,'%02d') '.' F.IP.extension]);
end
