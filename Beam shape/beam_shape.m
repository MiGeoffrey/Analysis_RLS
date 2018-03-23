%%
clc
clear all
close all

%% Data
datadir{1} = '/home/ljp/Bureau/Geoffrey/Resultats/faisceaux/Images_ref.tif' % img ref
datadir{2} = '/home/ljp/Bureau/Geoffrey/Resultats/faisceaux/faisceau zeizz zeizz_2015-03-31.tif' % zeizz zeizz
%datadir{2} = '/home/ljp/Bureau/Geoffrey/2015-03-13/Run 01/faisceau f = 150mm.tif'; % f = 150mm
%datadir{3} = '/home/ljp/Bureau/Geoffrey/2015-03-09/Run 01/faisceau f = 25mm.tif'; % f = 25mm
%datadir{3} = '/home/ljp/Bureau/Geoffrey/2015-03-30/Run 01/fasceau obj nikon zeizz.tif' % nikon zeizz
datadir{3} = '/home/ljp/Bureau/Geoffrey/Resultats/faisceaux/faisceau_setup_vertical_rotation_2015-05-13.tif'; % setup vertical
%datadir{4} = '/home/ljp/Bureau/Geoffrey/2015-03-09/Run 01/faisceau f = 15mm.tif'; % f = 15mm
%datadir{4} = '/home/ljp/Bureau/Geoffrey/2015-03-30/Run 01/fasceau obj nikon leica1.1.tif' ; % nikon leica
datadir{4} = '/home/ljp/Bureau/Geoffrey/Resultats/faisceaux/faisceau_16_06_2015.tif' %zeizz zeizz et cube 3cm
%img2 = img(:,1000:2000);

%% Plot image beam and Compute and plot the 1/e^2 width of each stack
figure(1)
for i=1:4
    clear w0_exp
    % Plot image
    subplot(2,4,i);
    img = imread(datadir{i});
    imshow((rescalegd(img')));
    title(datadir{i}(45:end),'interpreter','none');

    % Compute and plot the 1/e^2 width of each stack
    [Lx Ly] = size(img)

    % Config fit
    opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
    opts.Display = 'Off';
    ft = fittype( 'A*exp(-((x-x0)/w)^2) + y0', 'independent', 'x', 'dependent', 'y','coefficients',{'A','x0','w','y0'} );

    % Figure;
    inc = 10 % increment between stack
    k=1
    for j = 1:inc:Lx
        xData = [1:Ly]*0.4;   % in um
        yData = double(img(j,:)); % line profile
        yData = yData - mean(yData(1:10));
        
        % fit data
        opts.StartPoint = [max(yData) mean(find(yData==max(yData)))*0.4 5 mean(yData(1:10))];
        [fitresult, gof] = fit( xData', yData', ft, opts );
        w0_exp(k) = fitresult.w*sqrt(2); %  half width at 1/e^2 
        k=k+1;
    end
    subplot(2,4,i+4);
    plot([1:inc:Lx]*0.4-find(w0_exp==min(w0_exp))*inc*0.4 ,w0_exp)
    grid on
    
    % Plot of theorical width
    hold on
    w_0 = min(w0_exp);
    w = @(x) w_0*sqrt(1+((488e-03*x)/(pi*w_0^2))^2);
    fplot(w,[-200,200], 'r');
    legend('Experimental mesure of the profile','w(x) = \omega_0 (1+(\lambdax / \pi\omega_0^2)^2)^{1/2}');
    ylim([0 20])
    title(['Experimental and theoretical width of \newline the light sheet with a waist = ', num2str(w_0)])
    ylabel 'Width at 1/ e^2 [\mum]'
    xlabel 'Distance from the waist (x) [\mum]'

end