function rename(manual, date, run, Dir)

% Parameters
if manual == 1
    % --- Select date
    fprintf('Please enter the run date:\n');
    in.date = input('?> ', 's');
    
    % --- Select run
    runs = dir([Dir 'Data' filesep in.date filesep 'Run *']);
    if numel(runs)>1
        fprintf('\nPlease select a run:\n');
        for i = 1:numel(runs)
            tmp = regexp(runs(i).name, 'Run (\d+)', 'tokens');
            fprintf('\t%i - %s\n', str2double(tmp{1}{1}), runs(i).name);
        end
        tmp = input('?> ', 's');
        in.run = str2double(tmp);
    else
        runs
        tmp = regexp(runs(1).name, 'Run (\d+)', 'tokens');
        in.run = str2double(tmp{1}{1});
    end
else
    in.date = date;
    in.run  = run;
end

% Create folder
Data_path = ['/home/ljp/Science/Projects/RLS/' 'Data' filesep in.date filesep 'Run ' num2str(in.run,'%02i') filesep];
[status,message,messageid] = mkdir([Data_path , 'Images_tif/']);

% Get all PDF files in the current folder
cd([Data_path, 'Images/']);
files = dir( '*.tif');

% Loop through each
for i = 1:length(files)
    % Get the file name (minus the extension)
    [~, f] = fileparts(files(i).name);
    
    
    movefile(files(i).name, [Data_path, 'Images_tif/','Images0_', num2str(i-1,'%05i'), '.tif'] );
end

% Rename folder
rmdir([Data_path, 'Images']);
movefile([Data_path, 'Images_tif/'],[Data_path, 'Images/']);