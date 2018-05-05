function SaveFor3DViezer(Layers,F)

%%
clear CalciumSig_all Coordinates_all

CalciumSig_all = [];
Coordinates_all = [];
for layer = Layers
    layer
    load( [F.Files  'signal_stacks/' num2str(layer) '/DFF_bg_seg.mat'],'DFF_pix' );
    %load( [F.Files  'signal_stacks/' num2str(layer) '/sig_seg.mat'],'DD' );
    load( [ F.Data  'Segmented/Layer_' num2str(layer) '.mat' ],'pos' );

    
    CalciumSig_all  = [ CalciumSig_all ; DFF_pix ] ;
    %CalciumSig_all  = [ CalciumSig_all ; DD.signal_stack ] ;
   
    coordinates3D   = [ pos  ones(length(pos),1) * layer*10/0.8 ];
   

    Coordinates_all = [Coordinates_all; coordinates3D ];
    
end

save([F.Files 'For_3D_Viewer.mat'],'CalciumSig_all','Coordinates_all');


    
