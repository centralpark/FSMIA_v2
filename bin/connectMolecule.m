function connectMolecule(m1,m2)
% Connect molecules in different frames
global Molecule;
global Option;
MovePixel = ceil(Option.connectDistance/Option.pixelSize);
coordinate1 = Molecule(m1).coordinate;
x0 = coordinate1(1);
y0 = coordinate1(2);
coordinate2 = Molecule(m2).coordinate;
x = coordinate2(1);
y = coordinate2(2);

% search nearby region of molecule m1
if le(x,x0+MovePixel) && ge(x,x0-MovePixel) && le(y,y0+MovePixel) && ge(y,y0-MovePixel)
    if ~isfield(Molecule(m1),'To')
        Molecule(m1).To = [];
    end
    if ~isfield(Molecule(m1),'From')
        Molecule(m1).From = [];
    end
    if ~isfield(Molecule(m2),'To')
        Molecule(m2).To = [];
    end   
    if ~isfield(Molecule(m2),'From')
        Molecule(m2).From = [];
    end
    
    if isempty(Molecule(m1).To) && isempty(Molecule(m2).From)
        Molecule(m1).To = m2;
        Molecule(m2).From = m1;
    else
        % if there are two neibors, find the closer one
        m3 = Molecule(m1).To;
        para1 = Molecule(m1).parameter;
        p1 = [para1(2) para1(3)];
        para2 = Molecule(m2).parameter;
        p2 = [para2(2) para2(3)];
        para3 = Molecule(m3).parameter;
        p3 = [para3(2) para3(3)];
        if pdist([p1;p2]) < pdist([p1;p3])
            Molecule(m1).To = m2;
            Molecule(m2).From = m1;
            Molecule(m3).From = [];
        end
    end
end