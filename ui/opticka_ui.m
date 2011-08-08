function varargout = opticka_ui(varargin)
% OPTICKA_UI M-file for opticka_ui.fig
%      OPTICKA_UI, by itself, creates a new OPTICKA_UI or raises the existing
%      singleton*.
%
%      H = OPTICKA_UI returns the handle to a new OPTICKA_UI or the handle to
%      the existing singleton*.
%
%      OPTICKA_UI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in OPTICKA_UI.M with the given input arguments.
%
%      OPTICKA_UI('Property','Value',...) creates a new OPTICKA_UI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before opticka_ui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to opticka_ui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help opticka_ui

% Last Modified by GUIDE v2.5 08-Aug-2011 03:31:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
	'gui_Singleton',  gui_Singleton, ...
	'gui_OpeningFcn', @opticka_ui_OpeningFcn, ...
	'gui_OutputFcn',  @opticka_ui_OutputFcn, ...
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


% --- Executes just before opticka_ui is made visible.
function opticka_ui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to opticka_ui (see VARARGIN)

% Choose default command line output for opticka_ui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes opticka_ui wait for user response (see UIRESUME)
% uiwait(handles.OKRoot);


% --- Outputs from this function are returned to the command line.
function varargout = opticka_ui_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --------------------------------------------------------------------
function OKMenuFile_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuEdit_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuTools_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuTools (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --------------------------------------------------------------------
function OKMenuNewProtocol_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuNewProtocol (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r=[];
	set(handles.OKPanelDots,'Visible','off')
	set(handles.OKPanelSpot,'Visible','off')
	set(handles.OKPanelBar,'Visible','off')
	%set(handles.OKPanelPlaid,'Visible','off')
	set(handles.OKPanelGrating,'Visible','on')
	o.store.visibleStimulus='grating';
	o.store.gratingN = 0;
	o.store.barN = 0;
	o.store.dotsN = 0;
	o.store.spotN = 0;
	o.store.plaidN = 0;
	o.store.noiseN = 0;
	o.clearStimulusList;
	o.clearVariableList;
	o.getScreenVals;
	o.getTaskVals;
end

% --------------------------------------------------------------------
function OKMenuOpen_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuOpen (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('loadProtocol','1');
end

% --------------------------------------------------------------------
function OKMenuSave_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('saveProtocol');
end

% --------------------------------------------------------------------
function OKMenuQuit_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuQuit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.savePrefs;
	rmappdata(handles.output,'o');
	clear o;
end
close(gcf);

% --------------------------------------------------------------------
function OKMenuStimulusLog_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuStimulusLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.task.showLog;
end

% --------------------------------------------------------------------
function OKMenuShowGammaPlots_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuShowGammaPlots (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if isa(o.r.gammaTable,'calibrateLuminance')
		o.r.gammaTable.plot;
	end
end
% --------------------------------------------------------------------
function OKMenuLogs_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuLogs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuCheckIO_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuCheckIO (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuEditConfiguration_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuEditConfiguration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuAllTimingLogs_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuAllTimingLogs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.getTimeLog;
end

% --------------------------------------------------------------------
function OKMenuMissedFrames_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuMissedFrames (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuCut_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuCut (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuCopy_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuCopy (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuPaste_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuPaste (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in OKSelectScreen.
function OKSelectScreen_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end


function OKMonitorDistance_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end


function OKPixelsPerCm_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end


function OKXCenter_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKYCenter_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKWindowSize_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKGLSrc_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end


function OKGLDst_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKbitDepth_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKAntiAliasing_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKUseGamma_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKSerialPortName_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKUsePhotoDiode.
function OKUsePhotoDiode_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKuseLabJack.
function OKuseLabJack_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKVerbose.
function OKVerbose_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKlogFrames.
function OKlogFrames_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKOpenGLBlending.
function OKOpenGLBlending_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKHideFlash.
function OKHideFlash_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

% --- Executes on button press in OKDebug.
function OKDebug_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKbackgroundColour_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKFixationSpot_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKrecordMovie_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getScreenVals;
end

function OKnTrials_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKisTime_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKtrialTime_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKrealTime_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

% --------------------------------------------------------------------
function OKMenuNoiseTexture_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuNoiseTexture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OKPanelDots,'Visible','off')
set(handles.OKPanelGrating,'Visible','off')
set(handles.OKPanelNoise,'Visible','on')

% --------------------------------------------------------------------
function OKMenuLineTexture_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuLineTexture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function OKMenuDots_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%set(handles.OKPanelNoise,'Visible','off')
set(handles.OKPanelTexture,'Visible','off')
set(handles.OKPanelGrating,'Visible','off')
set(handles.OKPanelBar,'Visible','off')
set(handles.OKPanelSpot,'Visible','off')
set(handles.OKPanelDots,'Visible','on')
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.visibleStimulus='dots';
end

% --------------------------------------------------------------------
function OKMenuBar_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuBar (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OKPanelTexture,'Visible','off')
set(handles.OKPanelGrating,'Visible','off')
set(handles.OKPanelSpot,'Visible','off')
set(handles.OKPanelBar,'Visible','on')
set(handles.OKPanelDots,'Visible','off')
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.visibleStimulus='bar';
end

% --------------------------------------------------------------------
function OKMenuGrating_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuGrating (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OKPanelTexture,'Visible','off')
set(handles.OKPanelDots,'Visible','off')
set(handles.OKPanelSpot,'Visible','off')
set(handles.OKPanelBar,'Visible','off')
set(handles.OKPanelGrating,'Visible','on')
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.visibleStimulus='grating';
end

% --------------------------------------------------------------------
function OKMenuSpot_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuSpot (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OKPanelTexture,'Visible','off')
set(handles.OKPanelGrating,'Visible','off')
set(handles.OKPanelBar,'Visible','off')
set(handles.OKPanelDots,'Visible','off')
set(handles.OKPanelSpot,'Visible','on')
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.visibleStimulus='spot';
end

% --------------------------------------------------------------------
function OKMenuTexture_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuTexture (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.OKPanelTexture,'Visible','on')
set(handles.OKPanelGrating,'Visible','off')
set(handles.OKPanelBar,'Visible','off')
set(handles.OKPanelDots,'Visible','off')
set(handles.OKPanelSpot,'Visible','off')
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.visibleStimulus='texture';
end


% --------------------------------------------------------------------
function OKMenuPreferences_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function OKPanelGratingtype_Callback(hObject, eventdata, handles)
switch get(hObject,'Value')
	case {1,2}
		set(handles.OKPanelGratingaspectRatio,'Enable','off')
		%set(handles.OKPanelGratingcontrastMult,'Enable','off')
		set(handles.OKPanelGratingspatialConstant,'Enable','off')
		set(handles.OKPanelGratingdisableNorm,'Enable','off')
		set(handles.OKPanelGratingmask,'Enable','on')
		set(handles.OKPanelGratingsigma,'Enable','on')
		set(handles.OKPanelGratinguseAlpha,'Enable','on')
		set(handles.OKPanelGratingsmoothMethod,'Enable','on')
		set(handles.OKPanelGratingrotationMethod,'Enable','on')
	otherwise
		set(handles.OKPanelGratingaspectRatio,'Enable','on')
		%set(handles.OKPanelGratingcontrastMult,'Enable','on')
		set(handles.OKPanelGratingspatialConstant,'Enable','on')
		set(handles.OKPanelGratingdisableNorm,'Enable','on')
		set(handles.OKPanelGratingmask,'Enable','off')
		set(handles.OKPanelGratingsigma,'Enable','off')
		set(handles.OKPanelGratinguseAlpha,'Enable','off')
		set(handles.OKPanelGratingsmoothMethod,'Enable','off')
		set(handles.OKPanelGratingrotationMethod,'Enable','off')
end



function OKProtocolsList_Callback(hObject, eventdata, handles)


function pushbutton22_Callback(hObject, eventdata, handles)


function OKHistoryList_Callback(hObject, eventdata, handles)


% --- Executes on button press in OKProtocolLoad.
function OKProtocolLoad_Callback(hObject, eventdata, handles)
% hObject    handle to OKProtocolLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('loadProtocol');
end

% --- Executes on button press in OKProtocolSave.
function OKProtocolSave_Callback(hObject, eventdata, handles)
% hObject    handle to OKProtocolSave (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('saveProtocol');
end

% --- Executes on button press in OKProtocolDuplicate.
function OKProtocolDuplicate_Callback(hObject, eventdata, handles)
% hObject    handle to OKProtocolDuplicate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('duplicateProtocol');
end

% --- Executes on button press in OKProtocolDelete.
function OKProtocolDelete_Callback(hObject, eventdata, handles)
% hObject    handle to OKProtocolDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.router('deleteProtocol');
end

% --------------------------------------------------------------------
function OKMenuCalibrateLuminance_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuCalibrateLuminance (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	v=get(handles.OKSelectScreen,'Value');
	inp = struct('screen',v-1);
	if isa(o.r.gammaTable,'calibrateLuminance')
		o.r.gammaTable.run;
	else
		c = calibrateLuminance(inp);
		c.filename = [o.paths.calibration filesep 'Calibration-' date '-' o.r.gammaTable.comments];
		o.r.gammaTable = c;
		o.saveCalibration;
	end
	set(handles.OKUseGamma,'Value',1)
	o.r.gammaTable.choice = 0; 
	set(handles.OKUseGamma,'String',['None'; 'Gamma'; o.r.gammaTable.analysisMethods]);
end

% --------------------------------------------------------------------
function OKMenuLoadGamma_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuLoadGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	uiopen('~/MatlabFiles/Calibration')
	if exist('tmp','var') && isa(tmp,'calibrateLuminance')
		o.r.gammaTable = tmp;
		clear tmp;
		if get(handles.OKUseGamma,'Value') > length(['None'; 'Gamma'; o.r.gammaTable.analysisMethods])
			set(handles.OKUseGamma,'Value',1);
			o.r.gammaTable.choice = 0; 
		else
			o.r.gammaTable.choice = get(handles.OKUseGamma,'Value')-1;
		end
		set(handles.OKUseGamma,'String',['None'; 'Gamma'; o.r.gammaTable.analysisMethods]);
	end
end

% --------------------------------------------------------------------
function OKMenuSaveGamma_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuSaveGamma (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if isa(o.r.gammaTable,'calibrateLuminance')
		tmp=o.r.gammaTable;
		uisave('tmp',[o.paths.calibration filesep 'Calibration-' date '-' o.r.gammaTable.comments]);
	end
end

% --------------------------------------------------------------------
function OKMenuCalibrateSize_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenuCalibrateSize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
v=get(handles.OKSelectScreen,'Value');
s=str2num(get(handles.OKMonitorDistance,'String')); 
[~,dpc]=calibrateSize(v-1,s);
set(handles.OKPixelsPerCm,'String',num2str(dpc));


function OKitTime_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKRandomise_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end
% --- Executes on selection change in OKrandomGenerator.
function OKrandomGenerator_Callback(hObject, eventdata, handles)
% hObject    handle to OKrandomGenerator (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns OKrandomGenerator contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OKrandomGenerator
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKRandomSeed_Callback(hObject, eventdata, handles)
% hObject    handle to OKRandomSeed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'String') returns contents of OKRandomSeed as text
%        str2double(get(hObject,'String')) returns contents of OKRandomSeed as a double
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

% --- Executes on button press in OKHistoryUp.
function OKHistoryUp_Callback(hObject, eventdata, handles)
% hObject    handle to OKHistoryUp (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OKHistoryDown.
function OKHistoryDown_Callback(hObject, eventdata, handles)
% hObject    handle to OKHistoryDown (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OKHistoryDelete.
function OKHistoryDelete_Callback(hObject, eventdata, handles)
% hObject    handle to OKHistoryDelete (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in OKVariableList.
function OKVariableList_Callback(hObject, eventdata, handles)
% hObject    handle to OKVariableList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OKVariableList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OKVariableList

% --- Executes on button press in OKCopyVariableName.
function OKCopyVariableName_Callback(hObject, eventdata, handles)
% hObject    handle to OKCopyVariableName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
string = get(handles.OKVariableList,'String');
value = get(handles.OKVariableList,'Value');
string=string{value};
set(handles.OKVariableName,'String',string);

function OKCopyVariableNameValues_Callback(hObject, eventdata, handles)
string = get(handles.OKVariableList,'String');
value = get(handles.OKVariableList,'Value');
string=string{value};
set(handles.OKVariableName,'String',string);

switch string
	case 'angle'
		string = num2str(-90:45:90);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'motionAngle'
		string = num2str(-90:45:90);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'phase'
		string = num2str(0:22.5:180);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'size'
		string = num2str([0 0.1 0.2 0.35 0.5 0.75 1 2 4 6 8]);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'contrast'
		string = num2str(0:0.1:1);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'sf'
		string = num2str([0 0.1 0.5 0.7 1 1.5 2 3 4 5 6]);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'tf'
		string = num2str([0.5 1 2 3 4 5]);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);
	case 'xPosition'
		string = num2str(-1:0.2:1);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);	
	case 'yPosition'
		string = num2str(-1:0.2:1);
		string = regexprep(string,'\s+',' '); %collapse spaces
		set(handles.OKVariableValues,'String',string);	
end

function OKToolbarToggleGlobal_OnCallback(hObject, eventdata, handles)
set(handles.OKPanelProtocols,'Visible','off')
set(handles.OKPanelGlobal,'Visible','on')


function OKToolbarToggleGlobal_OffCallback(hObject, eventdata, handles) %#ok<*INUSL>
set(handles.OKPanelProtocols,'Visible','on')
set(handles.OKPanelGlobal,'Visible','off')


% --- Executes on button press in OKVariablesLinear.
function OKVariablesLinear_Callback(hObject, eventdata, handles)
values = str2num(get(handles.OKVariableValues,'String'));
string = num2str(values);
string = regexprep(string,'\s+',' '); %collapse spaces
set(handles.OKVariableValues,'String',string);

% --- Executes on button press in OKVariablesLog.
function OKVariablesLog_Callback(hObject, eventdata, handles) %#ok<*INUSD>


% --------------------------------------------------------------------
function OKToolbarInitialise_ClickedCallback(hObject, eventdata, handles) %#ok<*DEFNU>
% hObject    handle to OKToolbarInitialise (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r=[];
	set(handles.OKPanelDots,'Visible','off')
	set(handles.OKPanelSpot,'Visible','off')
	set(handles.OKPanelBar,'Visible','off')
	%set(handles.OKPanelPlaid,'Visible','off')
	set(handles.OKPanelGrating,'Visible','on')
	o.store.visibleStimulus='grating';
	o.store.gratingN = 0;
	o.store.barN = 0;
	o.store.dotsN = 0;
	o.store.spotN = 0;
	o.store.plaidN = 0;
	o.store.noiseN = 0;
	o.clearStimulusList;
	o.clearVariableList;
	o.getScreenVals;
	o.getTaskVals;
end

% --- Executes on selection change in OKStimList.
function OKStimList_Callback(hObject, eventdata, handles)

% --- Executes on button press in OKAddStimulus.
function OKAddStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to OKAddStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.updatesList; %initialise it.
	switch o.store.visibleStimulus
		case 'grating'
			o.addGrating;
		case 'bar'
			o.addBar;
		case 'dots'
			o.addDots;
		case 'spot'
			o.addSpot;
		case 'texture'
			o.addTexture;
	end
	if ~isempty(o.r.stimulus)
		set(handles.OKDeleteStimulus,'Enable','on');
		set(handles.OKModifyStimulus,'Enable','on');
		set(handles.OKStimulusUp,'Enable','on');
		set(handles.OKStimulusDown,'Enable','on');
	end
		
end

% --- Executes on button press in OKDeleteStimulus.
function OKDeleteStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to OKDeleteStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.deleteStimulus;
	if isempty(o.r.stimulus)
		set(handles.OKDeleteStimulus,'Enable','off');
		set(handles.OKModifyStimulus,'Enable','off');
		set(handles.OKStimulusUp,'Enable','off');
		set(handles.OKStimulusDown,'Enable','off');
	end
end

% --- Executes on button press in OKCopyStimulus.
function OKCopyStimulus_Callback(hObject, eventdata, handles)
% hObject    handle to OKCopyStimulus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.copyStimulus;
end

% --- Executes on button press in OKEditStimulus.
function OKEditStimulus_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.editStimulus;
end

% --- Executes on button press in OKStimulusDown.
function OKStimulusDown_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	value = get(handles.OKStimList,'Value'); %where are we in the stimulus list
	slength = length(o.r.stimulus);
	if value < slength
		idx = 1:slength;
		idx2 = idx;
		idx2(value) = idx2(value)+1;
		idx2(value+1) = idx2(value+1)-1;
		o.r.stimulus(idx) = o.r.stimulus(idx2);
		set(handles.OKStimList,'Value',value+1);
		o.r.updatesList;
		o.modifyStimulus;
	end
end

% --- Executes on button press in OKStimulusUp.
function OKStimulusUp_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	value = get(handles.OKStimList,'Value'); %where are we in the stimulus list
	slength = length(o.r.stimulus);
	if value > 1
		idx = 1:slength;
		idx2 = idx;
		idx2(value) = idx2(value)-1;
		idx2(value-1) = idx2(value-1)+1;
		o.r.stimulus(idx) = o.r.stimulus(idx2);
		set(handles.OKStimList,'Value',value-1);
		o.r.updatesList;
		o.modifyStimulus;
	end
end


% --- Executes on button press in OKInspectStimulus.
function OKInspectStimulus_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	v = get(handles.OKStimList,'Value');
	if v > 0;
		uiinspect(o.r.stimulus{v});
	end
end

% --- Executes on button press in OKInspectVariable.
function OKInspectVariable_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	v = get(handles.OKVarList,'Value');
	if v > 0;
		uiinspect(o.r.task.nVar(v));
	end
end


% --- Executes on button press in OKModifyStimulus.
function OKModifyStimulus_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	v = get(handles.OKStimList,'Value');
	if v > 0;
		seditor(o.r.stimulus{v});
	end
	
end

% --- Executes on button press in OKAddVariable.
function OKAddVariable_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.addVariable;
	if o.r.task.nVars > 0
		set(handles.OKDeleteVariable,'Enable','on');
		set(handles.OKCopyVariable,'Enable','on');
		set(handles.OKEditVariable,'Enable','on');
	end
end

% --- Executes on button press in OKDeleteVariable.
function OKDeleteVariable_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.deleteVariable;
	if o.r.task.nVars < 1
		set(handles.OKDeleteVariable,'Enable','off');
		set(handles.OKCopyVariable,'Enable','off');
		set(handles.OKEditVariable,'Enable','off');
	end
end

function OKCopyVariable_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.copyVariable;
end

function OKEditVariable_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.editVariable;
end

function OKVariableOffset_Callback(hObject, eventdata, handles)
% hObject    handle to OKVariableOffset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKVariableOffset as text
%        str2double(get(hObject,'String')) returns contents of OKVariableOffset
%        as a double

% --------------------------------------------------------------------
function OKToolbarRun_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OKToolbarRun (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if ~isempty(o.oc) && o.oc.isOpen == 1 && o.r.useLabJack == 1
		o.oc.write('--GO!--');
		pause(0.5);
	end
	drawnow;
	o.r.uiCommand='run';
	o.r.run;
end

% --------------------------------------------------------------------
function OKToolbarStop_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OKToolbarStop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.uiCommand='stop';
	drawnow;
end

% --------------------------------------------------------------------
function OKToolbarAbort_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OKToolbarAbort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.uiCommand='abort';
	if isa(o.oc,'dataConnection')
		o.oc.write('--abort--');
	end
	drawnow;
end

function OKRemoteIP_Callback(hObject, eventdata, handles)
% hObject    handle to OKRemoteIP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKRemoteIP as text
%        str2double(get(hObject,'String')) returns contents of OKRemoteIP as a double
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end


function OKRemotePort_Callback(hObject, eventdata, handles)
% hObject    handle to OKRemotePort (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKRemotePort as text
%        str2double(get(hObject,'String')) returns contents of OKRemotePort as a double
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.getTaskVals;
end

function OKPanelBarscale_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelBarscale (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKPanelBarscale as text
%        str2double(get(hObject,'String')) returns contents of OKPanelBarscale as a double


% --- Executes on selection change in OKPanelBarinterpMethod.
function OKPanelBarinterpMethod_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelBarinterpMethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns OKPanelBarinterpMethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from OKPanelBarinterpMethod


% --------------------------------------------------------------------
function OKRFMapper_ClickedCallback(hObject, eventdata, handles)
% hObject    handle to OKRFMapper (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.store.rfLog = [];
	rf=rfMapper;
	rf.run(o.r);
	o.store.rfLog = rf;
	clear rf;
end


% --------------------------------------------------------------------
function OKToolbarToggleRemote_OnCallback(hObject, eventdata, handles)
% hObject    handle to OKToolbarToggleRemote (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	eval(o.store.serverCommand)
end


% --------------------------------------------------------------------
function OKMenumanageCode_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenumanageCode (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
manageCode


% --- Executes on button press in OKPanelGratingcolourDialog.
function OKPanelGratingcolourDialog_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelGratingcolourDialog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cc = str2num(get(handles.OKPanelGratingcolour,'String'));
cc = uisetcolor(cc(1:3));
cc = num2str(cc);
cc = regexprep(cc,'\s+',' '); %collapse spaces
set(handles.OKPanelGratingcolour,'String',cc);


% --------------------------------------------------------------------
function OKMenurfMapperLog_Callback(hObject, eventdata, handles)
% hObject    handle to OKMenurfMapperLog (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in OKPanelSpotflashOn.
function OKPanelSpotflashOn_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelSpotflashOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function OKSettingsmovieSize_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.movieSettings.size=str2num(get(hObject,'String'));
end

function OKSettingsmovieFrames_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.movieSettings.nFrames=str2num(get(hObject,'String')); %#ok<*ST2NM>
end

function OKSettingsmoviePrecision_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.movieSettings.quality=get(hObject,'Value');
end

function OKSettingsmovieType_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.movieSettings.type=get(hObject,'Value');
end

function OKSettingsmovieCodec_Callback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	o.r.movieSettings.codec=get(hObject,'String');
end

% --------------------------------------------------------------------
function OKPanelTellOmniplex_ClickedCallback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	resp = questdlg('Is opxOnline running on the Omniplex machine?','Check OPX','No');
	if strcmpi(resp,'Yes')
		o.connectToOmniplex
	end
end


% --------------------------------------------------------------------
function OKPanelReconnectOmniplex_ClickedCallback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if isa(o.oc,'dataConnection')
		o.oc.closeAll;
		o.connectToOmniplex;
	end
end

% --------------------------------------------------------------------
function OKPanelSendOmniplex_ClickedCallback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if isa(o.oc,'dataConnection')
		o.sendOmniplexStimulus;
	end
end

% --------------------------------------------------------------------
function OKPanelDisconnectOmniplex_ClickedCallback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	if isa(o.oc,'dataConnection')
		o.disconnectOmniplex;
	end
end

% --------------------------------------------------------------------
function OKPanelPingOmniplex_ClickedCallback(hObject, eventdata, handles)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	rAddress = get(handles.OKOmniplexIP,'String');
	status = o.ping(rAddress);
	if status > 0
		set(o.h.OKOmniplexStatus,'String','Omniplex: machine ping ERROR!')
	else
		if isa(o.oc,'dataConnection') && o.oc.isOpen == 1
			o.oc.write('--ping--');
			loop = 1;
			while loop < 8
				in = o.oc.read(0);
				fprintf('\n{opticka said: %s}\n',in)
				if regexpi(in,'ping')
					fprintf('\nWe can ping omniplex master on try: %d\n',loop)
					set(handles.OKOmniplexStatus,'String','Omniplex: connected and pinged')
					break
				else
					fprintf('\nOmniplex master not responding, try: %d\n',loop)
					set(handles.OKOmniplexStatus,'String','Omniplex: not responding')
				end
				loop=loop+1;
				pause(0.1);
			end
		end
	end
end

function OKPanelGratingphaseReverseTime_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelGratingphaseReverseTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKPanelGratingphaseReverseTime as text
%        str2double(get(hObject,'String')) returns contents of OKPanelGratingphaseReverseTime as a double

function OKPanelGratingphaseOfReverse_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelGratingphaseOfReverse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OKPanelGratingphaseOfReverse as text
%        str2double(get(hObject,'String')) returns contents of OKPanelGratingphaseOfReverse as a double


% --- Executes on button press in OKPanelTextureGetFile.
function OKPanelTextureGetFile_Callback(hObject, eventdata, handles)
% hObject    handle to OKPanelTextureGetFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isappdata(handles.output,'o')
	o = getappdata(handles.output,'o');
	[filename, pathname] = uigetfile('*.jpg', 'Select a MATLAB code file');
	if isequal(filename,0)
	   disp('User selected Cancel')
	else
	   disp(['User selected', fullfile(pathname, filename)])
	   set(handles.OKPanelTexturefileName, 'String', fullfile(pathname, filename));
	end
end
