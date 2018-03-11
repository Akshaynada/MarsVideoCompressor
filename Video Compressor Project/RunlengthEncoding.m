% Usage: [Runlength] = RunlengthEncoding(B,m,n)
% Where B is the array to Encoded and m and n are size of matrix from 
% which Array B is obtained.
% Returns p x 2 matrix which is used for Runlength Decoding

function [Runlength] = RunlengthEncoding(B,m,n)

Runlength=zeros(1,2);
Runlength(1,1)=m;
Runlength(1,2)=n;
x=numel(B);
i=1;
k=1;

while k<x+1
    i=i+1;
    Runlength(i,1)=B(1,k);  
    Runlength(i,2)=1;
    k=k+1;
    while (k<x+1 && B(1,k)==Runlength(i,1) )
        Runlength(i,2)=Runlength(i,2)+1;
        k=k+1;
    end
end
Runlength = cast(Runlength,'single');
end