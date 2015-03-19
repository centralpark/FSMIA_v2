function cTraj = correctPhotoBleach(trajectory)
global Molecule;
N = length(trajectory);
for k = 1:N-1
    t1 = trajectory(k).trajectory;
    for i = k+1:N-1
        t2 = trajectory(i).trajectory;
        m1 = t1(end);
        m2 = t2(1);
        if (Molecule(m2).frame-Molecule(m1).frame)==2
            coordinate1 = Molecule(m1).coordinate;
            x0 = coordinate1(1);
            y0 = coordinate1(2);
            coordinate2 = Molecule(m2).coordinate;
            x = coordinate2(1);
            y = coordinate2(2);
            if (x0==x)&&(y0==y)
                Molecule(m1).To = m2;
                Molecule(m2).From = m1;
            end
        end
    end
end
cTraj = createData('Trajectory');