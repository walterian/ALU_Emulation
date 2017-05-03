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

% Last Modified by GUIDE v2.5 30-Apr-2017 15:18:19

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

set(handles.twoscomptextbox,'Visible','off');

if get(handles.operandA,'String') == "" %makes sure that there is some value in each operand
    set(handles.operandA,'String','0');
end
if get(handles.operandB,'String') == ""
    set(handles.operandB,'String','0');
end
if get(handles.carryinput,'String') == ""
    set(handles.carryinput,'String','0');
end

opA = str2num(get(handles.operandA,'String'));
cast(opA,'uint8');
opB = str2num(get(handles.operandB,'String')); %#ok<*ST2NM>
cast(opB,'uint8');

opA = de2bi(opA,8,'left-msb');
opB = de2bi(opB,8,'left-msb');

set(handles.textBinaryA,'String',num2str(opA));
set(handles.textBinaryB,'String',num2str(opB));

carryin = str2num(get(handles.carryinput,'String'));
if carryin > 1
    "error"
    return;
end
carryin = de2bi(carryin,8,'left-msb');
carryout = 0;
bione = de2bi(1,8,'left-msb');


if get(handles.buttonAdd,'Value')   %completed
    [sum,carryout] = addnumbers(opA, opB, carryout);
    printoutput(num2str(sum),num2str(carryout),handles)
    
elseif get(handles.buttonSubtract,'Value')
    [diff,carryout] = addnumbers(opA, twoscomp(opB), carryout);
    printoutput(num2str(diff),num2str(carryout),handles);
    if bi2de(opB,8,'left-msb') > bi2de(opA,8,'left-msb')
        set(handles.twoscomptextbox,'Visible','on');
    end
    
elseif get(handles.buttonAddCarry,'Value')
    [sum,carryout] = addnumbers(carryin, opA, carryout);
    [sum,carryout] = addnumbers(sum, opB, carryout);
    printoutput(num2str(sum),num2str(carryout),handles)
    
elseif get(handles.buttonSubBorrow,'Value') %carry flag
    [opBtotal,carryout] = twoscomp(addnumbers(opB, carryin, carryout));
    [diff,carryout] = addnumbers(opA, opBtotal, carryout);
    printoutput(num2str(diff),num2str(carryout),handles);
    
    if bi2de(opBtotal,8,'left-msb') > bi2de(opA,8,'left-msb')
        set(handles.twoscomptextbox,'Visible','on');
    end
    
elseif get(handles.buttonTwosComplement,'Value')
    [mainout,carryout] = twoscomp(opA);
    printoutput(num2str(mainout),num2str(carryout),handles)
    
elseif get(handles.buttonIncrement,'Value')
    [sum,carryout] = addnumbers(opA, bione, carryout);
    printoutput(num2str(sum),num2str(carryout),handles);
    
elseif get(handles.buttonDecrement,'Value')
    [twosOne, carryout] = twoscomp(bione);
    [sum,carryout] = addnumbers(opA, twosOne, carryout);
    printoutput(num2str(sum),num2str(carryout),handles);
    
elseif get(handles.buttonAND,'Value')
    anded = opA & opB;
    printoutput(num2str(anded),num2str(carryout),handles);
    
elseif get(handles.buttonOR,'Value')
    numsORed = opA | opB;
    printoutput(num2str(numsORed),num2str(carryout),handles);
    
elseif get(handles.buttonXOR,'Value')
    numsXORed = xor(opA,opB);
    printoutput(num2str(numsXORed),num2str(carryout),handles);
    
elseif get(handles.buttonOnesComplement,'Value')
    onesCompA = ~opA;
    printoutput(num2str(onesCompA),num2str(carryout),handles);
    
elseif get(handles.buttonLeft,'Value')
    for counter = 1:+1:8    %counts from left to right
        
        if counter == 8 %Checks to see if the counter is at the last bit
            
            opA(counter) = 0;   %if it is, then set that digit to 0
            %(append a zero to the left shifted byte)
            
            break   %breaks out of the for loop so no room for ambiguity(opA(8+1))
        end
        
        if counter == 1 && opA(counter) == 1    %checks to see if there is a 1 in msb
            
            carryout = 1;   %if there is, set the status equal to 1
        end
        
        opA(counter) = opA(counter+1);  %'shifts' each bit to the left
    end
    
    printoutput(num2str(opA),num2str(carryout),handles);

elseif get(handles.buttonRight,'Value')
    for counter = 8:-1:1    %counts from right to left
        %no check here because even if there is a bit in the rightmost
        %location, it just dissapears
        
        if counter == 1
            %need this here because if we don't add it, when opA(counter-1)
            %is at counter = 1, it will try to get the value of opA(0),
            %which doesnt exist and will throw and error
            
            opA(counter) = 0;   %sets the leftmost bit equal to zero
            break   %exits the for loop
        end
        
        opA(counter) = opA(counter-1);  %'shifts' each bit to the right
    end
    
    printoutput(num2str(opA),num2str(carryout),handles);
    
end


function [sum,carryout] =  addnumbers(operandA, operandB, carryout)
sum = operandA+operandB;
for counter = 8:-1:1
    if sum(counter) == 2 && counter == 1
        sum(counter) = 0;
        carryout = carryout + 1;
    elseif sum(counter) == 2    %deals with instances where 1 and 1 are added together
        sum(counter) = 0;
        sum(counter-1) = sum(counter-1) + 1;
    elseif sum(counter) == 3    %deals with instances where there is already a 2 and a 1 is added to it
        sum(counter) = 1;
        if counter == 1
            carryout = carryout + 1;
        else
            sum(counter-1) = sum(counter-1) + 1;
        end
    end
end
    
if ~(carryout == 0 || carryout == 1)
    %%Throw some error
end


function [twoscompvar,garbcarryout] = twoscomp(opA)
garbcarryout = 0;
twoscompvar = addnumbers(~opA, de2bi(1,8,'left-msb'), garbcarryout);


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


function printoutput(primaryoutput, statusoutput, handles)

set(handles.outputdisplaytext,'String',primaryoutput)
set(handles.outputstatus,'String',statusoutput)



% --- Executes on button press in buttonAdd.
function buttonAdd_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAdd (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonAdd
set(handles.carryinput,'Enable','off'); 
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','on');


function carryinput_Callback(hObject, eventdata, handles)
% hObject    handle to carryinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of carryinput as text
%        str2double(get(hObject,'String')) returns contents of carryinput as a double


% --- Executes during object creation, after setting all properties.
function carryinput_CreateFcn(hObject, eventdata, handles)
% hObject    handle to carryinput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonAddCarry.
function buttonAddCarry_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAddCarry (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonAddCarry
set(handles.carryinput,'Enable','on');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonSubtract.
function buttonSubtract_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSubtract (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonSubtract
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonSubBorrow.
function buttonSubBorrow_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSubBorrow (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonSubBorrow
set(handles.carryinput,'Enable','on');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonTwosComplement.
function buttonTwosComplement_Callback(hObject, eventdata, handles)
% hObject    handle to buttonTwosComplement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonTwosComplement
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');


% --- Executes on button press in buttonIncrement.
function buttonIncrement_Callback(hObject, eventdata, handles)
% hObject    handle to buttonIncrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonIncrement
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');


% --- Executes on button press in buttonDecrement.
function buttonDecrement_Callback(hObject, eventdata, handles)
% hObject    handle to buttonDecrement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonDecrement
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');


% --- Executes on button press in buttonAND.
function buttonAND_Callback(hObject, eventdata, handles)
% hObject    handle to buttonAND (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonAND
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonOR.
function buttonOR_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonOR
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonXOR.
function buttonXOR_Callback(hObject, eventdata, handles)
% hObject    handle to buttonXOR (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonXOR
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','on');


% --- Executes on button press in buttonOnesComplement.
function buttonOnesComplement_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOnesComplement (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonOnesComplement
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');


% --- Executes on button press in buttonLeft.
function buttonLeft_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonLeft
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');


% --- Executes on button press in buttonRight.
function buttonRight_Callback(hObject, eventdata, handles)
% hObject    handle to buttonRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of buttonRight
set(handles.carryinput,'Enable','off');
set(handles.carryinput,'String','0');
set(handles.operandB,'Enable','off');
set(handles.operandB,'String','0');

