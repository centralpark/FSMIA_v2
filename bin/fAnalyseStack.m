function fAnalyseStack(ImageFile)

global Molecule;
global Frame;
info = imfinfo(ImageFile);
nFrame = length(info);
fprintf('Starting analyze %d frames\n',nFrame);
tic;
for k = 1:nFrame
    NumMolecule = length(Molecule);
    rawImage = imread(ImageFile,'Index',k);
    biImage = RoughScan(rawImage);
    FineScan(biImage,rawImage)
    for i = (NumMolecule+1):length(Molecule)
        Molecule(i).frame = k;
    end
    Frame(k).MoleculeIndex = (NumMolecule+1):length(Molecule);
    if k == round(0.1*nFrame)
        t = toc;
        fprintf('10%% (%d frames) finished! Time cost: %f mins\n',k,t/60);
    elseif k == round(0.5*nFrame)
        t = toc;
        fprintf('50%% (%d frames) finished! Time cost: %f mins\n',k,t/60);
    elseif k == round(0.9*nFrame)
        t = toc;
        fprintf('90%% (%d frames) finished! Time cost: %f mins\n',k,t/60);
    else
    end
end
disp('Analysis of all frames finished!');
% Connect to create molecule trajectory
NumFrame = length(Frame);
for k = 1:NumFrame-1
    connectFrame(k,k+1);
end
