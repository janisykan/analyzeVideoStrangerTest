function PlayVideoFile(resultFile)
%filepath,saveFilePath,loadFilePath
    global PLAYBACKSPEED FILETIME LASTTIME SAVEFILE STARTTIME LIGHT HUMAN LOCATION ACTIVITY TOTAL SCREENSHOT
    PLAYBACKSPEED = 1;
    FILETIME = 0;
    LASTTIME = 0;
    SAVEFILE = resultFile;
    load(resultFile)
    STARTTIME.hour = sessionInfo.vidHour;
    STARTTIME.minute = sessionInfo.vidMinute;
    STARTTIME.second = sessionInfo.vidSecond;
    
    handles.filepath = sessionInfo.filename;
    % Create figure to receive activex
    handles.hFigure = figure('position', [50 50 1520 560], 'menubar', 'none', 'numbertitle','off','name', ['Video: ' handles.filepath], 'tag', 'VideoPlay', 'resize', 'off','KeyPressFcn',@keyPress);
    % Create play/pause and seek to 0 button and fast forward button
    handles.hTogglePlayButton = uicontrol(handles.hFigure, 'position', [0 540 80 21], 'string', 'play/pause', 'callback', @TogglePlayPause);
    handles.hSeekToZeroButton = uicontrol(handles.hFigure, 'position', [81 540 80 21], 'string', 'begining','enable','off', 'callback', @SeekToZero);
    handles.hFastForwardButton = uicontrol(handles.hFigure, 'position', [162 540 80 21], 'string', 'x1', 'callback', @FastForward);
%     handles.hRewindButton = uicontrol(handles.hFigure, 'position', [243 540 80 21], 'string', 'rewind', 'callback', @Rewind);
    % Create light conditions radio buttons
    handles.hLightRadioGroup = uibuttongroup('parent',handles.hFigure,'units','pixels','position',[970 500 110 40],'title','Lights','visible','on','SelectionChangedFcn',@ChangeRadio);
    handles.hLightOnRadio = uicontrol(handles.hLightRadioGroup,'units','normalized','position',[0.1 0.05 0.4 0.8],'style','radiobutton','string','On','tag','light on');
    handles.hLightOffRadio = uicontrol(handles.hLightRadioGroup,'units','normalized','position',[0.6 0.05 0.5 0.8],'style','radiobutton','string','Off','tag','light off','Value',abs(LIGHT(1).event-1));
    % Create human in room conditions radio buttons
    handles.hHumanRadioGroup = uibuttongroup('parent',handles.hFigure,'units','pixels','position',[1080 500 110 40],'title','Human In Room','visible','on','SelectionChangedFcn',@ChangeRadio);
    handles.hHumanYesRadio = uicontrol(handles.hHumanRadioGroup,'units','normalized','position',[0.1 0.05 0.4 0.8],'style','radiobutton','string','Yes','tag','human in');
    handles.hHumanNoRadio = uicontrol(handles.hHumanRadioGroup,'units','normalized','position',[0.6 0.05 0.5 0.8],'style','radiobutton','string','No','tag','human out','Value',1);
    % Create location conditions toggle buttons
    onOff = {'off','on'};
    handles.hLocationToggleGroup = uibuttongroup('parent',handles.hFigure,'units','pixels','position',[970 395 240 100],'title','Location','visible','on','SelectionChangedFcn',@ChangeRadio);
    handles.hPenLeftUpToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.01 0.5 0.33 0.5],'style','togglebutton','string','Pen L Up','tag','pen left up','enable',onOff{sessionInfo.housing.penLeft+1},'value',sessionInfo.housing.penLeft);
    handles.hPenLeftDownToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.01 0.01 0.33 0.5],'style','togglebutton','string','Pen L Down','tag','pen left down','enable',onOff{sessionInfo.housing.penLeft+1});
    handles.hCageUpToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.34 0.4 0.33 0.4],'style','togglebutton','string','Cage Up','tag','cage up','enable',onOff{sessionInfo.housing.cageUp+1},'value',sessionInfo.housing.cageUp);
    handles.hCageDownToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.34 0.01 0.33 0.4],'style','togglebutton','string','Cage Down','tag','cage down','enable',onOff{sessionInfo.housing.cageDown+1},'value',sessionInfo.housing.cageDown);
    handles.hPenRightUpToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.67 0.5 0.33 0.5],'style','togglebutton','string','Pen R Up','tag','pen right up','enable',onOff{sessionInfo.housing.penRight+1},'value',sessionInfo.housing.penRight);
    handles.hPenRightDownToggle = uicontrol(handles.hLocationToggleGroup,'units','normalized','position',[0.67 0.01 0.33 0.5],'style','togglebutton','string','Pen R Down','tag','pen right down','enable',onOff{sessionInfo.housing.penRight+1});
    if isempty(LOCATION)
        clear LOCATION
        LOCATION.time = 0;
        LOCATION.event = get(get(handles.hLocationToggleGroup,'SelectedObject'),'tag');
        LOCATION.comment = 'start of file';
        TOTAL = [TOTAL;LOCATION];
        save(SAVEFILE,'LOCATION','TOTAL','-append')
    end
    % Create activity buttons
    tempString = sprintf('At least three limbs occupy the back half of the cage\n(farthest from intruder) for more than 45 frames.');
    handles.hBackButton = uicontrol(handles.hFigure, 'position', [970 145 80 60],'style','togglebutton', 'string', '<html><center>Back of<br>Cage (1)','tag','Back', 'TooltipString', tempString, 'callback', @activityButtons);
    handles.hPaceButton = uicontrol(handles.hFigure, 'position', [1050 145 80 60],'style','togglebutton', 'string', 'Pace (2)','tag','Pace', 'TooltipString', 'Repeated locomotor movement 3 or more times.', 'callback', @activityButtons);
    handles.hFreezeButton = uicontrol(handles.hFigure, 'position', [1130 145 80 60],'style','togglebutton', 'string', 'Freeze (3)','tag','Freeze', 'TooltipString', 'No movement for 60 frames or more.', 'callback', @activityButtons);
    tempString = sprintf('When mouth is puckered and moving quickly\nup and down to produce a smacking sound.\nOften paired with eyebrows and ears back.');
    handles.hLipButton = uicontrol(handles.hFigure, 'position', [970 205 80 60],'style','togglebutton', 'string', 'Lipsmack (4)','tag','Lipsmack', 'TooltipString', tempString, 'callback', @activityButtons);
    tempString = sprintf('A chewing motion of the mouth with\nno food or objects involved.');
    handles.hTeethButton = uicontrol(handles.hFigure, 'position', [1050 205 80 60],'style','togglebutton', 'string', '<html><center>Teeth<br>Gnash (5)','tag','TeethGnash', 'TooltipString',tempString, 'callback', @activityButtons);
    tempString = sprintf('Grin like facial expression with\nlips drawn back showing clenched teeth.\nCan be paired with flapping of\nears and stiff body posture.');
    handles.hFearButton = uicontrol(handles.hFigure, 'position', [1130 205 80 60],'style','togglebutton','string', '<html><center>Fear<br>Grimace (6)','tag','FearGrimace', 'TooltipString', tempString, 'callback', @activityButtons);
    tempString = sprintf('A slow opening of the mouth to an extremely\nwide position often exposing the teeth.');
    handles.hYawnButton = uicontrol(handles.hFigure, 'position', [970 265 80 60],'style','togglebutton', 'string', 'Yawn (7)','tag','Yawn', 'TooltipString', tempString, 'callback', @activityButtons);
    tempString = sprintf('A vigorous stroking of the body with nails.');
    handles.hScratchButton = uicontrol(handles.hFigure, 'position', [1050 265 80 60],'style','togglebutton', 'string', 'Scratch (8)','tag','Scratch', 'TooltipString', tempString, 'callback', @activityButtons);
    tempString = sprintf('Open mouth stare with teeth partially exposed,\neyebrows lifted, ears flattened or flapping,\nrigid body posture, lunging toward the frong of the cage,\nshaking cage vigorously, slapping cage,\nbouncing off walls of cage.');
    handles.hThreatButton = uicontrol(handles.hFigure, 'position', [1130 265 80 60],'style','togglebutton', 'string', '<html><center>Cage-shake/<br>threat (9)','tag','ShakeThreat','TooltipString', tempString, 'callback', @activityButtons);
    tempString = sprintf('Any picking, scraping, spreading, licking,\nor mouth picking of hair or nails.');
    handles.hGroomButton = uicontrol(handles.hFigure, 'position', [970 325 80 60],'style','togglebutton', 'string', '<html><center>Self<br>Groom (/)','tag','Groom','TooltipString', tempString,  'callback', @activityButtons);
    tempString = sprintf('Vigorous biting of any part of the body.');
    handles.hBiteButton = uicontrol(handles.hFigure, 'position', [1050 325 80 60],'style','togglebutton', 'string', 'Self-bite (*)','tag','Bite', 'TooltipString', tempString, 'callback', @activityButtons);
    handles.hOtherActButton = uicontrol(handles.hFigure, 'position', [1130 325 80 60],'style','togglebutton', 'string', 'Other (-)','tag','Other', 'callback', @activityButtons);
    % Create interact buttons
    handles.hInteractPanel = uipanel(handles.hFigure,'units','pixels','position',[970 5 250 130],'Title','Interacting with...');
    handles.hLogButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.01 0.5 0.24 0.4],'style','togglebutton','string','Log','enable',onOff{sessionInfo.enrichments.log+1},'tag','Log','callback',@activityButtons);
    handles.hBallButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.01 0.03 0.24 0.4],'style','togglebutton','string','Ball','enable',onOff{sessionInfo.enrichments.ball+1},'tag','Ball','callback',@activityButtons);
    handles.hMirrorButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.25 0.5 0.24 0.4],'style','togglebutton','string','Mirror','enable',onOff{sessionInfo.enrichments.mirror+1},'tag','Mirror','callback',@activityButtons);
    handles.hKongButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.25 0.03 0.24 0.4],'style','togglebutton','string','Kong','enable',onOff{sessionInfo.enrichments.kong+1},'tag','Kong','callback',@activityButtons);
    handles.hTetrahedronButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.49 0.5 0.26 0.4],'style','togglebutton','string','Tetrahedron','enable',onOff{sessionInfo.enrichments.tetrahedron+1},'tag','Tetrahedron','callback',@activityButtons);
    handles.hPerchButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.49 0.03 0.26 0.4],'style','togglebutton','string','Perch','enable',onOff{sessionInfo.enrichments.perch+1},'tag','Perch','callback',@activityButtons);
    handles.hHumanButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.75 0.5 0.24 0.4],'style','togglebutton','string','Human','tag','Human','enable','off','callback',@activityButtons);
    handles.hOtherIntButton = uicontrol(handles.hInteractPanel,'units','normalized','position',[0.75 0.03 0.24 0.4],'style','togglebutton','string',sessionInfo.enrichments.otherID,'enable',onOff{sessionInfo.enrichments.other+1},'tag','OtherInt','callback',@activityButtons);
    % Create display window
    [~,tempIndex] = sort([TOTAL.time]);
    TOTAL = TOTAL(tempIndex);
    [~,tempIndex] = sort([LIGHT.time]);
    LIGHT = LIGHT(tempIndex);
    [~,tempIndex] = sort([HUMAN.time]);
    HUMAN = HUMAN(tempIndex);
    [~,tempIndex] = sort([LOCATION.time]);
    LOCATION = LOCATION(tempIndex);
    if ~isempty(ACTIVITY)
        [~,tempIndex] = sort([ACTIVITY.time]);
        ACTIVITY = ACTIVITY(tempIndex);
    end
    tempTotal = permute(struct2cell(TOTAL),[2 1 3]);
    spacer = cell(size(tempTotal,1),1);
    spacer(:) = {'  |  '};
    times = cellfun(@convertTimes,tempTotal(:,1),'uniformoutput',false);
    forDisp = cellfun(@horzcat,times,spacer,tempTotal(:,2),spacer,tempTotal(:,3),'uniformoutput',false);
    handles.hDisplayWindow = uicontrol(handles.hFigure,'position', [1230 140 200 300], 'style', 'listbox', 'string', forDisp,'KeyPressFcn',@displayKeyPress);
    handles.hEditButton = uicontrol(handles.hFigure, 'position', [1230 100 70 30], 'string', 'Edit', 'callback', @EditActivity);
    handles.hAddButton = uicontrol(handles.hFigure, 'position', [1300 100 70 30], 'string', 'Add', 'callback', @AddActivity);
    handles.hDeleteButton = uicontrol(handles.hFigure, 'position', [1370 100 70 30], 'string', 'Delete', 'callback', @DeleteActivity);
    handles.hPrtScnButton = uicontrol(handles.hFigure, 'position', [1230 50 70 30], 'string', 'PrtScn', 'callback', @PrintScreen);
    handles.hEditInfoButton = uicontrol(handles.hFigure, 'position', [1300 50 70 30], 'string', 'Edit Info', 'callback', {@EditInfo,sessionInfo});
    handles.hDoneButton = uicontrol(handles.hFigure, 'position', [1370 50 70 30], 'string', 'Done', 'callback', @DoneButton);
    if ~(exist('screencapture','file') == 2)
        set(handles.hPrtScnButton,'enable','off')
    end
    handles.hPlayBackToggle = uicontrol(handles.hFigure,'position', [1230 440 120 30],'style','togglebutton', 'string','Activity Play Back','TooltipString','Press down to turn on scrolling through activity as video plays','Callback',@ReleaseButton);
    % Create activex control
    handles.vlc = actxcontrol('VideoLAN.VLCPlugin.2', [0 0 960 540], handles.hFigure);
    % Format filepath so that VLC can use it (it's what was a problematic for me initialy)
    filepath = handles.filepath;
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
    % Register an event to trigger when video is being played regularly
    handles.vlc.registerevent({'MediaPlayerTimeChanged', @MediaPlayerTimeChanged});
    % Register an event to trigger when video is paused
    handles.vlc.registerevent({'MediaPlayerPaused', @MediaPlayerPaused});
    % Register an event to trigger when video is started
    handles.vlc.registerevent({'MediaPlayerPlaying', @MediaPlayerPlaying});
    % Save handles 
    guidata(handles.hFigure, handles);

        
function keyPress(source,event)
    % control buttons by keypress    
        hFigure = findobj('tag', 'VideoPlay');
        handles = guidata(hFigure);
    switch event.Key
        case {'1','numpad1'}
            status = get(handles.hBackButton,'value');
            set(handles.hBackButton,'value',-status+1)
            activityButtons(handles.hBackButton);
        case {'2','numpad2'}
            status = get(handles.hPaceButton,'value');
            set(handles.hPaceButton,'value',-status+1)
            activityButtons(handles.hPaceButton);
        case {'3','numpad3'}
            status = get(handles.hFreezeButton,'value');
            set(handles.hFreezeButton,'value',-status+1)
            activityButtons(handles.hFreezeButton);
        case {'4','numpad4'}
            status = get(handles.hLipButton,'value');
            set(handles.hLipButton,'value',-status+1)
            activityButtons(handles.hLipButton);
        case {'5','numpad5'}
            status = get(handles.hTeethButton,'value');
            set(handles.hTeethButton,'value',-status+1)
            activityButtons(handles.hTeethButton);
        case {'6','numpad6'}
            status = get(handles.hFearButton,'value');
            set(handles.hFearButton,'value',-status+1)
            activityButtons(handles.hFearButton);
        case {'7','numpad7'}
            status = get(handles.hYawnButton,'value');
            set(handles.hYawnButton,'value',-status+1)
            activityButtons(handles.hYawnButton);
        case {'8','numpad8'}
            status = get(handles.hScratchButton,'value');
            set(handles.hScratchButton,'value',-status+1)
            activityButtons(handles.hScratchButton);
        case {'9','numpad9'}
            status = get(handles.hThreatButton,'value');
            set(handles.hThreatButton,'value',-status+1)
            activityButtons(handles.hThreatButton);
        case {'divide'}
            status = get(handles.hGroomButton,'value');
            set(handles.hGroomButton,'value',-status+1)
            activityButtons(handles.hGroomButton);
        case {'multiply'}
            status = get(handles.hBiteButton,'value');
            set(handles.hBiteButton,'value',-status+1)
            activityButtons(handles.hBiteButton);
        case {'subtract'}
            status = get(handles.hOtherActButton,'value');
            set(handles.hOtherActButton,'value',-status+1)
            activityButtons(handles.hOtherActButton);
        case 'space'
            TogglePlayPause(handles.hTogglePlayButton);
    end
    
function displayKeyPress(source,event)
    % control buttons by keypress    
        hFigure = findobj('tag', 'VideoPlay');
        handles = guidata(hFigure);
    switch event.Key
        case {'delete','backspace'}
            DeleteActivity(handles.hDeleteButton);
            set(handles.hDeleteButton,'Enable','off');
            drawnow;
            set(handles.hDeleteButton,'Enable','on');
        case 'escape'
            set(handles.hDisplayWindow,'Enable','off');
            drawnow;
            set(handles.hDisplayWindow,'Enable','on');
    end
    
function MediaPlayerTimeChanged(varargin)
    global PLAYBACKSPEED FILETIME LASTTIME STARTTIME TOTAL
    % Displays running time in application title
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
%     set(hFigure, 'name', [handles.filepath ' ; ' num2str(handles.vlc.input.Time/1000) ' sec.']); 
    FILETIME = FILETIME + ((toc-LASTTIME)*PLAYBACKSPEED);
    LASTTIME = toc;
    startTime = (STARTTIME.hour*60*60)+(STARTTIME.minute*60)+STARTTIME.second;
    currentTime = startTime + FILETIME;
    currentMin = floor(currentTime/60);
    currentHour = floor(currentMin/60);
    currentMin = mod(currentMin,60);
    currentSec = mod(currentTime,60);
    set(hFigure, 'name', [handles.filepath ' ; ' num2str(currentHour,'%02i') ':' num2str(currentMin,'%02i') ':' num2str(currentSec,'%05.2f') ' sec.']);
    
    % set all the buttons to their correct "state" especially important if
    % importing old file
    if ~isempty(TOTAL)
        tempTotal = permute(struct2cell(TOTAL),[2 1 3]);
        currentIndex = find(cellfun(@(x) x<=FILETIME,tempTotal(:,1)),1,'last');
        onOff = {'off','on'};
        tempIndex = find(~cellfun(@isempty, strfind({TOTAL(1:currentIndex).event},'light')),1,'last');
        set(handles.hLightOnRadio,'value',~isempty(strfind(TOTAL(tempIndex).event,'on')));
        set(handles.hLightOffRadio,'value',~isempty(strfind(TOTAL(tempIndex).event,'off')));
        tempIndex = find(~cellfun(@isempty, strfind({TOTAL(1:currentIndex).event},'human')),1,'last');
        set(handles.hHumanYesRadio,'value',~isempty(strfind(TOTAL(tempIndex).event,'in')));
        set(handles.hHumanNoRadio,'value',~isempty(strfind(TOTAL(tempIndex).event,'out')));
        set(handles.hHumanButton,'enable',onOff{~isempty(strfind(TOTAL(tempIndex).event,'in'))+1})
        tempIndex = find(~cellfun(@isempty, regexp({TOTAL(1:currentIndex).event},'pen|cage')),1,'last');
        tempObj = findobj('tag',TOTAL(tempIndex).event);
        set(tempObj,'value',1);
        if strfind(TOTAL(currentIndex).event,'Back')
            status = strcmpi(TOTAL(currentIndex).event(6:end), 'start');
            tempObj = findobj('tag','Back');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Pace')
            status = strcmpi(TOTAL(currentIndex).event(6:end), 'start');
            tempObj = findobj('tag','Pace');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Freeze')
            status = strcmpi(TOTAL(currentIndex).event(8:end), 'start');
            tempObj = findobj('tag','Freeze');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Lipsmack')
            status = strcmpi(TOTAL(currentIndex).event(10:end), 'start');
            tempObj = findobj('tag','Lipsmack');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'TeethGnash')
            status = strcmpi(TOTAL(currentIndex).event(12:end), 'start');
            tempObj = findobj('tag','TeethGnash');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'FearGrimace')
            status = strcmpi(TOTAL(currentIndex).event(13:end), 'start');
            tempObj = findobj('tag','FearGrimace');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Yawn')
            status = strcmpi(TOTAL(currentIndex).event(6:end), 'start');
            tempObj = findobj('tag','Yawn');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Scratch')
            status = strcmpi(TOTAL(currentIndex).event(9:end), 'start');
            tempObj = findobj('tag','Scratch');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'ShakeThreat')
            status = strcmpi(TOTAL(currentIndex).event(13:end), 'start');
            tempObj = findobj('tag','ShakeThreat');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Groom')
            status = strcmpi(TOTAL(currentIndex).event(7:end), 'start');
            tempObj = findobj('tag','Groom');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Bite')
            status = strcmpi(TOTAL(currentIndex).event(6:end), 'start');
            tempObj = findobj('tag','Bite');
            set(tempObj,'value',status)
        elseif strfind(TOTAL(currentIndex).event,'Other')
            status = strcmpi(TOTAL(currentIndex).event(7:end), 'start');
            tempObj = findobj('tag','Other');
            set(tempObj,'value',status)
        end
        % for going down the list in play back mode
        if get(handles.hPlayBackToggle,'value')
            if isempty(currentIndex)
                currentIndex = 1;
            end
            set(handles.hDisplayWindow,'value',currentIndex);
        end
    end
    if get(handles.hDisplayWindow,'value')<=4
        set(handles.hDeleteButton,'enable','off')
    else
        set(handles.hDeleteButton,'enable','on')
    end
    
    
function MediaPlayerPaused(varargin)
    global LASTTIME
    % Reset time counter when video paused
    LASTTIME = LASTTIME - toc;
    
function MediaPlayerPlaying(varargin)
    % Start time counter when video plays
    tic
    
function ChangeRadio(varargin)
    global FILETIME LIGHT HUMAN LOCATION
    
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    selected = get(varargin{1},'SelectedObject');
    Activity.time = FILETIME;
    Activity.event = strcmpi(get(selected,'string'),'on') || strcmpi(get(selected,'string'),'yes');
    Activity.comment = '';
    if isequal(get(varargin{1},'title'),'Lights')
        LIGHT = [LIGHT;Activity];
        [~,tempIndex] = sort([LIGHT.time]);
        LIGHT = LIGHT(tempIndex);
    elseif isequal(get(varargin{1},'title'),'Human In Room')
        HUMAN = [HUMAN;Activity];
        [~,tempIndex] = sort([HUMAN.time]);
        HUMAN = HUMAN(tempIndex);
        if Activity.event == 1;
            set(handles.hHumanButton,'enable','on')
        else
            set(handles.hHumanButton,'enable','off')
        end
    else
        Activity.event = get(selected,'tag');
        LOCATION = [LOCATION;Activity];
        [~,tempIndex] = sort([LOCATION.time]);
        LOCATION = LOCATION(tempIndex);
    end
    
    Activity.event = get(selected,'tag');
    saveActivity(Activity,selected)
    
    
function activityButtons(varargin)
    global FILETIME ACTIVITY
    % get monkey activity
    event = get(varargin{1},'tag');
    status = get(varargin{1},'value');
    onOff = {' end',' start'};
    Activity.time = FILETIME;
    Activity.event = [event,onOff{status+1}];
    Activity.comment = '';
    ACTIVITY = [ACTIVITY;Activity];
    [~,tempIndex] = sort([ACTIVITY.time]);
    ACTIVITY = ACTIVITY(tempIndex);
    
    saveActivity(Activity,varargin{1})
            
function saveActivity(Activity,buttonHandle)
    global TOTAL LIGHT HUMAN ACTIVITY LOCATION SAVEFILE
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    TOTAL = [TOTAL;Activity];
    [~,tempIndex] = sort([TOTAL.time]);
    TOTAL = TOTAL(tempIndex);
    tempTotal = permute(struct2cell(TOTAL),[2 1 3]);
    spacer = cell(size(tempTotal,1),1);
    spacer(:) = {'  |  '};
    times = cellfun(@convertTimes,tempTotal(:,1),'uniformoutput',false);
    forDisp = cellfun(@horzcat,times,spacer,tempTotal(:,2),spacer,tempTotal(:,3),'uniformoutput',false);
    set(handles.hDisplayWindow,'String',forDisp)
    save(SAVEFILE,'LIGHT','HUMAN','ACTIVITY','LOCATION','TOTAL','-append')
    set(buttonHandle,'Enable','off');
    drawnow;
    set(buttonHandle,'Enable','on');
    
function outputTime = convertTimes(inputTime)
    global STARTTIME
    startTime = (STARTTIME.hour*60*60)+(STARTTIME.minute*60)+STARTTIME.second;
    currentTime = startTime + inputTime;
    currentMin = floor(currentTime/60);
    currentHour = floor(currentMin/60);
    currentMin = mod(currentMin,60);
    currentSec = mod(currentTime,60);
    outputTime = [num2str(currentHour,'%02i') ':' num2str(currentMin,'%02i') ':' num2str(currentSec,'%05.2f')];
    
function EditActivity(varargin)
    global TOTAL LIGHT HUMAN LOCATION ACTIVITY
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    selected = get(handles.hDisplayWindow,'value');
    displayTime = convertTimes(TOTAL(selected).time);
    prompt = {['Time (',displayTime,') :'],'Event:','Comment:'};
    dlg_title = 'Edit Event';
    num_lines = 1;
    defaultans = {num2str(TOTAL(selected).time),TOTAL(selected).event,TOTAL(selected).comment};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return
    end
    time = str2double(answer{1});
    if isnan(time)
        errordlg('Time must be a number');
    end
    Activity.time = time;
    Activity.event = answer{2};
    Activity.comment = answer{3};
    if ~isempty(strfind(TOTAL(selected).event,'light'))
        tempIndex = find([LIGHT.time] == TOTAL(selected).time);
        LIGHT(tempIndex) = [];
        clear tempIndex
        tempActivity = Activity;
        tempActivity.event = ~isempty(strfind(answer{2},'on'));
        LIGHT = [LIGHT;tempActivity];
        [~,tempIndex] = sort([LIGHT.time]);
        LIGHT = LIGHT(tempIndex);
    elseif ~isempty(strfind(TOTAL(selected).event,'human'))
        tempIndex = find([HUMAN.time] == TOTAL(selected).time);
        HUMAN(tempIndex) = [];
        clear tempIndex
        tempActivity = Activity;
        tempActivity.event = ~isempty(strfind(answer{2},'in'));
        HUMAN = [HUMAN;tempActivity];
        [~,tempIndex] = sort([HUMAN.time]);
        HUMAN = HUMAN(tempIndex);
    elseif ~isempty(strfind(TOTAL(selected).event,'pen')) || ~isempty(strfind(TOTAL(selected).event,'cage'))
        tempIndex = find([LOCATION.time] == TOTAL(selected).time);
        LOCATION(tempIndex) = [];
        clear tempIndex
        LOCATION = [LOCATION;Activity];
        [~,tempIndex] = sort([LOCATION.time]);
        LOCATION = LOCATION(tempIndex);
    else
        tempIndex = find([ACTIVITY.time] == TOTAL(selected).time);
        ACTIVITY(tempIndex) = [];
        clear tempIndex
        ACTIVITY = [ACTIVITY;Activity];
        [~,tempIndex] = sort([ACTIVITY.time]);
        ACTIVITY = ACTIVITY(tempIndex); 
    end
    TOTAL(selected) = [];
    saveActivity(Activity,varargin{1})
           
function AddActivity(varargin)
    global TOTAL LIGHT HUMAN LOCATION ACTIVITY
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    selected = get(handles.hDisplayWindow,'value');
    displayTime = convertTimes(TOTAL(selected).time);
    prompt = {['Time (',displayTime,') :'],'Event:','Comment:'};
    dlg_title = 'Edit Activity';
    num_lines = 1;
    defaultans = {num2str(TOTAL(selected).time),TOTAL(selected).event,TOTAL(selected).comment};
    answer = inputdlg(prompt,dlg_title,num_lines,defaultans);
    if isempty(answer)
        return
    end
    try
        time = str2double(answer{1});
    catch
        errordlg('Time must be a number');
        return
    end
    Activity.time = time;
    Activity.event = answer{2};
    Activity.comment = answer{3};
    if ~isempty(strfind(Activity.event,'light'))
        tempActivity = Activity;
        tempActivity.event = ~isempty(strfind(answer{2},'on'));
        LIGHT = [LIGHT;tempActivity];
        [~,tempIndex] = sort([LIGHT.time]);
        LIGHT = LIGHT(tempIndex);
    elseif ~isempty(strfind(Activity.event,'human'))
        tempActivity = Activity;
        tempActivity.event = ~isempty(strfind(answer{2},'in'));
        HUMAN = [HUMAN;tempActivity];
        [~,tempIndex] = sort([HUMAN.time]);
        HUMAN = HUMAN(tempIndex);
    elseif ~isempty(strfind(Activity.event,'pen')) || ~isempty(strfind(Activity.event,'cage'))
        LOCATION = [LOCATION;Activity];
        [~,tempIndex] = sort([LOCATION.time]);
        LOCATION = LOCATION(tempIndex); 
    else
        ACTIVITY = [ACTIVITY;Activity];
        [~,tempIndex] = sort([ACTIVITY.time]);
        ACTIVITY = ACTIVITY(tempIndex); 
    end
    saveActivity(Activity,varargin{1})
 
function DeleteActivity(varargin)
    global TOTAL LIGHT HUMAN LOCATION ACTIVITY SAVEFILE
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    selected = get(handles.hDisplayWindow,'value');
    if ~isempty(strfind(TOTAL(selected).event,'light'))
        tempIndex = find([LIGHT.time] == TOTAL(selected).time);
        LIGHT(tempIndex) = [];
    elseif ~isempty(strfind(TOTAL(selected).event,'human'))
        tempIndex = find([HUMAN.time] == TOTAL(selected).time);
        HUMAN(tempIndex) = [];
    elseif ~isempty(strfind(TOTAL(selected).event,'pen')) || ~isempty(strfind(TOTAL(selected).event,'cage'))
        tempIndex = find([LOCATION.time] == TOTAL(selected).time);
        LOCATION(tempIndex) = [];
    else
        tempIndex = find([ACTIVITY.time] == TOTAL(selected).time);
        ACTIVITY(tempIndex) = [];
    end
    TOTAL(selected) = [];
    
    tempTotal = permute(struct2cell(TOTAL),[2 1 3]);
    spacer = cell(size(tempTotal,1),1);
    spacer(:) = {'  |  '};
    times = cellfun(@convertTimes,tempTotal(:,1),'uniformoutput',false);
    forDisp = cellfun(@horzcat,times,spacer,tempTotal(:,2),spacer,tempTotal(:,3),'uniformoutput',false);
    set(handles.hDisplayWindow,'String',forDisp,'Value',1)
    save(SAVEFILE,'LIGHT','HUMAN','LOCATION','ACTIVITY','TOTAL','-append')
    
function PrintScreen(varargin)
    global FILETIME SCREENSHOT SAVEFILE
    hFigure = findobj('tag', 'VideoPlay');
    imageData = screencapture(hFigure);
    screenie.time = FILETIME;
    screenie.data = imageData;
    screenie.comment = inputdlg('Screenshot comment: ','Screenshot',5);
    SCREENSHOT = [SCREENSHOT;screenie];
    save(SAVEFILE,'SCREENSHOT','-append')
    
    set(varargin{1},'Enable','off');
    drawnow;
    set(varargin{1},'Enable','on');
    
function EditInfo(src,event,sessionInfo)
    global SAVEFILE
    locChoice = {'none'};
    altChoice = {'none'};
    if sessionInfo.housing.penLeft
        locChoice = [locChoice;'Left Pen Up','Left Pen Down'];
        altChoice = [altChoice;'lpu','lpd'];
    end
    if sessionInfo.housing.cageUp
        locChoice = [locChoice;'Cage Up'];
        altChoice = [altChoice;'cu'];
    end
    if sessionInfo.housing.cageDown
        locChoice = [locChoice;'Cage Down'];
        altChoice = [altChoice;'cd'];
    end
    if sessionInfo.housing.penRight
        locChoice = [locChoice;'Right Pen Up','Right Pen Down'];
        altChoice = [altChoice;'rpu','rpd'];
    end
    locChoice = locChoice([2:end,1]);
    altChoice = altChoice([2:end,1]);
    defaultDrink = strfind(altChoice,sessionInfo.waterLocation(9:end));
    drinkVal = find(~cellfun(@isempty,defaultDrink));
    defaultFood = strfind(altChoice,sessionInfo.foodLocation(10:end));
    foodVal = find(~cellfun(@isempty,defaultFood));
    d = dialog('name','Edit File Info','position',[1230 140 250 300]);
    prompt1 = uicontrol('Parent',d,'style','text','units','normalized','position',[0.01 0.9 0.3 0.05],'HorizontalAlignment','right','string','Your Name:');
    prompt2 = uicontrol('Parent',d,'style','text','units','normalized','position',[0.01 0.84 0.3 0.05],'HorizontalAlignment','right','string','Subject Name:');
    prompt3 = uicontrol('Parent',d,'style','text','units','normalized','position',[0.01 0.77 0.3 0.05],'HorizontalAlignment','right','string','Water Location:');
    prompt4 = uicontrol('Parent',d,'style','text','units','normalized','position',[0.01 0.69 0.3 0.05],'HorizontalAlignment','right','string','Food Location:');
    prompt5 = uicontrol('Parent',d,'style','text','units','normalized','position',[0.01 0.62 0.3 0.05],'HorizontalAlignment','right','string','Comments:');
    h.YourName = uicontrol('Parent',d,'style','edit','units','normalized','position',[0.32 0.9 0.6 0.05],'HorizontalAlignment','left','string',sessionInfo.yourName);
    h.SubName = uicontrol('Parent',d,'style','edit','units','normalized','position',[0.32 0.84 0.6 0.05],'HorizontalAlignment','left','string',sessionInfo.subName);
    h.DrinkLoc = uicontrol('Parent',d,'style','popupmenu','units','normalized','position',[0.32 0.78 0.6 0.05],'HorizontalAlignment','left','string',locChoice,'value',drinkVal);
    h.FoodLoc = uicontrol('Parent',d,'style','popupmenu','units','normalized','position',[0.32 0.70 0.6 0.05],'HorizontalAlignment','left','string',locChoice,'value',foodVal);
    h.Comments = uicontrol('Parent',d,'style','edit','units','normalized','position',[0.32 0.12 0.6 0.55],'HorizontalAlignment','left','max',3,'string',sessionInfo.comments);
    h.DoneButton = uicontrol('Parent',d,'style','pushbutton','units','normalized','position',[0.72 0.01 0.2 0.1],'string','Done','callback',{@doneEditInfo,h,sessionInfo});
    uiwait(d)
    
    set(src,'Enable','off');
    drawnow;
    set(src,'Enable','on');
    
    function doneEditInfo(src,event,h,sessionInfo)
    global SAVEFILE
    sessionInfo.yourName = get(h.YourName,'string');
    sessionInfo.subName = get(h.SubName,'string');
    sessionInfo.comments = get(h.Comments,'string');
    chosenDrink = h.DrinkLoc.String(h.DrinkLoc.Value);
    if strcmpi(chosenDrink,'Left Pen Up')
        sessionInfo.waterLocation = 'radioH2Olpu';
    elseif strcmpi(chosenDrink,'Left Pen Down')
        sessionInfo.waterLocation = 'radioH2Olpd';
    elseif strcmpi(chosenDrink,'Cage Up')
        sessionInfo.waterLocation = 'radioH2Ocu';
    elseif strcmpi(chosenDrink,'Cage Down')
        sessionInfo.waterLocation = 'radioH2Ocd';
    elseif strcmpi(chosenDrink,'Right Pen Up')
        sessionInfo.waterLocation = 'radioH2Orpu';
    elseif strcmpi(chosenDrink,'Right Pen Down')
        sessionInfo.waterLocation = 'radioH2Orpd';
    else
        sessionInfo.waterLocation = 'radioH2Onone';
    end
    
    chosenFood = h.FoodLoc.String(h.FoodLoc.Value);
    if strcmpi(chosenFood,'Left Pen Up')
        sessionInfo.foodLocation = 'radioFOODlpu';
    elseif strcmpi(chosenFood,'Left Pen Down')
        sessionInfo.foodLocation = 'radioFOODlpd';
    elseif strcmpi(chosenFood,'Cage Up')
        sessionInfo.foodLocation = 'radioFOODcu';
    elseif strcmpi(chosenFood,'Cage Down')
        sessionInfo.foodLocation = 'radioFOODcd';
    elseif strcmpi(chosenFood,'Right Pen Up')
        sessionInfo.foodLocation = 'radioFOODrpu';
    elseif strcmpi(chosenFood,'Right Pen Down')
        sessionInfo.foodLocation = 'radioFOODrpd';
    else
        sessionInfo.foodLocation = 'radioFOODnone';
    end
    
    save(SAVEFILE,'sessionInfo','-append')
    
    close(get(src,'parent'))
    
    function DoneButton(varargin)
    global SAVEFILE TOTAL LIGHT HUMAN LOCATION ACTIVITY
    choice = questdlg('Are you sure you want to close this window?','Closing window...','Yes','No','No');
    if strcmpi(choice,'No')
        return
    end
    
    save(SAVEFILE,'TOTAL', 'LIGHT', 'HUMAN','LOCATION', 'ACTIVITY','-append')
    close all
    
    
function ReleaseButton(varargin)
    set(varargin{1},'Enable','off');
    drawnow;
    set(varargin{1},'Enable','on');

function TogglePlayPause(varargin)
    global PLAYBACKSPEED
    % Toggle Play/Pause + reset time counter
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    PLAYBACKSPEED = 1;
    handles.vlc.input.rate = PLAYBACKSPEED;
    set(handles.hFastForwardButton,'string',['x',num2str(PLAYBACKSPEED)])
    handles.vlc.playlist.togglePause();
    set(varargin{1},'Enable','off');
    drawnow;
    set(varargin{1},'Enable','on');

function SeekToZero(varargin)
    global FILETIME LASTTIME
    % Seek to begining of file and reset time counter
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    LASTTIME = 0;
    FILETIME = 0;
    tic
    handles.vlc.input.Time = 0;
    set(varargin{1},'Enable','off');
    drawnow;
    set(varargin{1},'Enable','on');
    
function FastForward(varargin)
    % Fast Forward
    global PLAYBACKSPEED
    if PLAYBACKSPEED >= 8
        PLAYBACKSPEED = 1;
    else
        PLAYBACKSPEED = PLAYBACKSPEED*2;
    end
    hFigure = findobj('tag', 'VideoPlay');
    handles = guidata(hFigure);
    handles.vlc.input.rate = PLAYBACKSPEED;
    set(handles.hFastForwardButton,'string',['x',num2str(PLAYBACKSPEED)])
    set(varargin{1},'Enable','off');
    drawnow;
    set(varargin{1},'Enable','on');
   
