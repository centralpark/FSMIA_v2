function result = getMoleculeProperty(fieldname)
global Molecule;
if ~isfield(Molecule(1),fieldname)
    disp(strcat(fieldname,'does not exist'))
    return
else
    sample = getfield(Molecule(1),fieldname);
    L = length(sample);
    k = 2;
    while L < 1
        sample = getfield(Molecule(k),fieldname);
        L = length(sample);
        k = k+1;
    end
end
N = length(Molecule);
result = zeros(N,L);
for i = 1:N
    value = getfield(Molecule(i),fieldname);
    if ~isempty(value)
        result(i,:) = value;
    end
end