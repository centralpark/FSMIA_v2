function [molPixelIdx,BW] = roughscan(obj,RawImage)

Option = obj.Option;
threshold = Option.threshold;
R = Option.spotR;
img = double(RawImage);
[M,N] = size(img);
mid = floor(M/2)+1;
% high pass filtering to remove uneven background
F = fftshift(fft2(img));
F_sub = F;
F_sub(mid-2:mid+2,mid-2:mid+2) = 0;
F_sub(mid,mid) = F(mid,mid);
img_1 = ifft2(ifftshift(F_sub));
% apply median filter to remove single pixel noise
img_2 = medfilt2(img_1);
if Option.exclude
    x1 = Option.exclude(1,1);
    y1 = Option.exclude(1,2);
    x2 = Option.exclude(2,1);
    y2 = Option.exclude(2,2);
    img_2(x1:x2,y1:y2) = 0;
end

BW = img_2 > threshold;
CC = bwconncomp(BW);
molPixelIdx = cell(1);
l = 1;

for k = 1:length(CC.PixelIdxList)
    if ge(numel(CC.PixelIdxList{k}),50)
        % there might be multiple molecules near each other
        pixIdxList = CC.PixelIdxList{k};
        for ind = 1:numel(pixIdxList)
            pix = pixIdxList(ind);
            neighbors = [pix-M pix-M-1 pix-M+1 pix-1 pix+1 pix+M pix+M-1 pix+M+1];
            if sum(~ismember(neighbors,pixIdxList))
                continue
            elseif ge(img(pix),max(img(neighbors)))
                [i,j] = ind2sub([M,N],pix);
                if ge(i,R+1) && ge(M-R,i) && ge(j,R+1) && ge(N-R,j)
                    molPixelIdx{l} = [i,j];
                    l = l+1;
                end
            else
                continue
            end
        end    
    else
        [i,j] = getcentroid(CC.PixelIdxList{k});
        if ge(i,R+1) && ge(M-R,i) && ge(j,R+1) && ge(N-R,j)
            molPixelIdx{l} = [i,j];
            l = l+1;
        end
    end
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