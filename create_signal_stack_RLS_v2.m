function create_signal_stack_RLS_v2(Layers, binsize, F, ind_Refstack)
%%
for layer = Layers
    try
        load([F.Files 'signal_stacks/' num2str(layer) '/' 'contour.mat']);
    catch ME
        Limg = @(n) double(imread([F.Data 'Images/' F.IP.prefix num2str(n, F.IP.format) '.tif']));
        Img1 = Limg(size(F.sets,2)*(ind_Refstack-1)+(layer-1));
         
        Img1sm = imresize(Img1,1/binsize);
        figure(100);
        imshow(rescalegd(Img1sm));
        if binsize == 10
            BW = ones(size(Img1sm,1),size(Img1sm,2),'logical');
            w = find(BW==1);
        else
            BW = roipoly;
            w = find(BW==1);
        end

        % --- Out directorties ---
        outdir = [F.Files 'signal_stacks/' num2str(layer) '/'];
        [status, message, messageid] = rmdir(outdir,'s');
        mkdir(outdir)
        save([F.Files 'signal_stacks/' num2str(layer) '/' 'contour.mat'], 'w');
    end
    W{layer-(Layers(1)-1)} = w;
end

%%
for layer = Layers
    fprintf('layer = %i',layer)
    
    % --- Directory of the corrected images ---
    ddir = [F.Files 'Images_cor/' num2str(layer) '/'];
    
    % --- Out directorties ---
    outdir = [F.Files 'signal_stacks/' num2str(layer) '/'];
    
    ind = num2str(layer,'%02i');
    mean_image_save = [F.Files 'grey_stack/Image_' ind '.tif'];
    mkdir([F.Files 'grey_stack'])
    
    D = dir([F.Files 'Images_cor/' num2str(layer) '/' '*' '.tif']);
    Nimages = numel(D);
    
    Limg = @(n) double(imread([F.Files 'Images_cor/' num2str(layer) '/' F.IP.prefix num2str(n, F.IP.format) '.tif']));
    Img1 = Limg(1);
    
    Img1sm = imresize(Img1,1/binsize);
    Imgmean = double(Img1sm);
    size(W{layer-(Layers(1)-1)})
    sigstack = uint16(zeros(size(W{layer-(Layers(1)-1)},1),Nimages));
    
    for n=1:Nimages;
%         tic
        Img = Limg(n);
        Imgsm = imresize(Img,1/binsize);
        Imgmean = Imgmean+Imgsm;
        sigstack(:,n) = Imgsm(W{layer-(Layers(1)-1)});
%         if mod(n,100)==1
%             fprintf('Image #%i ...', n);
%             fprintf(' %.2fsec\n', toc);
%         end
    end
    
    DD.signal_stack=sigstack;  % matrices pixels_intensite xtemps
    DD.index = W{layer-(Layers(1)-1)};                 % indices linéaires des pixels
    DD.imgref = Imgsm;            % images de réferejnce
    save([outdir 'sig.mat'],'DD');
    imwrite(uint16(Imgmean/Nimages),mean_image_save);
    
end