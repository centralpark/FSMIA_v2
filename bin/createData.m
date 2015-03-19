function result = createData(type,varargin)
global Option;
switch type
    case 'Trajectory'
        result = GenerateTrajectory;
    otherwise
        disp('Type not supported!')
        result = [];
end

    function traj = GenerateTrajectory
        global Molecule;
        global Frame;
        traj = cell(2,1);
        
        NumMoleculeLastFrame = length(Frame(end).MoleculeIndex);
        N_frame = length(Frame);
        
        N2 = length(Molecule) - NumMoleculeLastFrame;
        k = 1;
        for i = 1:N2
            % Judge if the molecule is the start of trajectory
            if ~isempty(Molecule(i).To) && isempty(Molecule(i).From)
                temp = zeros(1,N_frame);
                temp(1) = i;
                current = i;
                j = 2;
                while ~isempty(Molecule(current).To)
                    temp(j) = Molecule(current).To;
                    current = Molecule(current).To;
                    j = j+1;
                end
                path = nonzeros(temp);
                traj{k} = path;
                k = k+1;
            end
        end
        
        traj = traj(~cellfun(@isempty,traj));
    end

end