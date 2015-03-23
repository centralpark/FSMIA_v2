%%
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
data = bfopen('/Volumes/Research/2015-03-17/Coverslip-1_ROI-3_Fn001nM.nd2');
frame_1 = double(data{1}{1,1});
[N_1,edges_1] = histcounts(frame_1(:),'BinMethod','integers');
semilogy(1027:5881,N_1,'k')
frame_1_center = frame_1(129:384,129:384);
[N_2,edges_2] = histcounts(frame_1_center(:),'BinMethod','integers');
hold on
semilogy(1052:5881,N_2,'b')
hold off
set(gca,'FontSize',20);
legend('Frame (512\times 512)','Center region of frame (256\times 256)')
savefig('/Volumes/Research/2015-03-17/Figure_1.fig')
frame_1a = frame_1;
frame_1a(frame_1>1500) = NaN;
profile_v = nanmean(frame_1a,1);
profile_h = nanmean(frame_1a,2);
plot(profile_h);title('Horizontal');
savefig('/Volumes/Research/2015-03-17/Figure_2.fig')
figure
plot(profile_v);title('Vertical');
F = fftshift(fft(profile_h));
F_amp = abs(F);
figure
semilogy(F_amp);title('Fourier Transform');
F_amp_sub = F_amp;
F_amp_sub(253:256) = 0;
F_amp_sub(258:261) = 0;
F_sub = ifft(ifftshift(F_amp_sub));
figure
plot(F_sub);title('F_{sub}');
ylim([1150 1210]);
title('Horizontal profile after selective filtering')
set(gca,'FontSize',20)
savefig('/Volumes/Research/2015-03-17/Figure_3.fig')
close all

F_1 = fftshift(fft2(frame_1));
imshow(log(abs(F_1)),[])
colormap jet
colorbar
F_1b = F_1;
F_1b(255:259,255:259) = 0;
F_1b(257,257) = F_1(257,257);
frame_1b = ifft2(ifftshift(F_1b));
imwrite(uint16(frame_1b),'filteredImage.tif');
imwrite(uint16(frame_1),'originalImage.tif');


%%
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
data = bfopen('/Volumes/Research/2015-03-17/Coverslip-1_ROI-1_Fn001nM.nd2');
frame_1 = double(data{1}{1,1});

img = frame_1;
% high pass filtering to remove uneven background
F = fftshift(fft2(img));
F_sub = F;
F_sub(255:259,255:259) = 0;
F_sub(257,257) = F(257,257);
img_1 = ifft2(ifftshift(F_sub));
% apply median filter to remove single pixel noise
img_2 = medfilt2(img_1);
img_3 = img_2(2:511,2:511);
[N_3,edges_3] = histcounts(img_3(:),'BinMethod','integers');
semilogy(ceil(min(edges_3)):floor(max(edges_3)),N_3,'k')
title('Intensity distribution after filtering')
savefig('Figure_4')
figure
plot(ceil(min(edges_3)):floor(max(edges_3)),N_3,'k')
set(gca,'FontSize',20);
title('Intensity distribution after filtering')
savefig('Figure_5')
imwrite(uint16(img_2),'img_2.tif');
[f,gof] = fit((ceil(min(edges_3)):floor(max(edges_3)))',N_3','gauss1');
plot(f,'r')
openfig('Figure_4.fig');
hold on
semilogy(1010:1500,f(1010:1500),'r');
hold off
ylim([1e0 1e4])
legend('Distribution','Gaussian fit')
savefig('Figure_4')

addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/');
FilterGUI;
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/bin/');


