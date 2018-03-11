function varargout = bhavana(varargin)
% BHAVANA MATLAB code for bhavana.fig
%      BHAVANA, by itself, creates a new BHAVANA or raises the existing
%      singleton*.
%
%      H = BHAVANA returns the handle to a new BHAVANA or the handle to
%      the existing singleton*.
%
%      BHAVANA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BHAVANA.M with the given input arguments.
%
%      BHAVANA('Property','Value',...) creates a new BHAVANA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before bhavana_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to bhavana_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help bhavana

% Last Modified by GUIDE v2.5 30-Apr-2013 11:49:42

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @bhavana_OpeningFcn, ...
                   'gui_OutputFcn',  @bhavana_OutputFcn, ...
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


% --- Executes just before bhavana is made visible.
function bhavana_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to bhavana (see VARARGIN)

% Choose default command line output for bhavana
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes bhavana wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = bhavana_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function Browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
       {'*.mpg;*.mp4;*.avi;*.3gp', 'All MATLAB Files (*.mpg, *.mp4, *.avi, *.3gp)'; ...
        '*.*',                   'All Files (*.*)'}, ...
        'Pick a file');
     if isequal(filename,0) || isequal(pathname,0)
       handles.FileName = char(null);
     end
    FileName = fullfile(pathname,filename);
    set(handles.edit1,'String',FileName);
    handles.FileName = FileName;
    disp(handles.FileName);
    guidata(hObject,handles);
    
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
    handles.FileName = get(hObject,'String');
    disp(handles.FileName);
    guidata(hObject,handles);

% --- Executes on button press in CompButton.
function CompButton_Callback(hObject, eventdata, handles)
% hObject    handle to CompButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
  FileName = handles.FileName;
  disp(handles.FileName);
  [handles.IntFile handles.CompressionRatio] = Mars(FileName);
   guidata(hObject,handles);
catch lasterror %#ok<*NASGU>
    errordlg('You Must Enter a Video File Path', 'Error', 'modal');
end
IntFile = strcat('Intermediate File Path : ',handles.IntFile,'.mat');
CR = sprintf('Compression Ratio = %3.2f %%',handles.CompressionRatio);
 set(handles.text3,'String',IntFile);
  set(handles.text4,'String',CR);    

    
% --- Executes on button press in Exit.
function Exit_Callback(hObject, eventdata, handles)
% hObject    handle to Exit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
close;

% --- Executes on button press in Back.
function Back_Callback(hObject, eventdata, handles)
% hObject    handle to Back (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
MarsGUI;


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2
axes(hObject);
imshow('space22.jpg');


% --- Executes during object creation, after setting all properties.
function text3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function text4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
