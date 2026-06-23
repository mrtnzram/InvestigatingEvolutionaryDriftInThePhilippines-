%% Directory with the EEMS source scripts
sourcepath = 'C:/Users/ramma/Box/Ram_Ximena_Nicole/Indp Research Phillipine Languages/matlab_eems_phonemes_shuffled';
addpath(fullfile(sourcepath, 'mscripts'));

%% Path to the EEMS input files (without file extensions)
datapath = fullfile(sourcepath, 'datapath');  % Assuming your files are named datapath.coord, etc.

%% Choose the size of the triangular grid (tune this depending on spatial density)
xDemes = 6;
yDemes = 4;

for simno = 1:100
    % Run the shuffled input files script
    eems_phonemes_shuffled_input_files;  % Ensure this script is in the path
    
    % Define output path for the MCMC results
    mcmcpath = sprintf('%s-g%dx%d-simno%d', datapath, xDemes, yDemes, simno);

    % Run the MCMC function
    MCMC_haploid(sourcepath, datapath, mcmcpath, xDemes, yDemes, ...
        'numMCMCIter', 12000, ...
        'numBurnIter', 6000, ...
        'numThinIter', 99);

end