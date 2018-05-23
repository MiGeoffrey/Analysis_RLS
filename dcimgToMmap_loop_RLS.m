
Date = '2018-05-22';

for Run_nb = [7,10,11,20,21]
    m = MmapOnDCIMG(['/home/ljp/Science/Projects/RLS_test/Data/', Date, '/Run ', num2str(Run_nb, '%02i'),'/rec00001']);
    load(['/home/ljp/Science/Projects/RLS_test/Data/', Date, '/Run ', num2str(Run_nb, '%02i'),'/rec00001.mat']);
    for i = 1:t
        for j = 1:z
            img_nb = (z*(i-1)+j)-1;
            imwrite(m(:,:,j,i),['/home/ljp/Science/Projects/RLS_test/Data/', Date, '/Run ', num2str(Run_nb, '%02i'), '/Images/Images0_', num2str(img_nb, '%05i'), '.tif'])
        end
    end
end
