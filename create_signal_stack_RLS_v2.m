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
    
    try
        'Create signal stack on segmented data'
        pos=1;
        load([F.Data 'Segmented/Layer_',num2str(layer) ,'.mat']);
        size(pos, 1);
        sigstack = uint16(zeros(size(pos, 1),Nimages));
        for n=1:Nimages
            try
                Img = Limg(n);
            catch
                'Error with the image drift corrected number: '
                n
                F.select(F.sets(layer).id);
                % Define reference image
                Img = F.iload(n);
                Img.translate(-dy(n), -dx(n));
                % Save corrected image
                Mtag = ['Images_cor/', num2str(layer),'/'];
                itag = [Mtag,F.IP.prefix num2str(n, F.IP.format )];
                F.isave(Img.pix, '', 'bitdepth', 16, 'fname', F.fname(itag, F.IP.extension));
                Img = Limg(n);
            end
            Imgmean = Imgmean+Img;
            for neu = 1:size(pos, 1)
                sigstack(neu,n) = mean(Img(plist{neu}));
            end
        end
        
        DD.signal_stack=sigstack;  % matrices pixels_intensite xtemps
        DD.index = sub2ind(size(Img), round(pos(:,2)), round(pos(:,1)));                 % indices linéaires des pixels
        DD.imgref = Img;            % images de réferejnce
        index = DD.index;
        save([outdir 'sig_seg.mat'],'DD','index' );
        imwrite(uint16(Imgmean/Nimages),mean_image_save);
    catch
        'Create signal stack on No segmented data'
        size(W{layer-(Layers(1)-1)})
        sigstack = uint16(zeros(size(W{layer-(Layers(1)-1)},1),Nimages));
        for n=1:Nimages
            try
                Img = Limg(n);
            catch
                'Error with the image drift corrected number: '
                n
                F.select(F.sets(layer).id);
                % Define reference image
                Img = F.iload(n);
                Img.translate(-dy(n), -dx(n));
                % Save corrected image
                Mtag = ['Images_cor/', num2str(layer),'/'];
                itag = [Mtag,F.IP.prefix num2str(n, F.IP.format )];
                F.isave(Img.pix, '', 'bitdepth', 16, 'fname', F.fname(itag, F.IP.extension));
                Img = Limg(n);
            end
            Imgsm = imresize(Img,1/binsize);
            Imgmean = Imgmean+Imgsm;
            sigstack(:,n) = Imgsm(W{layer-(Layers(1)-1)});
        end
        DD.signal_stack=sigstack;  % matrices pixels_intensite xtemps
        DD.index = W{layer-(Layers(1)-1)};                 % indices linéaires des pixels
        DD.imgref = Imgsm;            % images de réferejnce
        index = DD.index;
        save([outdir 'sig.mat'],'DD', 'index');
        imwrite(uint16(Imgmean/Nimages),mean_image_save);
    end
    
    
end