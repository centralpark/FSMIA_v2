function getAllCoordinate(trajall,Molecule,Option,out_file_path)
% Get x,y position for all trajectories
% Input
%   trajall - trajectory results from previous image analysis
%   Molecule - 
%   Option - 
% Output
%   an output file of the data analysis that contains two columns, the left
%   one with the x and the right one with the y coordinate of any given
%   molecule during the whole trajectory. All the trajectories of one image
%   should be in the same file and the same columns. In between different 
%   trajectories I would like to have a row of 0's
% $Revision: 1.0 $  $Date: 2014/07/05 $

fileID = fopen(out_file_path,'w');
fprintf(fileID,'x(nm)\ty(nm)\n');
N = length(trajall);
ps = Option.pixelSize;
for i = 1:N
    traj = trajall(i).trajectory;
    for j = 1:length(traj)
        mol_x = Molecule(traj(j)).coordinate(3)*ps + ...
            Molecule(traj(j)).parameter(2);
        mol_y = Molecule(traj(j)).coordinate(4)*ps + ...
            Molecule(traj(j)).parameter(3);
        fprintf(fileID,'%f\t%f\n',mol_x,mol_y);
    end
    fprintf(fileID,'0\t0\n');
end

fclose('all');