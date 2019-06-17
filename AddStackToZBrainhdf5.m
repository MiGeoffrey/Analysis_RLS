Line.Path = '/home/ljp/Science/Projects/RLS/Data/2019-05-17/Run 01/Analysis/Registration/zBrain_Elavl3-H2BRFP_198layers/BinaryValue';
Line.Name = 'VestibularVisualStimulationBinary';
close all
Line.Stack = zeros(1406, 621, 138, 'uint16');
for layer = 1:size(Line.Stack, 3)
    imgtmp = imread([Line.Path, '/layer', num2str(layer, '%03d'), '.tif']);
    Line.Stack(:,:,layer) = ((imgtmp(:,:, 1))/255)*(2^16-1);
    imshow(Line.Stack(:,:,layer));
    caxis auto
    disp(layer);
end
h5ZBPath = '/home/ljp/Science/Projects/RLS/Tools/zBrain/AnatomyLabelDatabase.hdf5';


%h5create(h5ZBPath, ['/', Line.Name], size(Line.Stack), 'Datatype', 'uint16', 'ChunkSize', [size(Line.Stack(:,:,1)), 1], 'Deflate', 9);
h5write(h5ZBPath, ['/', Line.Name], Line.Stack);