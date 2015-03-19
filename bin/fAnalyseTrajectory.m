function result = fAnalyseTrajectory(trajectory)
result = zeros(1000,1);
global Molecule;
global Option;
p = Option.pixelSize;
N = length(trajectory);

i = 1;
for k = 1:N
    M = length(trajectory(k).trajectory);
    for j = 1:M-1
        m1 = trajectory(k).trajectory(j);
        m2 = trajectory(k).trajectory(j+1);
        x1 = Molecule(m1).parameter(2:3);
        x2 = [((Molecule(m2).coordinate(2)-Molecule(m1).coordinate(2))*p+...
            Molecule(m2).parameter(2)), -(Molecule(m2).coordinate(1)-...
            Molecule(m1).coordinate(1))*p+Molecule(m2).parameter(3)];
        d = pdist([x1;x2]); % Distance moved
        result(i) = d;
        i = i+1;
    end
end
        