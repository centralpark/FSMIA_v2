function ImageFit = flatFieldFit(Image)
[M,N] = size(Image);
x_row = (1:M)'*ones(1,N);
y_col = ones(M,1)*(1:N);
x = reshape(x_row,M*N,1);
y = reshape(y_col,M*N,1);
z = reshape(Image,M*N,1);
gauss_2D = @(A,x0,y0,sx,sy,A0,x,y)...
    (A*exp(-(x-x0).^2/(2*sx^2)-(y-y0).^2/(2*sy^2))+A0);
ImageFit = fit([x,y],z,gauss_2D);
