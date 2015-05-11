function varargout = FilterGUI(varargin)
% FILTERGUI MATLAB code for FilterGUI.fig
%      FILTERGUI, by itself, creates a new FILTERGUI or raises the existing
%      singleton*.
%
%      H = FILTERGUI returns the handle to a new FILTERGUI or the handle to
%      the existing singleton*.
%
%      FILTERGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERGUI.M with the given input arguments.
%
%      FILTERGUI('Property','Value',...) creates a new FILTERGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before FilterGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to FilterGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help FilterGUI

% Last Modified by GUIDE v2.5 30-Mar-2015 17:33:20

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @FilterGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @FilterGUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before FilterGUI is made visible.
function FilterGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to FilterGUI (see VARARGIN)

% Choose default command line output for FilterGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes FilterGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = FilterGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function edit_input_Callback(hObject, eventdata, handles)
% hObject    handle to edit_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_input as text
%        str2double(get(hObject,'String')) returns contents of edit_input as a double


% --- Executes during object creation, after setting all properties.
function edit_input_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_input (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_frame_Callback(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_frame as text
%        str2double(get(hObject,'String')) returns contents of edit_frame as a double


% --- Executes during object creation, after setting all properties.
function edit_frame_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_frame (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function edit_output_Callback(hObject, eventdata, handles)
% hObject    handle to edit_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit_output as text
%        str2double(get(hObject,'String')) returns contents of edit_output as a double


% --- Executes during object creation, after setting all properties.
function edit_output_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit_output (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pushbutton_inFile.
function pushbutton_inFile_Callback(hObject, eventdata, handles)
[FileName,PathName] = uigetfile({'*.nd2';'*.tif';'*.*'},'Select the image to filter');
% If no sif file selected, return
if ~FileName
    return
end
set(handles.edit_input,'String',fullfile(PathName,FileName));


% --- Executes on button press in pushbutton_outFile.
function pushbutton_outFile_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton_outFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName,PathName] = uiputfile('*.tif','Save image as');
% If no sif file selected, return
if ~FileName
    return
end
set(handles.edit_output,'String',fullfile(PathName,FileName));



% --- Executes on button press in button_OK.
function button_OK_Callback(hObject, eventdata, handles)
addpath('/Volumes/Research/MATLAB_lib/bfmatlab/')
data = bfopen(get(handles.edit_input,'String'));
ind = str2double(get(handles.edit_frame,'String'));
img = double(data{1}{ind,1});
[M,~] = size(img);
mid = floor(M/2)+1;
% high pass filtering to remove uneven background
F = fftshift(fft2(img));
F_sub = F;
F_sub(mid-2:mid+2,mid-2:mid+2) = 0;
F_sub(mid,mid) = F(mid,mid);
img_1 = ifft2(ifftshift(F_sub));
% apply median filter to remove single pixel noise
outImage = medfilt2(img_1);
mu = mean(outImage(:));
sigma = std(outImage(:));
fprintf('Recommended threshold: %f\n',mu+4*sigma)
imwrite(uint16(outImage),get(handles.edit_output,'String'));
close(handles.figure1);