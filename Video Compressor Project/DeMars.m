% Usage: Result = DeMars(file)
%
% Where 'file' is intermediate file resulted from the Mars function
% V is the VideoWriter Object which Contains the result video Details
% DeMars plays the Result video file at the end of decompression

function [Result] = DeMars(file)
clc;
%close all;
%file = 'video_mpg_mars.mat';
try
    load(file);
catch lasterr
    Result = char(lasterr.message);
    errordlg(Result, 'Error', 'modal');
    return;
end
    
nFrames = size(Runlength,2);
m = Runlength(1).y(1,1);
n = Runlength(1).y(1,2);
mov(1:nFrames) = ...
    struct('cdata',zeros(m,n,3,'uint8'), ...
        'colormap',[]);
    
h = waitbar(0,'Decompression On Process ...');    

for k = 1 : nFrames
   Y  = RunlengthDecoding(Runlength(k).y); 
   CB = RunlengthDecoding(Runlength(k).cb);
   CR = RunlengthDecoding(Runlength(k).cr);
   
   Y = AntiZigzagMx(Y,m,n);
   CB = AntiZigzagMx(CB,m,n);
   CR = AntiZigzagMx(CR,m,n);
   
   Y = idct2(Y);
   CB = idct2(CB);
   CR = idct2(CR);
   
   Y = cast(Y,'uint8');
   CB = cast(CB,'uint8');
   CR = cast(CR,'uint8');
   
   NewImage = cat(3,Y,CB,CR);
   NewImage = ycbcr2rgb(NewImage);
   
   mov(k).cdata = NewImage;
    
   clc;
   display ('Decompression Process ...');
   LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
   disp(LOAD);
   waitbar(k/nFrames,h)
end
waitbar(k/nFrames,h,'Decompression Completed');
delete(h);
    display('Completed');
    file = strrep(file,'_','');
    file = strrep(file,'.','');
    file = strrep(file,'mars','');
    Result = strrep(file,'mat','');
    
   % movie2avi(mov,Result,'compression','None','keyframe','3');
    V = VideoWriter(Result);
    open(V);
    writeVideo(V,mov);
    close(V);
    %close;
    Result = strcat(Result,'.avi');
    temp = sprintf('Result Video : %s',Result);
    disp(temp);
   % implay(Result,30);
end