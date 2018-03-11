%function [FileName] = Readvideo(VideoName)
fontsize=14;
% -------------------------------------------------------------------- %
%                   Reading viedo file and get info                    %
% -------------------------------------------------------------------- %

VideoName = 'video.mpg';
Myvideo = VideoReader(VideoName);

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
clear Myvideo outputBaseFileName outputFullFileName mov thisFrame ...
    caption title folder baseFileName numberOfFramesWritten done fontsize;
% -------------------------------------------------------------------- %
%             Separating RGB matrix for each frames                    %
% -------------------------------------------------------------------- %
    LuminousMatrix(vidHeight,vidWidth,nFrames) = zeros;
    U(vidHeight/2,vidWidth/2,nFrames) = zeros;
    V(vidHeight/2,vidWidth/2,nFrames) = zeros;
    RedNew(vidHeight/2,vidWidth/2) = zeros;
    GreenNew(vidHeight/2,vidWidth/2) = zeros;
    BlueNew(vidHeight/2,vidWidth/2) = zeros;
    
for k = 1: nFrames
    framename = sprintf('%s/Frame %2.2d.png',outputFolder,k);
    PresentImage = imread(framename);
    
    RedMatrix = PresentImage(:,:,1);
    GreenMatrix = PresentImage(:,:,2);
    BlueMatrix = PresentImage(:,:,3);
    % ----------------------------------------------------------------- %
    %                       Calculating Luminous                        % 
    % ----------------------------------------------------------------- %
    
    LuminousMatrix(:,:,k) = 0.30*RedMatrix + 0.59*GreenMatrix ...
        + 0.11*BlueMatrix ;    
    % ----------------------------------------------------------------- %
    %                      Calculating Chrominous                       % 
    % ----------------------------------------------------------------- %
    for i = 1:2:vidHeight-1
        for j = 1:2:vidWidth-1
            %RedMatrix to RedNew
            r = RedMatrix(i:i+1, j:j+1);
            r = sum(sum(r))/4;
            RedNew((i+1)/2,(j+1)/2) = r;
        
            %GreenMatrix to GreenNew
            g = GreenMatrix(i:i+1, j:j+1);
            g = sum(sum(g))/4;
            GreenNew((i+1)/2,(j+1)/2) = g;
            
            %RedMatrix to RedNew
            b = BlueMatrix(i:i+1, j:j+1);
            b = sum(sum(b))/4;
            BlueNew((i+1)/2,(j+1)/2) = b;
        end
    end
%     RedNew = blkproc(double(blkproc(double(RedMatrix),[2 2],@mean)),[1 2],@mean);
%     GreenNew = blkproc(double(blkproc(double(GreenMatrix),[2 2],@mean)),[1 2],@mean);
%     BlueNew = blkproc(double(blkproc(double(BlueMatrix),[2 2],@mean)),[1 2],@mean);
    
    U(:,:,k) = -0.18*RedNew - 0.25*GreenNew + 0.44*BlueNew;
    V(:,:,k) = 0.62*RedNew - 0.52-GreenNew - 0.10*BlueNew;

    clc;
    display (' Computing Luminous Chrominous matrices');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
end
clear RedMatrix RedNew BlueMatrix BlueNew GreenMatrix GreenNew ...
    r g b PresentImage;
% -------------------------------------------------------------------- %
%                   Displaying Different Matrices                      %
% -------------------------------------------------------------------- %
for k=1:nFrames
     %displaying matrices
     framename = sprintf('%s/Frame %2.2d.png',outputFolder,k);
    PFrame = sprintf('Frame%2.2d',k);
    figure(2);
    subplot(2,2,1); image(imread(framename)); title(PFrame);
    subplot(2,2,2); image(LuminousMatrix(:,:,k)); title('LuminousMatrix');
    subplot(2,2,3); image(U(:,:,k)); title('Chrominous U');
    subplot(2,2,4); image(V(:,:,k)); title('Chrominous V');
    %pause(0.2);
end    
display('Plot of Different Matrices Completed');
% -------------------------------------------------------------------- %
%                Finding Discrete Cosine Transform                     %
% -------------------------------------------------------------------- %
LMNew(vidHeight,vidWidth,nFrames) = zeros;
UNew(vidHeight/2,vidWidth/2,nFrames) = zeros;
VNew(vidHeight/2,vidWidth/2,nFrames) = zeros;
for k=1:nFrames
%     for i=1:8:vidHeight-7
%         for j=1:8:vidWidth-7
%         LMNew(i:i+7,j:j+7,k) = dct2(LuminousMatrix(i:i+7,j:j+7,k));
%         end
%     end
    LMNew(:,:,k) = blkproc(double(LuminousMatrix(:,:,k)),[8 8],@dct2); %#ok<*FPARK>
% for i=1:8:(vidHeight/2)-7
%     for j=1:8:(vidWidth/2)-7
%         UNew(i:i+7,j:j+7,k) = dct2(U(i:i+7,j:j+7,k));
%         VNew(i:i+7,j:j+7,k) = dct2(V(i:i+7,j:j+7,k));
%     end
% end
    UNew(:,:,k) = blkproc(double(U(:,:,k)),[8 8],@dct2); %#ok<*FPARK>
    VNew(:,:,k) = blkproc(double(V(:,:,k)),[8 8],@dct2); %#ok<*FPARK>
    
    clc;
    display (' Computing DCT matrices');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
    figure(3);
    axis square
    subplot(1,2,1); image(LMNew(:,:,k)); title('LNew Matrix');
    subplot(2,2,2); image(UNew(:,:,k)); title('UNew Matrix');
    subplot(2,2,4); image(VNew(:,:,k)); title('VNew Matrix');
    %pause(0.2);
end
clear i j k LOAD framename PFrame outputFolder;
% -------------------------------------------------------------------- %
%                       Quantazation                                   %
% -------------------------------------------------------------------- %
LMfinal(vidHeight,vidWidth,nFrames) = zeros;
Ufinal(vidHeight/2,vidWidth/2,nFrames) = zeros;
Vfinal(vidHeight/2,vidWidth/2,nFrames) = zeros;

for k = 1 : nFrames
    LMfinal(:,:,k) = LMNew(:,:,k)./8;
    Ufinal(:,:,k) = UNew(:,:,k)./8;
    Vfinal(:,:,k) = VNew(:,:,k)./8;

    clc;
    display ('Quantazation on process');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
end
LMfinal = cast(LMfinal,'uint8');
Ufinal =  cast(Ufinal,'uint8');
Vfinal =  cast(Vfinal,'uint8');
display ('Quantazation Completed');
% -------------------------------------------------------------------- %
%                       Zigzag Traversal                               %
% -------------------------------------------------------------------- %
LMZMx = zeros(vidHeight*vidWidth,nFrames,'uint8');
UMZMx = zeros(vidHeight*vidWidth/4,nFrames,'uint8');
VMZMx= zeros(vidHeight*vidWidth/4,nFrames,'uint8');
for k = 1 : nFrames
LMZMx(:,k) = ZigzagMx(LMfinal(:,:,k));
UMZMx(:,k) = ZigzagMx(Ufinal(:,:,k));
VMZMx(:,k) = ZigzagMx(Vfinal(:,:,k));
clc;
    display ('Zigzag traversal On process');
    LOAD = sprintf('%2.2f %%',(k / nFrames) * 100);
    disp(LOAD);
end
display ('Zigzag traversal Completed');
% -------------------------------------------------------------------- %
%                        Huffman encoding                              %
% -------------------------------------------------------------------- %

[LEH LDict] = HuffmanEncoding(LMZMx);
[UEH UDict] = HuffmanEncoding(UMZMx);
[VEH VDict] = HuffmanEncoding(VMZMx);
    
clear LMZMx UMZMx VMZMx k LOAD;
VideoName = strrep(VideoName,'.','_');
FileName = sprintf('%s_mars',VideoName);
save(FileName,'LEH','UEH','VEH','LDict','UDict','VDict');
display ('Huffman Encoding Completed');
display ('Encoded Data Present in');
disp (FileName);
%end