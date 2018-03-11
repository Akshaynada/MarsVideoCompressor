% Usage: ResultMatrix = ZigzagMx(M)
% Where 'M' is a Matrix of order m x n.
% Result would be zigzag Traversal of that Matrix
% 
% Example:
% If M =  1   4   7
%         2   5   8
%         3   6   9
% then
% ResultMatrix = 1     4     2     3     5     7     8     6     9
%
function ResultMatrix = ZigzagMx(M)
ind = reshape(1:numel(M), size(M));         %# indices of elements
ind = fliplr( spdiags( fliplr(ind) ) );     %# get the anti-diagonals
ind(:,1:2:end) = flipud( ind(:,1:2:end) );  %# reverse order of odd columns
ind(ind==0) = [];                           %# keep non-zero indices
ResultMatrix = M(ind);                      %# get elements in zigzag order
end