function FineScan(biImage,RawImage)
% FINESCAN(BIIMAGE,RAWIMAGE) gets the detailed information for molecules
% identified in RAWIMAGE

%%%%%Version 2%%%%%
% 3/17/2014
% New feature: adaptive fitting with changing size of the submatrix
global Molecule;
global Option;
NumMolecule = length(Molecule);
[Row, Col] = find(biImage);
R = Option.spotR;   % radius (pixel) of diffraction limited spot
for k = 1:length(Row)
    i = Row(k);
    j = Col(k);
    subBiImage = biImage(i-R:i+R,j-R:j+R);
    subBiImage(R+1,R+1) = 0;
    [rowSubBi,colSubBi] = find(subBiImage);
    subImage = double(RawImage(i-R:i+R,j-R:j+R));
    % if there are neighbor molecules
    if rowSubBi
        for m = 1:length(rowSubBi)
           i_1 = rowSubBi(m);
           j_1 = colSubBi(m);
           for i_2 = [1:R-2,R+2:2*R+1]
               for j_2 = [1:R-2,R+2:2*R+1]
                   % if pixel is closer to the neighbor molecule, it will
                   % not be used in submatrix
                   if norm([i_2,j_2]-[i_1,j_1]) < norm([i_2,j_2]-[R+1,R+1])
                       subImage(i_2,j_2) = NaN;
                   end
               end
           end
        end
        while sum(sum(isnan(subImage)))
            [dimSubImage,~] = size(subImage);
            subImage = subImage(2:dimSubImage-1,2:dimSubImage-1);            
        end
    end
    try
        Molecule(NumMolecule+k).parameter = fit2D(subImage);
    catch
        disp('Unable to fit 2D Gaussian for the following molecule:');
        i
        j
        subImage
        continue
    end
    Molecule(NumMolecule+k).coordinate = [i j];
end