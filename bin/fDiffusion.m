function output = fDiffusion()

% The function calculate the mean squared displacement

global Molecule;
global Result;
global Option;

p = Option.pixelSize;
T = Result.Trajectory;

N = length(T);
data = zeros(N,5);
for i = 1:N
    MolTraj = T(i).trajectory;
    M = length(MolTraj);
    j = 1;
    MolIndex = MolTraj(j);
    x = Molecule(MolIndex).coordinate(2)*p-p/2+Molecule(MolIndex).parameter(2);
    y = -Molecule(MolIndex).coordinate(1)*p+p/2+Molecule(MolIndex).parameter(3);
    % Conver unit from nm to um
    x_start = x/1000;
    y_start = y/1000;
    
    j = M;
    MolIndex = MolTraj(j);
    x = Molecule(MolIndex).coordinate(2)*p-p/2+Molecule(MolIndex).parameter(2);
    y = -Molecule(MolIndex).coordinate(1)*p+p/2+Molecule(MolIndex).parameter(3);
    % Conver unit from nm to um
    x_end = x/1000;
    y_end = y/1000;
    
    data(i,:) = [x_start y_start x_end y_end M];
    
    
%     [Var_r,x_um,mean_dist] = MSphere_measurement(data);
%     
%     output.Var_r = Var_r;
%     output.x_um = x_um;
%     output.mean_dist = mean_dist;
    
end

output = data;