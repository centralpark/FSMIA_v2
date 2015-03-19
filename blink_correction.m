function newTrajectories = blink_correction(oldTrajectories,Molecule)
% Corrections for photoblinking effect. Two trajectories will be connected
% if they are separated by one frame and the coordinates do not change
% Input
%   OLDTRAJ - trajectory results from previous image analysis

N = length(oldTrajectories);

newTrajectories = struct('trajectory',[]);
k = 1;
exclude = [];
for i = 1:N
    if ismember(i,exclude)
        continue
    end
    traj_1 = oldTrajectories(i).trajectory;
    molIndex_1 = traj_1(end);
    frame_1 = Molecule(molIndex_1).frame;
    noBlink = true;
    for j = (i+1):N
        traj_2 = oldTrajectories(j).trajectory;
        molIndex_2 = traj_2(1);
        frame_2 = Molecule(molIndex_2).frame;
        if frame_2 == (frame_1+2)
            if Molecule(molIndex_1).coordinate == Molecule(molIndex_2).coordinate
                newTrajectories(k).trajectory = horzcat(traj_1,NaN(1),traj_2);
                k = k+1;
                exclude = horzcat(exclude,j);
                noBlink = false;
                break
            end
        end
    end
    if noBlink
        newTrajectories(k).trajectory = traj_1;
        k = k+1;
    end
end