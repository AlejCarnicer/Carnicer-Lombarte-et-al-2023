function [Points] = FrameLookup(filename, frame);

%%
%Short script to select a frame from a movie and get coordinates (X and Y) from
%screen. 
%Order is of course important. See separate guide to ensure consistency.
% 
%Recommend getting frame number using implay('filename.mp4')

clear Points

v = VideoReader(filename); %Import video as object

frame = read(v,frame); %Get values for specific frame

%frame = pagetranspose(frame); %Rotate if needed
%frame = flipud(frame); %Flip upside down if needed

fig = image(frame); %Plot as image

[Points(:,1),Points(:,2)] = getpts; %Get points

close;