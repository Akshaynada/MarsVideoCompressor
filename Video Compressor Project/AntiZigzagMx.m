% Usage: ResultMatrix = AntiZigzagMx(M,row,col); 
% Where M is an Array type and 'row'&'col' are the size of the Result
% Matrix. 
% 
% Example: If M =    1     2     3     4     5     6     7     8     9
% and row=col=3 then
% ResultMatrix =    1     2     6
%                   3     5     7
%                   4     8     9
                    
function ResultMatrix = AntiZigzagMx(M,row,col)
ind = reshape(1:numel(M),row,col);          %# indices of elements
ind = fliplr( spdiags( fliplr(ind) ) );     %# get the anti-diagonals
ind(:,1:2:end) = flipud( ind(:,1:2:end) );  %# reverse order of odd columns
ind(ind==0) = [];                           %# keep non-zero indices
ResultMatrix(ind) = M(1:numel(M));          %# the antizigzag array
ResultMatrix  = reshape(ResultMatrix(1:numel(ResultMatrix)),row,col);  
                                            %# convert array to matrix
end