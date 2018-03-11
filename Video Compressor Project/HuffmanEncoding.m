% Usage: [Encoded_Array Dictionary] = HuffmanEncoding(A)
% Where 'A' is an m x n Matrix or an array

function [Encoded Dict] = HuffmanEncoding(A)
% A = reshape(A(1:numel(A)),[numel(A) 1]);
Auniq = unique(A);
Frequency = histc(A(:),Auniq);
Total = numel(A);
Prob = Frequency./Total;
[Dict,~] = huffmandict(Auniq,Prob,2,'min'); 
Encoded = cast(huffmanenco(A(:),Dict),'uint8');
end