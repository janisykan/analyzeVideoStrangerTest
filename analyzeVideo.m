                                                                                                 function varargout = analyzeVideo(varargin)
% ANALYZEVIDEO MATLAB code for analyzeVideo.fig
%      ANALYZEVIDEO, by itself, creates a new ANALYZEVIDEO or raises the existing
%      singleton*.
%
%      H = ANALYZEVIDEO returns the handle to a new ANALYZEVIDEO or the handle to
%      the existing singleton*.
%
%      ANALYZEVIDEO('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ANALYZEVIDEO.M with the given input arguments.
%
%      ANALYZEVIDEO('Property','Value',...) creates a new ANALYZEVIDEO or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before analyzeVideo_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to analyzeVideo_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help analyzeVideo

% Last Modified by GUIDE v2.5 16-May-2017 13:48:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @analyzeVideo_OpeningFcn, ...
                   'gui_OutputFcn',  @analyzeVideo_OutputFcn, ...
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


% --- Executes just before analyzeVideo is made visible.
function analyzeVideo_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to analyzeVideo (see VARARGIN)

handles.filename = '';
handles.resultFile = '';

% Choose default command line output for analyzeVideo
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes analyzeVideo wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = analyzeVideo_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function editYourName_Callback(hObject, eventdata, handles)
% hObject    handle to editYourName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYourName as text
%        str2double(get(hObject,'String')) returns contents of editYourName as a double


% --- Executes during object creation, after setting all properties.
function editYourName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYourName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function editOpenVid_Callback(hObject, eventdata, handles)
% hObject    handle to editOpenVid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOpenVid as text
%        str2double(get(hObject,'String')) returns contents of editOpenVid as a double

if isempty(get(hObject,'string'))
    set(handles.buttonShowVid,'enable','off')
else
    set(handles.buttonShowVid,'enable','on')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes during object creation, after setting all properties.
function editOpenVid_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOpenVid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonOpenVid.
function buttonOpenVid_Callback(hObject, eventdata, handles)
% hObject    handle to buttonOpenVid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[filename,path] = uigetfile('*.avi','Choose your video');

if ~isequal(filename,0)
    handles.filename = [path,filename];
    resultPath = [path, 'results\'];
    if exist(resultPath,'dir')
        resultFile = [resultPath, filename(1:end-4), '.mat'];
    else
        resultFile = [path, filename(1:end-4), '.mat'];
    end
    if ~exist(resultFile,'file')
        handles.resultFile = resultFile;
        set(handles.editSaveAs,'string',handles.resultFile);
    end
    set(handles.editOpenVid,'string',handles.filename);
    set(handles.buttonShowVid,'enable','on');
    
    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on button press in buttonShowVid.
function buttonShowVid_Callback(hObject, eventdata, handles)
% hObject    handle to buttonShowVid (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

filepath = get(handles.editOpenVid,'string');
handles.hFigure = figure('position', [50 50 960 540], 'menubar', 'none', 'numbertitle','off','name', ['Video: ' filepath], 'tag', 'ShowVidWindow', 'resize', 'off');
% Create activex control
handles.vlc = actxcontrol('VideoLAN.VLCPlugin.2', [0 0 960 540], handles.hFigure);
% Format filepath so that VLC can use it (it's what was a problematic for me initialy)
filepath(filepath=='\')='/';
filepath = ['file://localhost/' filepath];
% Add file to playlist
handles.vlc.playlist.add(filepath);
% Play file
handles.vlc.playlist.play();
% Deinterlace
handles.vlc.video.deinterlace.enable('x');
% Go back to begining of file
handles.vlc.input.time = 0;

% Update handles structure
guidata(hObject, handles);


function editSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to editSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSaveAs as text
%        str2double(get(hObject,'String')) returns contents of editSaveAs as a double


% --- Executes during object creation, after setting all properties.
function editSaveAs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonSaveAs.
function buttonSaveAs_Callback(hObject, eventdata, handles)
% hObject    handle to buttonSaveAs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if ~isempty(handles.filename)
    [~,tempName,~] = fileparts(handles.filename);
    tempName = [tempName,'.mat'];
else
    tempName = '*.mat';
end
[resultFile,resultPath] = uiputfile(tempName,'Save file name');

if ~isequal(resultFile,0)
    handles.resultFile = [resultPath,resultFile];
    set(handles.editSaveAs,'string',handles.resultFile);
    
    % Update handles structure
    guidata(hObject, handles);
end


% --- Executes on button press in checkLoadPrev.
function checkLoadPrev_Callback(hObject, eventdata, handles)
% hObject    handle to checkLoadPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkLoadPrev

if get(hObject,'Value')
    set(handles.editLoadPrev,'enable','on')
    set(handles.buttonLoadPrev,'enable','on')
else
    set(handles.editLoadPrev,'enable','off')
    set(handles.buttonLoadPrev,'enable','off')
end

% Update handles structure
guidata(hObject, handles);

function editLoadPrev_Callback(hObject, eventdata, handles)
% hObject    handle to editLoadPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editLoadPrev as text
%        str2double(get(hObject,'String')) returns contents of editLoadPrev as a double


% --- Executes during object creation, after setting all properties.
function editLoadPrev_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editLoadPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonLoadPrev.
function buttonLoadPrev_Callback(hObject, eventdata, handles)
% hObject    handle to buttonLoadPrev (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

[oldFile,oldPath] = uigetfile('*.mat');

if ~isequal(oldFile,0)
    handles.oldFile = [oldPath,oldFile];
    set(handles.editLoadPrev,'string',handles.oldFile);
    
    % populate info
    try
        load(handles.oldFile, 'sessionInfo');
    catch
        errordlg('Something is wrong with the file. Please check that you entered it correctly.');
        return
    end
    set(handles.editYourName,'string',sessionInfo.yourName)
    set(handles.editSubName,'string',sessionInfo.subName)
    set(handles.editOpenVid,'string',sessionInfo.filename)
    if ~isempty(get(handles.editOpenVid,'string'))
        set(handles.buttonShowVid,'enable','on')
    end
    set(handles.editMonth,'string',num2str(sessionInfo.vidMonth))
    set(handles.editDay,'string',num2str(sessionInfo.vidDay))
    set(handles.editYear,'string',num2str(sessionInfo.vidYear))
    set(handles.editHour,'string',num2str(sessionInfo.vidHour))
    set(handles.editMinute,'string',num2str(sessionInfo.vidMinute))
    set(handles.editSecond,'string',num2str(sessionInfo.vidSecond))
    set(handles.togglePenLeft,'value',sessionInfo.housing.penLeft)
    set(handles.togglePenRight,'value',sessionInfo.housing.penRight)
    set(handles.toggleCageUp,'value',sessionInfo.housing.cageUp)
    set(handles.toggleCageDown,'value',sessionInfo.housing.cageDown)
    togglePenLeft_Callback(handles.togglePenLeft,eventdata,handles)
    togglePenRight_Callback(handles.togglePenRight,eventdata,handles)
    toggleCageUp_Callback(handles.toggleCageUp,eventdata,handles)
    toggleCageDown_Callback(handles.toggleCageDown,eventdata,handles)
    
    set(handles.checkLog,'value',sessionInfo.enrichments.log)
    set(handles.checkBall,'value',sessionInfo.enrichments.ball)
    set(handles.checkMirror,'value',sessionInfo.enrichments.mirror)
    set(handles.checkKong,'value',sessionInfo.enrichments.kong)
    set(handles.checkTet,'value',sessionInfo.enrichments.tetrahedron)
    set(handles.checkPerch,'value',sessionInfo.enrichments.perch)
    set(handles.checkOther,'value',sessionInfo.enrichments.other)
    set(handles.editOther,'string',sessionInfo.enrichments.otherID)
    set(handles.editComments,'string',sessionInfo.comments)
%     tempTag = get(sessionInfo.waterLocation,'Tag');
    tempObj = findobj('Tag',sessionInfo.waterLocation);
    set(handles.groupWaterLoc,'SelectedObject',tempObj)
%     tempTag = get(sessionInfo.foodLocation,'Tag');
    tempObj = findobj('Tag',sessionInfo.foodLocation);
    set(handles.groupFoodLoc,'SelectedObject',tempObj)
    
    % Update handles structure
    guidata(hObject, handles);
end



function editMonth_Callback(hObject, eventdata, handles)
% hObject    handle to editMonth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMonth as text
%        str2double(get(hObject,'String')) returns contents of editMonth as a double

if isnan(str2double(get(hObject,'String')))
    errordlg('please enter a number between 1-12')
end

temp = str2num(['uint16(' get(hObject,'String') ')']);
set(hObject,'string',num2str(temp,'%02i'))

if str2double(get(hObject,'String'))>12 || str2double(get(hObject,'String'))<1
    errordlg('please enter a number between 1-12')
    set(hObject,'string','mm')
end


% --- Executes during object creation, after setting all properties.
function editMonth_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMonth (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editDay_Callback(hObject, eventdata, handles)
% hObject    handle to editDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editDay as text
%        str2double(get(hObject,'String')) returns contents of editDay as a double

if isnan(str2double(get(hObject,'String')))
    errordlg('please enter a number between 1-31')
end

temp = str2num(['uint16(' get(hObject,'String') ')']);
set(hObject,'string',num2str(temp,'%02i'))

if str2double(get(hObject,'String'))>31 || str2double(get(hObject,'String'))<1
    errordlg('please enter a number between 1-31')
    set(hObject,'string','dd')
end


% --- Executes during object creation, after setting all properties.
function editDay_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editDay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editYear_Callback(hObject, eventdata, handles)
% hObject    handle to editYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editYear as text
%        str2double(get(hObject,'String')) returns contents of editYear as a double

if isnan(str2double(get(hObject,'String')))
    errordlg('please enter a number greater than 2000')
end

temp = str2num(['uint16(' get(hObject,'String') ')']);
set(hObject,'string',num2str(temp))

if str2double(get(hObject,'String'))<2000
    errordlg('please enter a number greater than 2000')
    set(hObject,'string','yyyy')
end


% --- Executes during object creation, after setting all properties.
function editYear_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editYear (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editHour_Callback(hObject, eventdata, handles)
% hObject    handle to editHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editHour as text
%        str2double(get(hObject,'String')) returns contents of editHour as a double

if isnan(str2double(get(hObject,'String')))
    errordlg('please enter a number between 00-23')
end

temp = str2num(['uint16(' get(hObject,'String') ')']);
set(hObject,'string',num2str(temp))

if str2double(get(hObject,'String'))>23 || str2double(get(hObject,'String'))<00
    errordlg('please enter a number between 00-23')
    set(hObject,'string','hh')
end


% --- Executes during object creation, after setting all properties.
function editHour_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editHour (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editMinute_Callback(hObject, eventdata, handles)
% hObject    handle to editMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editMinute as text
%        str2double(get(hObject,'String')) returns contents of editMinute as a double

if isnan(str2double(get(hObject,'String')))
    errordlg('please enter a number between 00-59')
end

temp = str2num(['uint16(' get(hObject,'String') ')']);
set(hObject,'string',num2str(temp))

if str2double(get(hObject,'String'))>59 || str2double(get(hObject,'String'))<00
    errordlg('please enter a number between 00-59')
    set(hObject,'string','mm')
end


% --- Executes during object creation, after setting all properties.
function editMinute_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editMinute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function editSecond_Callback(hObject, eventdata, handles)
% hObject    handle to editSecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSecond as text
%        str2double(get(hObject,'String')) returns contents of editSecond as a double

if isnan(str2double(get(hObject,'String'))) || str2double(get(hObject,'String'))>59 || str2double(get(hObject,'String'))<00
    errordlg('please enter a number between 00-59')
end


% --- Executes during object creation, after setting all properties.
function editSecond_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSecond (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in checkLog.
function checkLog_Callback(hObject, eventdata, handles)
% hObject    handle to checkLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkLog


% --- Executes on button press in checkBall.
function checkBall_Callback(hObject, eventdata, handles)
% hObject    handle to checkBall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkBall


% --- Executes on button press in checkMirror.
function checkMirror_Callback(hObject, eventdata, handles)
% hObject    handle to checkMirror (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkMirror


% --- Executes on button press in checkKong.
function checkKong_Callback(hObject, eventdata, handles)
% hObject    handle to checkKong (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkKong


% --- Executes on button press in checkTet.
function checkTet_Callback(hObject, eventdata, handles)
% hObject    handle to checkTet (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkTet


% --- Executes on button press in checkPerch.
function checkPerch_Callback(hObject, eventdata, handles)
% hObject    handle to checkPerch (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkPerch


% --- Executes on button press in checkOther.
function checkOther_Callback(hObject, eventdata, handles)
% hObject    handle to checkOther (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkOther

if get(hObject,'Value')
    set(handles.editOther,'enable','on')
else
    set(handles.editOther,'enable','off')
end

% Update handles structure
guidata(hObject, handles);



function editOther_Callback(hObject, eventdata, handles)
% hObject    handle to editOther (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editOther as text
%        str2double(get(hObject,'String')) returns contents of editOther as a double


% --- Executes during object creation, after setting all properties.
function editOther_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editOther (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in togglePenLeft.
function togglePenLeft_Callback(hObject, eventdata, handles)
% hObject    handle to togglePenLeft (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglePenLeft

if get(hObject,'value')
    set(handles.radioH2Olpu,'enable','on')
    set(handles.radioH2Olpd,'enable','on')
    set(handles.radioFOODlpu,'enable','on')
    set(handles.radioFOODlpd,'enable','on')
else
    set(handles.radioH2Olpu,'enable','off')
    set(handles.radioH2Olpd,'enable','off')
    set(handles.radioFOODlpu,'enable','off')
    set(handles.radioFOODlpd,'enable','off')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in togglePenRight.
function togglePenRight_Callback(hObject, eventdata, handles)
% hObject    handle to togglePenRight (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglePenRight

if get(hObject,'value')
    set(handles.radioH2Orpu,'enable','on')
    set(handles.radioH2Orpd,'enable','on')
    set(handles.radioFOODrpu,'enable','on')
    set(handles.radioFOODrpd,'enable','on')
else
    set(handles.radioH2Orpu,'enable','off')
    set(handles.radioH2Orpd,'enable','off')
    set(handles.radioFOODrpu,'enable','off')
    set(handles.radioFOODrpd,'enable','off')
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on button press in toggleCageDown.
function toggleCageDown_Callback(hObject, eventdata, handles)
% hObject    handle to toggleCageDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleCageDown

if get(hObject,'value')
    set(handles.radioH2Ocd,'enable','on')
    set(handles.radioFOODcd,'enable','on')
else
    set(handles.radioH2Ocd,'enable','off')
    set(handles.radioFOODcd,'enable','off')
end

% Update handles structure
guidata(hObject, handles);

% --- Executes on button press in toggleCageUp.
function toggleCageUp_Callback(hObject, eventdata, handles)
% hObject    handle to toggleCageUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of toggleCageUp

if get(hObject,'value')
    set(handles.radioH2Ocu,'enable','on')
    set(handles.radioFOODcu,'enable','on')
else
    set(handles.radioH2Ocu,'enable','off')
    set(handles.radioFOODcu,'enable','off')
end

% Update handles structure
guidata(hObject, handles);


function editComments_Callback(hObject, eventdata, handles)
% hObject    handle to editComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editComments as text
%        str2double(get(hObject,'String')) returns contents of editComments as a double


% --- Executes during object creation, after setting all properties.
function editComments_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editComments (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in buttonStart.
function buttonStart_Callback(hObject, eventdata, handles)
% hObject    handle to buttonStart (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sessionInfo.yourName = get(handles.editYourName,'string');
if isempty(sessionInfo.yourName)
    errordlg('please fill out your name');
    return
end
sessionInfo.subName = get(handles.editSubName,'string');
if isempty(sessionInfo.subName)
    errordlg('please fill out subject''s name');
    return
end
sessionInfo.filename = get(handles.editOpenVid,'string');
if isempty(sessionInfo.filename)
    errordlg('please indicate video file to use');
    return
end
sessionInfo.resultFile = get(handles.editSaveAs,'string');
if isempty(sessionInfo.resultFile)
    errordlg('please indicate file to save results to');
    return
end
sessionInfo.vidMonth = str2double(get(handles.editMonth,'string'));
sessionInfo.vidDay = str2double(get(handles.editDay,'string'));
sessionInfo.vidYear = str2double(get(handles.editYear,'string'));
if isnan(sessionInfo.vidMonth) || isnan(sessionInfo.vidDay) || isnan(sessionInfo.vidYear)
    errordlg('please enter a valid date');
    return
end
curDate = datenum(date,'dd-mmm-yyyy');
sessionDate = [num2str(sessionInfo.vidMonth,'%02i') '/' num2str(sessionInfo.vidDay,'%02i') '/' num2str(sessionInfo.vidYear)];
sessionDate = datenum(sessionDate,'mm/dd/yyyy');
if sessionDate>curDate
    choice = questdlg('The date you''ve entered is later than today''s date according to your computer. Do you wish to continue?','Questionable date warning','Yes','No','No');
    if strcmp(choice,'No')
        return
    end
end
sessionInfo.vidHour = str2double(get(handles.editHour,'string'));
sessionInfo.vidMinute = str2double(get(handles.editMinute,'string'));
sessionInfo.vidSecond = str2double(get(handles.editSecond,'string'));
if isnan(sessionInfo.vidHour) || isnan(sessionInfo.vidMinute) || isnan(sessionInfo.vidSecond)
    errordlg('please enter a valid time');
    return
end
sessionInfo.housing.penLeft = get(handles.togglePenLeft,'value');
sessionInfo.housing.penRight = get(handles.togglePenRight,'value');
sessionInfo.housing.cageUp = get(handles.toggleCageUp,'value');
sessionInfo.housing.cageDown = get(handles.toggleCageDown,'value');
if ~sessionInfo.housing.penLeft && ~sessionInfo.housing.penRight && ~sessionInfo.housing.cageUp && ~sessionInfo.housing.cageDown
    errordlg('No housing is selected')
    return
end
sessionInfo.enrichments.log = get(handles.checkLog,'value');
sessionInfo.enrichments.ball = get(handles.checkBall,'value');
sessionInfo.enrichments.mirror = get(handles.checkMirror,'value');
sessionInfo.enrichments.kong = get(handles.checkKong,'value');
sessionInfo.enrichments.tetrahedron = get(handles.checkTet,'value');
sessionInfo.enrichments.perch = get(handles.checkPerch,'value');
sessionInfo.enrichments.other = get(handles.checkOther,'value');
if sessionInfo.enrichments.other
    sessionInfo.enrichments.otherID = get(handles.editOther,'string');
else
    sessionInfo.enrichments.otherID = 'N/A';
end
sessionInfo.comments = get(handles.editComments,'string');
tempObj = get(handles.groupWaterLoc,'SelectedObject');
sessionInfo.waterLocation = get(tempObj,'tag');
if strcmpi(get(tempObj,'enable'),'off')
    choice = questdlg('Water location is not on an active cage. Do you wish to continue?','Water location error','Yes','No','No');
    if strcmpi(choice,'No')
        return
    end
end
tempObj = get(handles.groupFoodLoc,'SelectedObject');
sessionInfo.foodLocation = get(tempObj,'tag');
if strcmpi(get(tempObj,'enable'),'off')
    choice = questdlg('Food location is not on an active cage. Do you wish to continue?','Food location error','Yes','No','No');
    if strcmpi(choice,'No')
        return
    end
end
if get(handles.checkLoadPrev,'value')
    sessionInfo.oldfile = get(handles.editLoadPrev,'string');
    try
        load(sessionInfo.oldfile,'LIGHT','HUMAN','LOCATION','ACTIVITY','TOTAL','SCREENSHOT')
    catch
        errordlg('Please check the name/path of the previous file you''d like to load.')
        return
    end
    try
        load(sessionInfo.oldfile,'CONDITION')
    catch
        errordlg('Missing test condition. Probably made using old version of code. Adding condtion as "other." You might want to check this or start over.')
        CONDITION.time = 0;
        CONDITION.event = get(get(handles.hTestRadioGroup,'SelectedObject'),'tag');
        CONDITION.comment = 'start of file';
        if size(TOTAL,1)>3
            TOTAL = [TOTAL(1:3);CONDITION;TOTAL(4:end)];
        else
            TOTAL = [TOTAL(1:3);CONDITION];
        end
    end
else
    sessionInfo.oldfile = '';
    LIGHT.time = 0;
    LIGHT.event = 1;
    LIGHT.comment = 'start of file';
    HUMAN.time = 0;
    HUMAN.event = 0;
    HUMAN.comment = 'start of file';
    LOCATION = [];
    ACTIVITY = [];
    CONDITION = [];
    [TOTAL(1:2,1).time] = deal(0);
    event = {'off','on'};
    TOTAL(1,1).event = ['light ' event{LIGHT.event+1}];
    TOTAL(2,1).event = 'human out';
    [TOTAL(1:2,1).comment] = deal('start of file');
    SCREENSHOT = [];
end


save(sessionInfo.resultFile,'sessionInfo','LIGHT','HUMAN','LOCATION','ACTIVITY','CONDITION','TOTAL','SCREENSHOT')

PlayVideoFile(sessionInfo.resultFile)

close(handles.figure1)
if isfield(handles,'hFigure')
    close(handles.hFigure)
end



% --- Executes on button press in buttonCancel.
function buttonCancel_Callback(hObject, eventdata, handles)
% hObject    handle to buttonCancel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

close


%% WHAT ARE THESE THINGS?????

% --- Executes on button press in togglebutton2.
function togglebutton2_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton2


% --- Executes on button press in togglebutton3.
function togglebutton3_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton3


% --- Executes on button press in togglebutton4.
function togglebutton4_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton4


% --- Executes on button press in togglebutton5.
function togglebutton5_Callback(hObject, eventdata, handles)
% hObject    handle to togglebutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of togglebutton5



function edit1_Callback(hObject, eventdata, handles)
% hObject    handle to edit1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit1 as text
%        str2double(get(hObject,'String')) returns contents of edit1 as a double


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


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function editSubName_Callback(hObject, eventdata, handles)
% hObject    handle to editSubName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of editSubName as text
%        str2double(get(hObject,'String')) returns contents of editSubName as a double


% --- Executes during object creation, after setting all properties.
function editSubName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to editSubName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on key press with focus on buttonOpenVid and none of its controls.
function buttonOpenVid_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to buttonOpenVid (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    buttonOpenVid_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on buttonSaveAs and none of its controls.
function buttonSaveAs_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to buttonSaveAs (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    buttonSaveAs_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on checkLoadPrev and none of its controls.
function checkLoadPrev_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkLoadPrev (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    checkLoadPrev_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on togglePenLeft and none of its controls.
function togglePenLeft_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to togglePenLeft (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    togglePenLeft_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on toggleCageUp and none of its controls.
function toggleCageUp_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to toggleCageUp (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    toggleCageUp_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on toggleCageDown and none of its controls.
function toggleCageDown_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to toggleCageDown (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    toggleCageDown_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on togglePenRight and none of its controls.
function togglePenRight_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to togglePenRight (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    togglePenRight_Callback(hObject, eventdata, handles)
end


% --- Executes on key press with focus on radioH2Olpu and none of its controls.
function radioH2Olpu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Olpu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Olpd and none of its controls.
function radioH2Olpd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Olpd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Ocu and none of its controls.
function radioH2Ocu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Ocu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Ocd and none of its controls.
function radioH2Ocd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Ocd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Orpu and none of its controls.
function radioH2Orpu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Orpu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Orpd and none of its controls.
function radioH2Orpd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Orpd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioH2Onone and none of its controls.
function radioH2Onone_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioH2Onone (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupWaterLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODlpu and none of its controls.
function radioFOODlpu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODlpu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODlpd and none of its controls.
function radioFOODlpd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODlpd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODcu and none of its controls.
function radioFOODcu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODcu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODcd and none of its controls.
function radioFOODcd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODcd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODrpu and none of its controls.
function radioFOODrpu_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODrpu (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODrpd and none of its controls.
function radioFOODrpd_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODrpd (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on radioFOODnone and none of its controls.
function radioFOODnone_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to radioFOODnone (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    set(handles.groupFoodLoc,'SelectedObject',hObject)
end

% Update handles structure
guidata(hObject, handles);


% --- Executes on key press with focus on checkLog and none of its controls.
function checkLog_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkLog (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkBall and none of its controls.
function checkBall_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkBall (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkMirror and none of its controls.
function checkMirror_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkMirror (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkKong and none of its controls.
function checkKong_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkKong (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkTet and none of its controls.
function checkTet_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkTet (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkPerch and none of its controls.
function checkPerch_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkPerch (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
end


% --- Executes on key press with focus on checkOther and none of its controls.
function checkOther_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to checkOther (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

key = get(gcf,'CurrentKey');
if(strcmp (key , 'return'))
    value = abs(get(hObject,'value')-1);
    set(hObject,'value',value)
    checkOther_Callback(hObject, eventdata, handles)
end
