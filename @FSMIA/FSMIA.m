classdef FSMIA < handle
   properties
       filename
       Option
       Molecule
       Frame
       connectDistance
   end
   
   methods
       function obj = FSMIA(filename)
           if nargin >0
               obj.filename = filename;
           end
           obj.Option = struct;
           obj.connectDistance = 0;
       end
       
       function obj = set.Option(obj,opt)
           obj.Option = opt;
       end
       
       function setoption(obj)
           opt = struct;
           prompt = {'Threshold','Spot radius (pixels)','Pixel size (nm)',...
               'Exclude region','Connect distance threshold (nm)',...
               'Valley'};
           dlg_title = 'Set the option';
           def = {'','5','160','','0','1200'};
           answer = inputdlg(prompt,dlg_title,1,def);
           opt.threshold = str2double(answer{1});
           opt.spotR = str2double(answer{2});
           opt.pixelSize = str2double(answer{3});
           exclude = str2double(answer{4});
           if isnan(exclude) || isempty(exclude)
               opt.exclude = false;
           else
               opt.exlcude = exclude;
           end
           opt.connectDistance = str2double(answer{5});
           opt.valley = str2double(answer{6});
           obj.Option = opt;
       end
   end
   
end