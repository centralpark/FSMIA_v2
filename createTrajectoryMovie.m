function createTrajectoryMovie(image_file,trajall,Molecule,traj_ind)
% Create movie to visulize a single trajectory
% Input:
%   image_file - complete file name of the analyzed image
%   trajall - trajectory results from previous image analysis
%   traj_ind - index of trajectory
% Output:
%   An tiff file of selected trajectory in the same folder as that of
%   image_file
% $Revision: 1.0 $  $Date: 2014/06/29 $

traj = trajall(traj_ind).trajectory;
frame_appear = Molecule(traj(1)).frame;
frame_disappear = Molecule(traj(end)).frame;
info = imfinfo(image_file);
n_images = numel(info);
[pathstr,~,~] = fileparts(image_file);
new_dir = strcat('Trajectory_',num2str(traj_ind));
mkdir(pathstr,new_dir);
path = fullfile(pathstr,new_dir);

for i = 1:(frame_appear-1)
    im = imread(image_file,i);
    RGB = repmat(im,[1,1,3]);
    % normalize data to dynamic range [0,1]
    RGB = double(RGB)/16384;
    ofile_name = fullfile(path,(strcat(new_dir,...
        '_',num2str(i),'.tiff')));
    imwrite(RGB,ofile_name);
end

j = 1;

for i = frame_appear:frame_disappear
    im = imread(image_file,i);
    % locate 'point'
    pt = Molecule(traj(j)).coordinate(1:2);
    pt = int32(pt);
    marker_intensity = round(max(im(:)));
    RGB = repmat(im,[1,1,3]);
    RGB(pt(1)-2:pt(1)+2,pt(2),1) = 0;
    RGB(pt(1)-2:pt(1)+2,pt(2),2) = marker_intensity;
    RGB(pt(1)-2:pt(1)+2,pt(2),3) = 0;
    RGB(pt(1),pt(2)-2:pt(2)+2,1) = 0;
    RGB(pt(1),pt(2)-2:pt(2)+2,2) = marker_intensity;
    RGB(pt(1),pt(2)-2:pt(2)+2,3) = 0;
    RGB = double(RGB)/16384;
    ofile_name = fullfile(path,(strcat(new_dir,...
            '_',num2str(i),'.tiff')));
    imwrite(RGB,ofile_name);
    j = j + 1;
end

for i = (frame_disappear+1):n_images
    im = imread(image_file,i);
    RGB = repmat(im,[1,1,3]);
    RGB = double(RGB)/16384;
    ofile_name = fullfile(path,(strcat(new_dir,...
            '_',num2str(i),'.tiff')));
    imwrite(RGB,ofile_name);
end