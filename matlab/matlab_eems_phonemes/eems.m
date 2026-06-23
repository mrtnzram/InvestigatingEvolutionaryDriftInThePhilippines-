%% Directory with the EEMS source scripts
sourcepath = 'C:/Users/ramma/Box/Ram_Ximena_Nicole/Indp Research Phillipine Languages/matlab_eems_phonemes';
addpath(fullfile(sourcepath, 'mscripts'));

%% Path to the EEMS input files (without file extensions)
datapath = fullfile(sourcepath, 'datapath');  % Assuming your files are named datapath.coord, etc.

%% Choose the size of the triangular grid (tune this depending on spatial density)
xDemes = 6;
yDemes = 4;

%% Output path for the MCMC results
simno = 1;
mcmcpath = sprintf('%s-g%dx%d-simno%d', datapath, xDemes, yDemes, simno);

%% Run EEMS on haploid data
MCMC_haploid(sourcepath, datapath, mcmcpath, xDemes, yDemes, ...
    'numMCMCIter', 24000, ...
    'numBurnIter', 10000, ...
    'numThinIter', 99);