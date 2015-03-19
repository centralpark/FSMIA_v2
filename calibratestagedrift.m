function calibratestagedrift()
%CALIBRATESTAGEDRIFT Calibrate stage drift.
%   $Revision: 1.0 $  $Date: 2014/05/07 $

mol = evalin('base','Molecule');
frame = evalin('base','Frame');
opt = evalin('base','Option');
pix_size = opt.pixelSize;

N = length(frame);
pos_x = zeros(N,1);
pos_y = zeros(N,1);
for i = 1:N
    mol_ind = frame(i).MoleculeIndex;
    N_mol = length(mol_ind);
    coor_x = zeros(N_mol,1);
    coor_y = zeros(N_mol,1);
    for j = 1:N_mol
        coor_x(j) = mol(mol_ind(j)).coordinate(2)*pix_size+...
            mol(mol_ind(j)).parameter(2);
        coor_y(j) = mol(mol_ind(j)).coordinate(1)*pix_size-...
            mol(mol_ind(j)).parameter(3);
    end
    pos_x(i) = mean(coor_x);
    pos_y(i) = mean(coor_y);
end

save position.mat pos_x pos_y

end