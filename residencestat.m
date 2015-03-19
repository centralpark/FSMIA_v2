function [count,residence_time] = residencestat(traj,num_frame,dt)
% RESIDENCESTAT calculate the distribution of residence time.
%   Output include:
%       residence_time: residence time.
%       count: number of trajectories corresponding to specific residence time.
%   Parameters include:
%       traj: input trajectory data.
%       num_frame: number of frames of the image stack
%       dt: time interval between frames

traj = ignoreframes(traj,num_frame);
residence_frame = cellfun(@length,traj);
[count,edges] = histcounts(residence_frame,'BinMethod','integers');
residence_time = dt*ceil(edges(1:end-1));

    function traj_new = ignoreframes(traj,N)
        for k = 1:length(traj)
            if traj{k}(1) == 1 || traj{k}(end) == N
                traj{k} = NaN;
            end
        end
        traj_new = traj(~cellfun(@isnan,traj));
    end

end