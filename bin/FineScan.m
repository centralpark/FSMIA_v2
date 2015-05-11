function finescan(obj,RawImage)
% FINESCAN(MOLPIXELIDX,RAWIMAGE) gets the detailed information for molecules
% identified in RAWIMAGE

Option = obj.Option;
NumMolecule = length(obj.Molecule);
R = Option.spotR;   % radius (pixel) of diffraction limited spot
img = double(RawImage);
[molPixelIdx,BW] = roughscan(obj,img);
valley = Option.valley;

for k = 1:length(molPixelIdx)
    if isempty(molPixelIdx{k})
        break
    end
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
    
    % if neighbor molecule is in the ROI
    margin_row = [1 2*R+1 2 2*R];
    margin_col = [1 2*R+1 2 2*R];
    for ii = 1:4
        for jj = 1:4
            iii = margin_row(ii);
            jjj = margin_col(jj);
            if subImage(iii,jjj) > valley
                subimage(iii,jjj) = NaN;
            end
        end
    end
    
    try
        [obj.Molecule(NumMolecule+k).fit,obj.Molecule(NumMolecule+k).gof] = fit2D(obj,subImage);
    catch
        disp('Unable to fit 2D Gaussian for the following molecule:');
        fprintf('%d, %d\n',i,j);
        disp(subImage);
        continue
    end
    obj.Molecule(NumMolecule+k).coordinate = [i j];
end

end