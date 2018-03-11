# MarsVideoCompressor
Video Compressor project for Data Compression

Our Solution
------------

* Mars video compressor is a program which compress a given video file
of any format to a compressed file, of format ‘.mat’ which is used to send
via network or used to store in the memory.

* Using the compressed file, we
can regenerate the given video file with some tolerable loss of data (lossy
compression).

* We are adopting the JPEG (Joint Photographer Expert Group) image
compression technique on each frame of the video given and compressing
the each frames and storing it as an intermediate file, and 

* Using this file we inverse all the module which is applied in the compression
part and will get ‘n’ frames of the video and we convert these frames to a video.
Scope: Mars video compressor is not typical video compressor but it
compress the video frames and restore it, i.e., a video is split to all its frames
and the compression is employed on its each frames separately and stores to
a ‘.mat’ file. So the compression ratio is dependent on size of the individual
frames.

* Since we are using Matlab are program is dependent upon Matlab
compiler but it is OS platform independent.


