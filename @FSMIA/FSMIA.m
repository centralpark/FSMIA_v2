classdef FSMIA
   properties
       filename
       Option
       Molecule
   end
   
   methods
       function obj = FSMIA(filename)
           if nargin >0
               obj.filename = filename;
           end
       end
       
       function obj = set.Option(obj,opt)
           obj.Option = opt;
       end
       
       function obj = setoption(obj)
           opt = struct;
           prompt = {'Threshold','Spot radius (number of pixels)','Pixel size (nm)','Exclude region'};
           dlg_title = 'Set the option';
           def = {'','5','160',''};
           answer = inputdlg(prompt,dlg_title,1,def);
           opt.threshold = str2double(answer{1});
           opt.spotR = str2double(answer{2});
           opt.pixelSize = str2double(answer{3});
           opt.exclude = str2double(answer{4});
           obj.Option = opt;
       end
   end
   
end