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


%%
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/test/')
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/bin/')
A = 2000/160^2;
x0 = 30;
y0 = 40;
sigma = 210;
z0 = 1100;
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
I = zeros(11,11);
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
imagesc(I)
obj = struct;
obj.Option.pixelSize = 160;
obj.Option.spotR = 5;
[f,gof] = fit2D_integral(obj,I);
[f_1,gof_1] = fit2D(obj,I);

A = 4000/160^2;
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
I = zeros(11,11);
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_3,gof_3] = fit2D_integral(obj,I);
[f_4,gof_4] = fit2D(obj,I);

I_3 = zeros(11,11);
I_4 = zeros(11,11);
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I_3(i,j) = f_3(x,y);
        I_4(i,j) = f_4(x,y);
    end
end
imagesc(I)
figure
imagesc(I_3)
figure
imagesc(I_4)
diff_3 = I_3 - I;
diff_4 = I_4 - I;

A = 2000/160^2;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
tic
[f_5,gof_5] = fit2D_integral(obj,I);
t_5 = toc;
tic
[f_6,gof_6] = fit2D(obj,I);
t_6 = toc;

A = 1000/160^2;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_7,gof_7] = fit2D(obj,I);

sigma = 100;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_8,gof_8] = fit2D(obj,I);

sigma = 200;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_9,gof_9] = fit2D(obj,I);

sigma = 300;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_10,gof_10] = fit2D(obj,I);

sigma = 300;
x0 = 0;
y0 = 0;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_11,gof_11] = fit2D(obj,I);

sigma = 400;
x0 = 30;
y0 = 40;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_12,gof_12] = fit2D(obj,I);

sigma = 500;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_13,gof_13] = fit2D(obj,I);

sigma = 600;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_14,gof_14] = fit2D(obj,I);

sigma = 700;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_15,gof_15] = fit2D(obj,I);

sigma = 800;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_16,gof_16] = fit2D(obj,I);

sigma = 900;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_17,gof_17] = fit2D(obj,I);

sigma = 1000;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_18,gof_18] = fit2D(obj,I);

tmp = [f_8.sigma f_9.sigma f_10.sigma f_12.sigma f_13.sigma f_14.sigma f_15.sigma f_16.sigma f_17.sigma f_18.sigma]'...
    - (100:100:1000)';

plot((100:100:1000)',tmp,'LineStyle','none','Marker','o','MarkerFaceColor','k')

data = zeros(10,3);
data(:,2) = [f_8.sigma f_9.sigma f_10.sigma f_12.sigma f_13.sigma f_14.sigma f_15.sigma f_16.sigma f_17.sigma f_18.sigma]';
data(:,1) = (100:100:1000)';
data(:,3) = data(:,2) - data(:,1);
plot(data(:,1),data(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','k')
sigma = 50;
for k = 1:7
    I = zeros(11,11);
    fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
    for i = 1:11
        for j = 1:11
            x = (i-6)*160;
            y = (j-6)*160;
            I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
        end
    end
    [f_tmp,~] = fit2D(obj,I);
    data(10+k,1) = sigma;
    data(10+k,2) = f_tmp.sigma;
    sigma = sigma + 100;
end
data(:,3) = data(:,2) - data(:,1);
plot(data(:,1),data(:,3),'LineStyle','none','Marker','o','MarkerFaceColor','k')
data = sortrows(data);
loglog(data(1:13,1),data(1:13,3),'LineStyle','none','Marker','o','MarkerFaceColor','k')

sigma_array = [10 20 30 40 60 70 80 90];
for k = 1:length(sigma_array)
    sigma = sigma_array(k);
    I = zeros(11,11);
    fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
    for i = 1:11
        for j = 1:11
            x = (i-6)*160;
            y = (j-6)*160;
            I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
        end
    end
    [f_tmp,~] = fit2D(obj,I);
    data(17+k,1) = sigma;
    data(17+k,2) = f_tmp.sigma;
end
data(:,3) = data(:,2) - data(:,1);
data = sortrows(data);
loglog(data(1:21,1),data(1:21,3),'LineStyle','none','Marker','o','MarkerFaceColor','k')

sigma = 50;
I = zeros(11,11);
fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
for i = 1:11
    for j = 1:11
        x = (i-6)*160;
        y = (j-6)*160;
        I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
    end
end
[f_tmp,gof_tmp] = fit2D(obj,I);

sigma_array = horzcat(10*(1:10),50*(3:20));
data = cell(length(sigma_array),4);
for k = 1:length(sigma_array)
    sigma = sigma_array(k);
    I = zeros(11,11);
    fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
    for i = 1:11
        for j = 1:11
            x = (i-6)*160;
            y = (j-6)*160;
            I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
        end
    end
    [f_tmp,gof_tmp] = fit2D(obj,I);
    data{k,1} = sigma;
    data{k,2} = f_tmp.sigma;
    data{k,3} = f_tmp;
    data{k,4} = gof_tmp;
end
X = cell2mat(data(:,1));
Y = cell2mat(data(:,2))-cell2mat(data(:,1));
for i = 1:length(X)
    tmp = confint(data{i,3});
    E(i) = tmp(2,2) - data{i,2};
end
errorbar(X,Y,E,'LineStyle','none','Marker','o','MarkerFaceColor','k')
xlabel('\sigma_{theory}')
ylabel('\sigma_{fit} - \sigma_{theory}')
h = gca;
h.XLim = [0 1100];
h.YTick = 100*(-3:1);
savefig('Figure_1')
loglog(X(1:21),Y(1:21),'LineStyle','none','Marker','o','MarkerFaceColor','k')
ft = fittype('poly1');
[f_19,gof_19] = fit(log10(X(10:21)),log10(Y(10:21)),ft);
x = 1.5:0.1:2.9;
y = feval(f_19,x);
hold on
loglog(10.^x,10.^y,'r','LineWidth',3)
hold off
xlabel('\sigma_{theory}')
ylabel('\sigma_{fit} - \sigma_{theory}')
savefig('Figure_2')

obj.Option.spotR = 10;
sigma_array = horzcat(10*(1:10),50*(3:20));
data = cell(length(sigma_array),4);
for k = 1:length(sigma_array)
    sigma = sigma_array(k);
    I = zeros(21,21);
    fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
    for i = 1:21
        for j = 1:21
            x = (i-11)*160;
            y = (j-11)*160;
            I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
        end
    end
    [f_tmp,gof_tmp] = fit2D(obj,I);
    data{k,1} = sigma;
    data{k,2} = f_tmp.sigma;
    data{k,3} = f_tmp;
    data{k,4} = gof_tmp;
end
X = cell2mat(data(:,1));
Y = cell2mat(data(:,2))-cell2mat(data(:,1));
for i = 1:length(X)
    tmp = confint(data{i,3});
    E(i) = tmp(2,2) - data{i,2};
end
errorbar(X,Y,E,'LineStyle','none','Marker','o','MarkerFaceColor','k')
xlabel('\sigma_{theory}')
ylabel('\sigma_{fit} - \sigma_{theory}')
h = gca;
h.XLim = [0 1100];
savefig('Figure_3')
figure
loglog(X,Y,'LineStyle','none','Marker','o','MarkerFaceColor','k')

sigma_array = horzcat(10*(1:10),50*(3:20));
data = cell(length(sigma_array),4);
for k = 1:length(sigma_array)
    sigma = sigma_array(k);
    I = zeros(21,21);
    fun = @(x,y) A*exp((-(x-x0).^2-(y-y0).^2)/(2*sigma^2));
    for i = 1:21
        for j = 1:21
            x = (i-11)*160;
            y = (j-11)*160;
            I(i,j) = integral2(fun,x-80,x+80,y-80,y+80)+z0;
        end
    end
    [f_tmp,gof_tmp] = fit2D_integral(obj,I);
    data{k,1} = sigma;
    data{k,2} = f_tmp.sigma;
    data{k,3} = f_tmp;
    data{k,4} = gof_tmp;
end
errorbar(X,Y,E,'LineStyle','none','Marker','o','MarkerFaceColor','k')
xlabel('\sigma_{theory}')
ylabel('\sigma_{fit} - \sigma_{theory}')
h = gca;
h.XLim = [0 1100];
savefig('Figure_4')



%%
% run time benchmark
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/');
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/bin/');
clc
clear
analysis = FSMIA();
analysis.setoption();
tic;
analyzestack(analysis,'/Volumes/Research/Protein Adsorption Nanomechanics/2015-03-17/Coverslip-1_ROI-1_Fn001nM.nd2')
t = toc;

analysis_1 = FSMIA();
analysis_1.setoption();
tic;
analyzestack(analysis_1,'/Volumes/Research/Protein Adsorption Nanomechanics/2015-03-17/Coverslip-1_ROI-1_Fn001nM.nd2')
t_1 = toc;


%%
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/');
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/bin/');
clc
clear
analysis = FSMIA();
analysis.setoption();
analyzestack(analysis,...
    '/Volumes/Research/Protein Adsorption Nanomechanics/2015-03-29/Coverslip-2_ROI-3_Fn10pM.nd2')

pos = zeros(114,2);
for i = 1:114
    pos(i,:) = analysis.Molecule(i).coordinate;
end
pos = fliplr(pos);
save ~/Desktop/data.mat pos


%%
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/');
addpath('/Volumes/Research/MATLAB_lib/FSMIA_v2/bin/');
data = bfopen('/Volumes/Research/Protein Adsorption Nanomechanics/2015-04-15/Coverslip1_Fn10pM_ROI2.nd2');
original_im = data{1}{1,1};
crop_im = original_im(397:418,49:76);
analysis = FSMIA();
analysis.setoption();
[molPixelIdx,BW] = roughscan(analysis,original_im);
n_pix = zeros(112,1);
for i = 1:112
    n_pix(i) = numel(molPixelIdx{i});
end
plot(1:112,n_pix)

[molPixelIdx,BW,k_sel,CC] = roughscan_debug(analysis,original_im);
n = numel(k_sel);
n_pix = zeros(n,1);
for i = 1:n
    n_pix(i) = numel(CC.PixelIdxList{k_sel(i)});
end
plot(1:n,n_pix)
analyzestack(analysis,...
    '/Volumes/Research/Protein Adsorption Nanomechanics/2015-04-15/Coverslip1_Fn10pM_ROI2.nd2')
