function [Var_r,x_um,mean_dist] = MSphere_measurement(data)

%The data you enter here, which it the matrix x will be the data from
%ImageJ measurements. The raw data is two columns of X and Y positions with
%line measurements separating between microtubules (these measurements will
%be (0,0)). 

%This first bit organizes the data and collects the number of slices
%obtained per MT. dataset is the organized dataset so that each microtubule gets
%a pair of columns Xi Yi representing the X and Y coordinates, in pixels. MT_slices is
%the number of slices per microtubule.

raw_data = data(:,1:1:2);
i_zeros = [0;find((raw_data(:,1)+raw_data(:,2))==0)];
if i_zeros == 0
    Sphere_steps = length(raw_data);
    i_zeros = [0,length(raw_data)+1];
else
    Sphere_steps = diff(i_zeros)-1;
end  

max_steps = max(Sphere_steps); 

dataset = zeros(max_steps,2*(length(i_zeros)-1));


%dataset is basically taking the raw data between two "stop" points and
%leaves the rest as zeros.
for i = 1:length(i_zeros)-1
    dataset(1:Sphere_steps(i),2*i-1:2*i) = raw_data(i_zeros(i)+1:i_zeros(i+1)-1,:);
end


%number of MTs counted per movie
N_Spheres = length(Sphere_steps); 


%conversion to microns
x_um = dataset*8/100;

x = zeros(max_steps,N_Spheres);
y = zeros(max_steps,N_Spheres);

for j = 1:N_Spheres
    x(:,j) = x_um(:,2*j-1);
    y(:,j) = x_um(:,2*j);
end

x_diff = diff(x);
y_diff = diff(y);


x_c_shift = zeros(size(x));
y_c_shift = zeros(size(y));

for j = 1:N_Spheres
    x_c_shift(1:Sphere_steps(j),j) = x(1:Sphere_steps(j),j) - x(1,j);
    y_c_shift(1:Sphere_steps(j),j) = y(1:Sphere_steps(j),j) - y(1,j);
end

x_shift = zeros(max_steps-1,N_Spheres);
y_shift = zeros(max_steps-1,N_Spheres);
for j = 1:N_Spheres
    x_shift(1:end,j) = x_c_shift(2:end,j);
    y_shift(1:end,j) = y_c_shift(2:end,j);
end

Steps = Sphere_steps-1;

x = cumsum(x_shift);
y = cumsum(y_shift);

A_x = (x_c_shift(1:8,1:end));
Var_x = mean(A_x.^2,2);
A_y = (y_c_shift(1:8,1:end));
Var_y = mean(A_y.^2,2);

x0 = zeros(1,3);
y0 = zeros(1,3);
for j = 1:N_Spheres
    x0(j) = mean(x_c_shift(1:N_diffs(j)+1));
    y0(j) = mean(y_c_shift(1:N_diffs(j)+1));
end



r_orig = zeros(max_steps,N_Spheres);
for j = 1:N_Spheres
    for i = 1:N_diffs(j)+1
        r_orig(i,j) = sqrt((x_um_shift(i,2*j-1))^2+(x_um_shift(i,2*j))^2);        
    end
end


r_orig_0 = zeros(1,N_Spheres);
for j = 1:N_Spheres
    r_orig_0(1,j) = sum(r_orig(1:N_diffs(j)+1,j))./(N_diffs(j)+1);    
end


mean_dist = zeros(size(r_orig));
for i = 1:N_Spheres
    mean_dist(1:N_diffs(i)+1,i) = r_orig(1:N_diffs(i)+1,i)-r_orig_0(1,i);
end

Var_r = zeros(size(r_orig));

for j = 1:N_Spheres
    for i = 1:N_diffs(j)+1
        Var_r(i,j) = mean((mean_dist(1:i,j)).^2);
    end    
end 





end

