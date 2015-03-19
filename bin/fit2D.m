function fitResult = fit2D(M)
[m,~] = size(M);
mid = (m+1)/2;
z_0 = min(min(M));
A_0 = M(mid,mid) - z_0;
x_0 = 0;
y_0 = 0;
sigma_0 = 250;
para_0 = [A_0 x_0 y_0 sigma_0 z_0];
lb = [0 -400 -400 100 z_0-200];
ub = [A_0+200 400 400 500 z_0+200];
opt = optimset('Display','off');
fitPara = lsqcurvefit(@symmetricGauss,para_0,M,M,lb,ub,opt);
fitErr = sum(sum((M-symmetricGauss(fitPara,M)).^2));
fitResult = [fitPara fitErr];


function fitMatrix = symmetricGauss(para,matrix)
global Option;
[m,~] = size(matrix);
mid = (m+1)/2;
fitMatrix = zeros(size(matrix));
for i = 1:m
    for j = 1:m
        x = (i-mid)*Option.pixelSize;
        y = (j-mid)*Option.pixelSize;
        fitMatrix(i,j) = para(1)*exp(-((x-para(2)).^2+(y-para(3)).^2)/2/para(4)^2)+para(5);
    end
end