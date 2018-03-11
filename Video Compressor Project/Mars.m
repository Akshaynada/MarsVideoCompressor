% Usage [FileName CR] = Mars(VideoName)
%
% Where Mars takes 'VideoName' as the input and compress the specified
% video the returns the intermediate compressed file to 'FileName'.
% 'VideoName' is the path of the video file(string) and
% 'FileName' is the  path of the intermediate file(string).

function [FileName CompRatio] = Mars(VideoName)
fontsize=14;
% -------------------------------------------------------------------- %
%                   Reading viedo file and get info                    %
% -------------------------------------------------------------------- %

%VideoName = 'video.mpg';
try
    Myvideo = VideoReader(VideoName);
catch lasterr 
    errordlg(lasterr.message,'Error');
    return;
end

% Storing Information

nFrames = Myvideo.NumberOfFrames;
vidHeight = Myvideo.Height;
vidWidth = Myvideo.Width;
display('Video Reading is Completed');

% -------------------------------------------------------------------- %
%                Storing Each frame as separate Image                  %
% -------------------------------------------------------------------- %

% Preallocate movie structure.
mov(1:nFrames) = ...
    struct('cdata', zeros(vidHeight, vidWidth, 3, 'uint8'),...
           'colormap', []);
       
[~,baseFileName,~] = fileparts(VideoName);
folder = pwd; 
outputFolder = sprintf('%s/Movie Frames from %s', folder,baseFileName);
if ~exist(outputFolder, 'dir')
    mkdir(outputFolder);
end
numberOfFramesWritten=0;
% Read one frame at a time.

for k = 1 : nFrames
    mov(k).cdata = read(Myvideo, k);
     % display image
     thisFrame = mov(k).cdata;
     figure(1);
     image(thisFrame);
     axis 'auto z';
     caption = sprintf('Frame %3d of %d', k, nFrames);
     title(caption, 'FontSize', fontsize);
     drawnow; % Force it to refresh the window.
    
    % Construct an output image file name.
    outputBaseFileName = sprintf('Frame %2.2d.png', k);
    outputFullFileName = fullfile(outputFolder,outputBaseFileName);
    imwrite(mov(k).cdata, outputFullFileName, 'png');
    % pause(0.1);
    numberOfFramesWritten = numberOfFramesWritten + 1;
    clc;
    display('Coping Each Frames.');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
end
done=numberOfFramesWritten;
disp(done);
clear outputBaseFileName outputFullFileName mov thisFrame ...
    caption title folder baseFileName numberOfFramesWritten done fontsize;

% -------------------------------------------------------------------- %
%      Convert Frame to YCBCR formate and Store Y,Cb,Cr separatly      %
% -------------------------------------------------------------------- %
    Y(vidHeight,vidWidth,nFrames) = zeros;
    CB(vidHeight,vidWidth,nFrames) = zeros;
    CR(vidHeight,vidWidth,nFrames) = zeros;
    
for k = 1: nFrames
    framename = sprintf('%s/Frame %2.2d.png',outputFolder,k);
    PresentImage = imread(framename);
    
    NewImage = rgb2ycbcr(PresentImage);
    
    Y(:,:,k) = NewImage(:,:,1);
    CB(:,:,k) = NewImage(:,:,2);
    CR(:,:,k) = NewImage(:,:,3);
   
% -------------------------------------------------------------------- %
%                Finding Discrete Cosine Transform                     %
% -------------------------------------------------------------------- %

    Y(:,:,k)  =  dct2(Y(:,:,k));
    CB(:,:,k) =  dct2(CB(:,:,k));
    CR(:,:,k) =  dct2(CR(:,:,k));
             
    clc;
    display (' Computing DCT matrices');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
    figure(1);
    axis square
    subplot(2,2,1); image(PresentImage); title('Original Image');
    subplot(2,2,2); image(Y(:,:,k)); title('Y Matrix');
    subplot(2,2,3); image(CB(:,:,k)); title('CB Matrix');
    subplot(2,2,4); image(CR(:,:,k)); title('CR Matrix');
end

Y(abs(Y) < 10) =0;
CB(abs(CB) < 10) =0;
CR(abs(CR) < 10) =0;

% -------------------------------------------------------------------- %
%                       Zigzag Traversal                               %
% -------------------------------------------------------------------- %

Z_Y = zeros(vidHeight*vidWidth,nFrames);
Z_CB= zeros(vidHeight*vidWidth,nFrames);
Z_CR = zeros(vidHeight*vidWidth,nFrames);
h = waitbar(0,'Zigzag traversal On process');
for k = 1 : nFrames
Z_Y(:,k) = ZigzagMx(Y(:,:,k));
Z_CB(:,k) = ZigzagMx(CB(:,:,k));
Z_CR(:,k) = ZigzagMx(CR(:,:,k));
clc;
    display ('Zigzag traversal On process');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
     
     waitbar(k/nFrames,h)
end
waitbar(k/nFrames,h,'Zigzag traversal Completed');
display ('Zigzag traversal Completed');
delete(h);
% -------------------------------------------------------------------- %
%                       Runlength Encoding                             %
% -------------------------------------------------------------------- %
Runlength(1:nFrames) = struct('y',[],'cb',[],'cr',[]);
h = waitbar(0,'RunLength Encoding On Process ...');
for k = 1 : nFrames
   Runlength(k).y = RunlengthEncoding(Z_Y(:,k)',vidHeight,vidWidth); 
   Runlength(k).cb = RunlengthEncoding(Z_CB(:,k)',vidHeight,vidWidth); 
   Runlength(k).cr = RunlengthEncoding(Z_CR(:,k)',vidHeight,vidWidth); 
    clc;
    display ('RunLength Encoding On Process ...');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
     waitbar(k/nFrames,h)
end
waitbar(k/nFrames,h,'RunLength Encoding Completed');
delete(h);
display ('RunLength Encoding Completed');

% -------------------------------------------------------------------- %
%                       Computing Compression Ratio                    %
% -------------------------------------------------------------------- %
close 1;
clc;
VideoName = strrep(VideoName,'.','_');
FileName = sprintf('%s_mars',VideoName);
save(FileName,'Runlength');
temp = sprintf('Encoded Data Present in: %s',FileName);
disp(temp);
temp = whos('PresentImage');
ImgSize = temp.bytes;
TImgSize = ImgSize * nFrames;
temp = whos('Runlength');
CompSize = temp.bytes;
CompRatio = 100- (CompSize / TImgSize) * 100;

temp = sprintf('Size of Each Image = %d\nSize of All Frames: ImgSize * nFrames = %d\nSize Encoded File = %d',ImgSize,TImgSize,CompSize);
disp(temp);
temp = sprintf('Compression = %3.2f %%',CompRatio);
disp(temp);
end