function steps = computestep(trajectory,Molecule,Option,opt)
% Calculate the step size of the molecular diffusion during residence
% Input
%   TRAJECTORY - trajectory of a single molecule
%   MOLECULE - Molecule results from previous image analysis
% Optional Input opt
%   
% Output
%   STEPS - return array of step sizes 

% number of dt
if nargin < 4
    n = 1;
else
    if isfield(opt,'n')
        n = opt.n;
    else
        n = 1;
    end
end

N = length(trajectory);
if N < n+1
    steps = [];
    return
end
steps = zeros(N-n,1);
ps = Option.pixelSize;
for i = 1:(N-n)
    mol_1 = Molecule(trajectory(i)).parameter(2:3);
    mol_2 = Molecule(trajectory(i+n)).parameter(2:3) + ...
        ps*(Molecule(trajectory(i+n)).coordinate(1:2)-Molecule(trajectory(i)).coordinate(1:2));
    steps(i) = norm(mol_1-mol_2);
end

% figure
% scatter(1:N-1,steps)
% xlabel('Step index','fontsize',12)
% ylabel('Step size (nm)','fontsize',12);