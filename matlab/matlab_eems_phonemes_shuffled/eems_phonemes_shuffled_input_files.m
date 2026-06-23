% Load the dissimilarity matrix from the file
dissimilarityMatrix = load('datapath.diffs');

% Ensure the matrix is symmetric
if ~isequal(dissimilarityMatrix, dissimilarityMatrix')
    error('The matrix is not symmetric.');
end

% Get the size of the matrix
n = size(dissimilarityMatrix, 1);

% Generate a random permutation of indices
shuffledIndices = randperm(n);

% Create a new matrix using the shuffled indices
shuffledMatrix = dissimilarityMatrix(shuffledIndices, shuffledIndices);

% Display the original and shuffled matrices
disp('Original Dissimilarity Matrix:');
disp(dissimilarityMatrix);
disp('Shuffled Dissimilarity Matrix:');
disp(shuffledMatrix);

% Save the shuffled matrix back to the file as a tab-delimited text file
writematrix(shuffledMatrix, 'datapath.diffs', 'Delimiter', 'tab', 'FileType', 'text');
