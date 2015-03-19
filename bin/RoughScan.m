function biImage = RoughScan(RawImage)

global Option
threshold = Option.threshold;
R = Option.spotR;
img = double(RawImage);
% high pass filtering to remove uneven background
F = fftshift(fft2(img));
F_sub = F;
F_sub(255:259,255:259) = 0;
F_sub(257,257) = F(257,257);
img_1 = ifft2(ifftshift(F_sub));
% apply median filter to remove single pixel noise
img_2 = medfilt2(img_1);
[M,N] = size(img);
BW = img_2 > threshold;
CC = bwconncomp(BW);
img_bi = zeros(M,N);

for k = 1:length(CC.PixelIdxList)
    [i,j] = getcentroid(CC.PixelIdxList{k});
    if ge(i,R+1) && ge(M-R,i) && ge(j,R+1) && ge(N-R,j)
        img_bi(i,j) = 1;
    end
end

if Option.exclude
    x1 = Option.exclude(1,1);
    y1 = Option.exclude(1,2);
    x2 = Option.exclude(2,1);
    y2 = Option.exclude(2,2);
    biImage(x1:x2,y1:y2) = 0;
end

    function [c_row,c_col] = getcentroid(pixelIdxList)
        [rows,cols] = ind2sub([M,N],pixelIdxList);
        weight = img_2(pixelIdxList);
        c_row = dot(rows,weight)/sum(weight);
        c_col = dot(cols,weight)/sum(weight);
        c_row = round(c_row);
        c_col = round(c_col);
    end

end