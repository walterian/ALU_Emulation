function varargout = ALU_emulation(varargin)
% ALU_EMULATION MATLAB code for ALU_emulation.fig
%      ALU_EMULATION, by itself, creates a new ALU_EMULATION or raises the existing
%      singleton*.
%
%      H = ALU_EMULATION returns the handle to a new ALU_EMULATION or the handle to
%      the existing singleton*.
%
%      ALU_EMULATION('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ALU_EMULATION.M with the given input arguments.
%
%      ALU_EMULATION('Property','Value',...) creates a new ALU_EMULATION or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the APPALU before ALU_emulation_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ALU_emulation_OpeningFcn via varargin.
%
%      *See APPALU Options on GUIDE's Tools menu.  Choose "APPALU allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ALU_emulation

% Last Modified by GUIDE v2.5 27-Apr-2017 17:24:13

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ALU_emulation_OpeningFcn, ...
                   'gui_OutputFcn',  @ALU_emulation_OutputFcn, ...
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


% --- Executes just before ALU_emulation is made visible.
function ALU_emulation_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ALU_emulation (see VARARGIN)

% Choose default command line output for ALU_emulation
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ALU_emulation wait for user response (see UIRESUME)
% uiwait(handles.appalu);


% --- Outputs from this function are returned to the command line.
function varargout = ALU_emulation_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in buttonExit.
function buttonExit_Callback(hObject, eventdata, handles)
% hObject    handle to buttonExit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
delete(handles.appalu)


% --- Executes on button press in buttonRun.
function buttonRun_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
opA= str2num(get(handles.operandA,'String'));
set(handles.outputdisplaytext,'String',num2str(opA));


function operandA_Callback(hObject, eventdata, handles)
% hObject    handle to operandA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of operandA as text
%        str2double(get(hObject,'String')) returns contents of operandA as a double


% --- Executes during object creation, after setting all properties.
function operandA_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operandA (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function operandB_Callback(hObject, eventdata, handles)
% hObject    handle to operandB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of operandB as text
%        str2double(get(hObject,'String')) returns contents of operandB as a double


% --- Executes during object creation, after setting all properties.
function operandB_CreateFcn(hObject, eventdata, handles)
% hObject    handle to operandB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
