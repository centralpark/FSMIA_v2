function fAnalyseAdsorp(trajectory)
global Frame;
nFrame = length(Frame);
for i = 2:nFrame-1
    indices = Frame(i).MoleculeIndex;
    Frame(i).NumAdsorp = fFrameCount(indices);
end

function count = fFrameCount(indices)
global Molecule;
count = 0;
for i = 1:length(indices)
    m = indices(i);
    if isempty(Molecule(m).From)&&isempty(Molecule(m).To)
        
    else
        count = count+1;
    end
end