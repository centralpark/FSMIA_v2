function result = intensity_residence_relation(trajAll,Molecule)
% Calculate the relation between intensity of molecule on surface and the
% residence time of the molecule
% Input
%   TRAJALL - trajectory results from previous image analysis
%   MOLECULE - Molecule results from previous image analysis

% number of trajectories
N = length(trajAll);

result = struct;
result.nFrame = zeros(N,1);
result.intensity = zeros(N,1);

% for i = 1:N
%     traj = trajAll(i).trajectory;
%     nFrame = length(traj);
%     result.nFrame(i) = nFrame;
%     intensities = zeros(nFrame,1);
%     for j = 1:nFrame
%         molIndex = traj(j);
%         intensities(j) = Molecule(molIndex).parameter(1);
%     end
%     result.intensity(i) = mean(intensities);
% end

for i = 1:N
    traj = trajAll(i).trajectory;
    nFrame = length(traj);
    result.nFrame(i) = nFrame;
    if mod(nFrame,2)
        molIndex = traj((nFrame+1)/2);
        result.intensity(i) = Molecule(molIndex).parameter(1);
    else
        molIndex_1 = traj(nFrame/2);
        molIndex_2 = traj(nFrame/2+1);
        result.intensity(i) = mean([Molecule(molIndex_1).parameter(1),Molecule(molIndex_2).parameter(1)]);
    end
end

figure
scatter(result.intensity,result.nFrame)
xlabel('Intensity in the middle','fontsize',12)
ylabel('Number of frames','fontsize',12)