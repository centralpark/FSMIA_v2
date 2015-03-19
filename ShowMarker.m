function RGB = ShowMarker(image,index,Frame,Molecule)
% Show where the identified single molecules are
% Input
%   IMAGE - image file name
%   INDEX - the index of the image

im = imread(image,index);
mol_ind = Frame(index).MoleculeIndex;
N = length(mol_ind);
pts = zeros(N,2);
for i = 1:N
    pts(i,:) = Molecule(mol_ind(i)).coordinate(1:2);
end
pts = int32(pts);
%pts(:,[1,2]) = pts(:,[2,1]);
grayscale = imadjust(im);
RGB = repmat(grayscale,[1,1,3]);
for i = 1:N
    RGB(pts(i,1)-2:pts(i,1)+2,pts(i,2),1) = 0;
    RGB(pts(i,1)-2:pts(i,1)+2,pts(i,2),2) = 65535;
    RGB(pts(i,1)-2:pts(i,1)+2,pts(i,2),3) = 0;
    RGB(pts(i,1),pts(i,2)-2:pts(i,2)+2,1) = 0;
    RGB(pts(i,1),pts(i,2)-2:pts(i,2)+2,2) = 65535;
    RGB(pts(i,1),pts(i,2)-2:pts(i,2)+2,3) = 0;
end
figure; imshow(RGB);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% im = imread(image,index);
% mol_ind = Frame(index).MoleculeIndex;
% N = length(mol_ind);
% pts = zeros(N,2);
% for i = 1:N
%     pts(i,:) = Molecule(mol_ind(i)).coordinate(1:2);
% end
% pts = int32(pts);
% pts(:,[1,2]) = pts(:,[2,1]);
% grayscale = imadjust(im);
% RGB = repmat(grayscale,[1,1,3]);
% green = uint16([0 65535 0]);  % [R G B]; class of green must match class of im
% markerInserter = vision.MarkerInserter('Shape','Plus','BorderColor','Custom',...
%     'CustomBorderColor',green);
% J = step(markerInserter, RGB, pts);
% figure;imshow(J);