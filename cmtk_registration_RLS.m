function cmtk_registration_RLS(F, RefBrain)
%%
%RefBrain => 'LJPBrain',  'ZBrain',  'ZBrain',  'LJPBrain',  'Ref_sym',  'zbb',  'RLS',  'LJPBrain_flipped'

%% Configure action
% Select Data

cd(F.Files) % all pathes will be defined relative to F.Files as the unix shell cannot work with the space before the Run number

% --- define action
make_nrrd = 1;      %create nrrd from grey stack
register = 1;        %perform registration
warp=0;             %use warp 2if registration is performed
reformat=1;         %create reformatted stack after registration
reformat_reg = 1;
reformat_zBrain = 0;

% --- Parameters setting for make_nrrd
param.exp_type = '';
param.binning = [1 1];
%param.pix_size = [0.8 0.8 2]; % Parameters for the LJP brain
param.pix_size = [0.4 -0.4 -10] % Raw data head on the bottom;%[F.dx F.sets(2).z - F.sets(1).z] % cmtk space is right-anterior-superior
param.space_type = 'RAS';

% define cmkt folder
cmtkdir= '/Users/Projects/RLS/Tools/Fiji.app/bin/cmtk/';

% define folder where registration is saved
RegistrationDir = 'Registration/';

% get refbrain path
RefBrain_Folder = '/Users/Projects/RLS/Data/RefBrains/';
switch RefBrain
    case 'ZBrain'
        RefBrain_path=[RefBrain_Folder 'ZBrain_Elavl3-GCaMP5G_6dpf_MeanImageOf7Fish_01_ras.nrrd'];%reference brain used for all transformation
    case 'LJPBrain'
        RefBrain_path= [RefBrain_Folder 'LJP_mean_refbrain_01_ras.nrrd'];%reference brain used for all transformation
    case 'Ref_sym'
        RefBrain_path= ['Registration/affine_Ref_sym/grey_stack_ras_mirrored.nrrd'];%reference brain used for all transformation
        % RefBrain_path= [RefBrain_Folder 'Ref_sym.nrrd'];%reference brain used for all transformation
    case 'zbb'
        RefBrain_path= [RefBrain_Folder 'zbb_HuC-GCaMP5.nrrd'];%reference brain used for all transformation
    case 'RLS'
        RefBrain_path= [RefBrain_Folder 'Ref_sym_2016-12-03_Run3.nrrd'];%reference brain used for all transformation
    case 'LJPBrain_flipped'
        RefBrain_path= [RefBrain_Folder 'LJP_mean_refbrain_01_flipped_ras.nrrd'];%reference brain used for all transformation
end

%% make nrrd of a stack saved as image sequence in a folder in F.Files
if make_nrrd 
    % === define in and output folders
    inFolder = 'grey_stack';
    outName = [inFolder '_ras'];
    % === define save location of created nrrd stack
    outFolder = 'Registration/floating-stacks/';
    % === calculate and save nrrd stack
    make_nrdd_stack_RLS_v2(inFolder,outFolder,outName, param);
end

switch RefBrain 
    case 'Ref_sym'
        inFolder = 'grey_stack';
        outName = [inFolder '_ras_mirrored'];
        outFolder = 'Registration/affine_Ref_sym/';

        %param.pix_size = [-0.8 0.8 2];%
        param.pix_size =[-0.8 0.8 -10]; 
        Raw data head on the bottom; %[F.dx F.sets(2).z - F.sets(1).z] % cmtk space is right-anterior-superior
        make_nrdd_stack_RLS_v2(inFolder,outFolder,outName, param);
end
%% register a floating stack on a selected reference brain
% === define which floating stack to map
float_name = 'grey_stack_ras'; % name of the floating stack to register

% === define output
[status,message,messageid] =mkdir(RegistrationDir)

TransAffine_path     = [ RegistrationDir 'affine_' RefBrain];
TransWarp_path       = [ RegistrationDir 'warp_' RefBrain];
FloatingStack_path   = [ RegistrationDir 'floating-stacks/' float_name '.nrrd'];

% === perform registration
if register
    if warp
            stacks=[' --initial ./' TransAffine_path ' -o  ./' TransWarp_path  ' ' RefBrain_path ' ' FloatingStack_path  ];
            %options= 'warp -v --grid-spacing 40 --refine 2 --jacobian-weight 1e-5 --coarsest 6.4 --sampling 3.2 --accuracy 3.2 ';
            option = 'warpx --fast --grid-spacing 100 --smoothness-constraint-weight 1e-1 --grid -refine 2 --min-stepsize 0.25 --adaptive-fix-thresh 0.25';
    else
            stacks=['-o ./' TransAffine_path  ' ' RefBrain_path ' ' FloatingStack_path  ];
            % option , path where transformation is saved , location of ref brain, location of floating strack to map on ref brain
            options= 'registration -i -v --coarsest 25.6 --sampling 3.2 --omit-original-data --exploration 25.6 --dofs 6 --dofs 9 --accuracy 3.2 ';
    end
    command=[cmtkdir options stacks];
    tic
    unix(command,'-echo');
    toc
    disp('finished')
end

switch RefBrain 
    case 'Ref_sym'
    % === read affine parameters of cmtk registration

    filename = [F.Files 'Registration/affine_Ref_sym/registration']
    delimiter = {'\t',' '};
    formatSpec = '%q%q%q%f%f%f%[^\n\r]';
    fileID = fopen(filename,'r');
        dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'EmptyValue' ,-1.0, 'ReturnOnError', false);
    fclose(fileID);
    dataArray([4, 5, 6]) = cellfun(@(x) num2cell(x), dataArray([4, 5, 6]), 'UniformOutput', false);
    registration = [dataArray{1:end-1}];
    clearvars filename delimiter formatSpec fileID dataArray ans;
    
    % ==== write new affine registration file with rotation angle divided by 2 
    str = sprintf(['! TYPEDSTREAM 2.4' '\n' ...
                  '\n' ...
                  'registration {' '\n' ...
                  '\t' 'reference_study "/Users/work/Documents/Science/Projects/RLS/Data/RefBrains/Ref_sym.nrrd"' '\n' ...
                  '\t' 'floating_study "Registration/floating-stacks/grey_stack_ras.nrrd"' '\n' ...
                  '\t' 'affine_xform {' '\n' ...
                  '\t\t' 'xlate '  num2str(cell2mat(registration(6,4))/2) ' ' num2str(cell2mat(registration(6,5))  ) ' ' num2str(cell2mat(registration(6,6))  ) ' \n' ...
                  '\t\t' 'rotate ' num2str(cell2mat(registration(7,4))  ) ' ' num2str(cell2mat(registration(7,5))/2) ' ' num2str(cell2mat(registration(7,6))/2) ' \n' ... % tilt, rolling, yaw
                  '\t\t' 'scale '  num2str(cell2mat(registration(8,4))  ) ' ' num2str(cell2mat(registration(8,5))  ) ' ' num2str(cell2mat(registration(8,6))  ) ' \n' ... 
                  '\t\t' 'shear '  num2str(cell2mat(registration(9,4))/2) ' ' num2str(cell2mat(registration(9,5))/2) ' ' num2str(cell2mat(registration(9,6))/2) ' \n' ... 
                  '\t\t' 'center ' num2str(cell2mat(registration(10,4))  ) ' ' num2str(cell2mat(registration(10,5))  ) ' ' num2str(cell2mat(registration(10,6))  ) ' \n' ... 
                  '\t' '}' '\n' ...     
                  '}' ... 
                  ],'w','o') 

    fileID = fopen([F.Files 'Registration/affine_Ref_sym/registration'],'w');
        fprintf(fileID,str)
    fclose(fileID);
end
%% reformat registered grey stack
ReformatedStack_path = [ RegistrationDir 'reformatted_' RefBrain '/' float_name '_' RefBrain '.nrrd'];  % output stack

if reformat
    if warp
        command=['"' cmtkdir 'reformatx" -o ' ReformatedStack_path ' --floating ' FloatingStack_path ' ' RefBrain_path ' ' TransWarp_path];
    else
        command=['"' cmtkdir 'reformatx" -o ' ReformatedStack_path ' --floating ' FloatingStack_path ' ' RefBrain_path ' ' TransAffine_path ];
    end
    unix(command, '-echo');
end

%% Reformat all floating stacks

TransAffine_path     = [ RegistrationDir 'affine_' RefBrain];
FloatingStack_folder = 'Registration/floating-stacks';
cd(F.Files)

if reformat_reg
    stack_list = dir([FloatingStack_folder '/*nrrd']);
    for i = 1:length(stack_list)
        FloatingStack_path   = [ FloatingStack_folder '/'  stack_list(i).name];                     % input stack
        ReformatedStack_path = [ RegistrationDir 'reformatted_' RefBrain '/' stack_list(i).name];   % output stack
        if reformat
            if warp
                command=['"' cmtkdir 'reformatx" -o ' ReformatedStack_path ' --floating ' FloatingStack_path ' ' RefBrain_path ' ' TransWarp_path];
            else
                command=['"' cmtkdir 'reformatx" -o ' ReformatedStack_path ' --floating ' FloatingStack_path ' ' RefBrain_path ' ' TransAffine_path];
            end
            unix(command, '-echo');
        end
    
    end
end