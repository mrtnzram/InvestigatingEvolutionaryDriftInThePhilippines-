% Load the required components
Coord = dlmread('datapath.coord');      % (nIndiv x 2)
Diffs = dlmread('datapath.diffs');      % (nIndiv x nIndiv)
load('datapath.dimns');                 % loads struct with fields x, y, spacing, etc.

% If you have SNPs, load them
% SNPs = dlmread('datapath.snps');      % (nIndiv x nSites)

% Construct Data struct
Data = struct();
Data.Coord = Coord;
Data.Diffs = Diffs;
Data.nIndiv = size(Coord, 1);
Data.nSites = 1000;  % change to actual number of SNP sites you used
Data.dimns = dimns;

% Optional: add SNPs
% Data.SNPs = SNPs;

% Save to .mat file
save('datapath.mat', 'Data');
