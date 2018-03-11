function varargout = Decomp(varargin)
% DECOMP MATLAB code for Decomp.fig
%      DECOMP, by itself, creates a new DECOMP or raises the existing
%      singleton*.
%
%      H = DECOMP returns the handle to a new DECOMP or the handle to
%      the existing singleton*.
%
%      DECOMP('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DECOMP.M with the given input arguments.
%
%      DECOMP('Property','Value',...) creates a new DECOMP or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Decomp_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Decomp_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Decomp

% Last Modified by GUIDE v2.5 30-Apr-2013 12:36:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Decomp_OpeningFcn, ...
                   'gui_OutputFcn',  @Decomp_OutputFcn, ...
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


% --- Executes just before Decomp is made visible.
function Decomp_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Decomp (see VARARGIN)

% Choose default command line output for Decomp
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Decomp wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Decomp_OutputFcn(hObject, eventdata, handles) 
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


% --- Executes on button press in Browse.
function Browse_Callback(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile( ...
       {'*.mat', 'All MATLAB Files (*.mat)'; ...
        '*.*',                   'All Files (*.*)'}, ...
        'Pick a file');
    if isequal(filename,0) || isequal(pathname,0)
       handles.IntName = char(null);
     end
    IntName = fullfile(pathname,filename);
    set(handles.edit1,'String',IntName);
    handles.IntName = IntName;
    disp(handles.IntName);
    guidata(hObject,handles);
    
function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double
   handles.IntName = get(hObject,'String');
    disp(handles.IntName);
    guidata(hObject,handles);

% --- Executes on button press in DecompButton.
function DecompButton_Callback(hObject, eventdata, handles)
% hObject    handle to DecompButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
IntName = handles.IntName;
  disp(handles.IntName);
  handles.OutName = DeMars(IntName);
  guidata(hObject,handles);
catch lasterr %#ok<*NASGU>
     errordlg('You Must Enter a ''.mat'' File Path', 'Error', 'modal');
end
Out = strcat('Output : ',handles.OutName);
set(handles.text3,'String',Out);
set(handles.PlayButton,'Visible','on');
    

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
function Browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3
axes(hObject);
imshow('space22.jpg')


% --- Executes on button press in PlayButton.
function PlayButton_Callback(hObject, eventdata, handles)
% hObject    handle to PlayButton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
try
   VideoName = handles.OutName; 
   disp(VideoName);
   implay(VideoName);
%    close;
catch lasterror
    errordlg('Error While Playing Video','Error on Play');
end
