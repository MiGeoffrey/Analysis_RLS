function create_contour_RLS(Layers, F, ind_Refstack,binsize)
%%
for layer = Layers
    try
        load([F.Files 'signal_stacks/' num2str(layer) '/' 'contour.mat']);
    catch ME
        Limg = @(n) double(imread([F.Data 'Images/' F.IP.prefix num2str(n, F.IP.format) '.tif']));
        Img1 = Limg(size(F.sets,2)*(ind_Refstack-1)+(layer-1));        
        Img1sm = imresize(Img1,1/binsize);
        
        % Auto brain countour
        bg_img = mean2(Img1sm);
        H = fspecial('disk',20);
        tmp1 = imfilter(Img1sm,H,'replicate');
        tmp2 = Img1sm*0;
        tmp2(tmp1>bg_img*(1-(0.005*layer))) = 1;
        tmp2 = bwareaopen(tmp2,(size(Img1sm,1)*size(Img1sm,2))/4);
        
        [B, L] = bwboundaries(tmp2,'noholes');
        clear L;
        figure(100);imshow(rescalegd(Img1sm));
        hold on
        [x, y] = reducem(B{1}(:,1), B{1}(:,2), 10);
        boundary = [y, x];
        for k = 1:length(B)
            plot(boundary(:,1), boundary(:,2), 'r', 'LineWidth', 2)
        end
        poly = impoly(gca, boundary);
        boundary_2 = poly.wait;
        BW = poly2mask(boundary_2(:,1), boundary_2(:,2), size(tmp2,1), size(tmp2,2));
        w = find(BW==1);
        
        % Manual brain countour
%         if binsize == 10
%             BW = ones(size(Img1sm,1),size(Img1sm,2),'logical');
%             w = find(BW==1);
%         else
%             BW = roipoly;
%             w = find(BW==1);
%         end

        % --- Out directorties ---
        outdir = [F.Files 'signal_stacks/' num2str(layer) '/'];
        [status, message, messageid] = rmdir(outdir,'s');
        mkdir(outdir)
        save([F.Files 'signal_stacks/' num2str(layer) '/' 'contour.mat'], 'w');
    end
    W{layer-(Layers(1)-1)} = w;
end