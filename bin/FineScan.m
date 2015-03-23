function finescan(RawImage)
% FINESCAN(MOLPIXELIDX,RAWIMAGE) gets the detailed information for molecules
% identified in RAWIMAGE

global Molecule;
global Option;
NumMolecule = length(Molecule);
R = Option.spotR;   % radius (pixel) of diffraction limited spot
img = double(RawImage);
[molPixelIdx,BW] = roughscan(img);

for k = 1:length(molPixelIdx)
    i = molPixelIdx{k}(1);
    j = molPixelIdx{k}(2);
    subImage = img(i-R:i+R,j-R:j+R);
    BW_sub = BW(i-R:i+R,j-R:j+R);
    CC_sub = bwconncomp(BW_sub);
    
    % deal with the above threshold pixels in the peripheral of subimage
    N = numel(CC_sub.PixelIdxList);
    if N > 1
        center_idx = 2*R^2+2*R+1;
        for l = 1:N
            pixIdxList = CC_sub.PixelIdxList{l};
            if ~ismember(center_idx,pixIdxList)
                subImage(pixIdxList) = NaN;
            end
        end
    end
    
    try
        [Molecule(NumMolecule+k).fit,Molecule(NumMolecule+k).gof] = fit2D(subImage);
    catch
        disp('Unable to fit 2D Gaussian for the following molecule:');
        fprintf('%d, %d\n',i,j);
        disp(subImage);
        continue
    end
    Molecule(NumMolecule+k).coordinate = [i j];
end