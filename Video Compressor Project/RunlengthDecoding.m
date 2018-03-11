% Usage : B = RunlengthDecoding(Runlength)
%
% Where Runlength is the m x 2 matrix which is the result of the function
% 'RunlengthEncoding' and returns an array B.

function B = RunlengthDecoding(Runlength)
m=Runlength(1,1);
n=Runlength(1,2);

B=zeros(1);
k=1;
i=1;
while k<m*n +1
    i=i+1;
    B(1,k)=Runlength(i,1);
    k=k+1;
%     j=Runlength(i,2);
    for j=1:Runlength(i,2)-1
        B(1,k)=Runlength(i,1);
        k=k+1;
    end
end
end