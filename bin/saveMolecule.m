function saveMolecule(varargin)
global Molecule;
if nargin == 0
    % By default, save data for all molecules
    NumMolecule = length(Molecule);
    NumPara = length(Molecule(1).parameter);
    fitResult = zeros(NumMolecule,NumPara);
    for k = 1:NumMolecule
        fitResult(k,:) = Molecule(k).parameter;
    end

    saveFile = strcat('MoleculeFitParameter','.mat');
    save(saveFile,'fitResult');
else
    type = varargin{1};
    switch type
        case 'Frame'
            if strcmpi(varargin{3},'Parameter')
                saveFramePara(varargin{2});
            end
        otherwise
            return
    end

end

function saveFramePara(FrameIndex)
global Molecule;
L = length(Molecule);
MoleculeFrame = zeros(L,1);
for k = 1:L
    MoleculeFrame(k) = Molecule(k).frame;
end
start = find(MoleculeFrame==FrameIndex,1,'first');
finish = find(MoleculeFrame==FrameIndex,1,'last');
result = zeros(finish-start+1,length(Molecule(1).parameter));
for k = 1:length(result)
    result(k,:) = Molecule(start+k-1).parameter;
end

saveFile = strcat('ParameterOfMoleculeInFrame',num2str(FrameIndex),'.mat');
save(saveFile,'result');