function varargout = CaGUI2(varargin)
% CAGUI2 MATLAB code for CaGUI2.fig
%      CAGUI2, by itself, creates a new CAGUI2 or raises the existing
%      singleton*.
%
%      H = CAGUI2 returns the handle to a new CAGUI2 or the handle to
%      the existing singleton*.
%
%      CAGUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAGUI2.M with the given input arguments.
%
%      CAGUI2('Property','Value',...) creates a new CAGUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CaGUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CaGUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CaGUI2

% Last Modified by GUIDE v2.5 17-Mar-2019 10:35:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CaGUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @CaGUI2_OutputFcn, ...
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


% --- Executes just before CaGUI2 is made visible.
function CaGUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CaGUI2 (see VARARGIN)

handles = setfield(handles, 'iXSize', 51);
handles = setfield(handles, 'iYSize', 51);
handles = setfield(handles, 'dSigma', 8.0);
handles = setfield(handles, 'dThresh', 0.25);
handles = setfield(handles, 'iSmall', 4);
handles = setfield(handles, 'iBig', 8);
handles = setfield(handles, 'bRunAuto', false);
handles = setfield(handles, 'bPickGreen', true);
handles = setfield(handles, 'bBackRing', true);
handles = setfield(handles, 'bManualOffset', false);
handles = setfield(handles, 'iBackX', 10);
handles = setfield(handles, 'iBackY', 10);
handles = setfield(handles, 'iROIPixels',5);
handles = setfield(handles, 'bImages', false);
handles = setfield(handles, 'bZoom', false);
handles = setfield(handles, 'bTrack', true);
handles = setfield(handles, 'bMaxFluor', true);
handles = setfield(handles, 'bTotalFluor', true);



% Choose default command line output for CaGUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CaGUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);



% --- Outputs from this function are returned to the command line.
function varargout = CaGUI2_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in browse.
function browse_Callback(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

bImages = handles.bImages;

if bImages == 1
    
    sDirName = uigetdir('C:\Users\lucyc\Dropbox (GaTech)\Hang-lab\data\2019_06_14_AQ3236\');
    vFiles = dir(sprintf('%s/*.png', sDirName)); 
    iNumFiles = length(vFiles);
    iFile = 1;

    set(handles.text2, 'string', sDirName);
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
        , iFile, iNumFiles));

    rgImage = imread(sprintf('%s/frame%i.png',sDirName,iFile));
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    objReader = [];
    sVidName = [];
    
else
    
    [sVidName, sDirName] = uigetfile('*.avi');
    objReader = VideoReader([sDirName sVidName]);
    iNumFiles = objReader.NumberOfFrames;
    iFile = 1;
    
    set(handles.text2, 'string', [sDirName sVidName]);
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
        , iFile, iNumFiles))
    
    rgImage = read(objReader,iFile);
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    vFiles = [];
    
end

set(handles.frame_slider, 'Value', iFile);
set(handles.frame_slider, 'Min', 1);
set(handles.frame_slider, 'Max', iNumFiles);

axes(handles.axes2)
imagesc(rgImage)
title(sprintf('Original (Image %i out of %i)',iFile,iNumFiles))
axis image

%Set up output struct
vGreenROI_Mean = NaN(1,iNumFiles);
vGreenBack_Mean = NaN(1,iNumFiles);
vGreenROI_Max = NaN(1,iNumFiles);
vGreenBack_Max = NaN(1,iNumFiles);
vRedROI_Mean = NaN(1,iNumFiles);
vRedBack_Mean = NaN(1,iNumFiles);
vRedROI_Max = NaN(1,iNumFiles);
vRedBack_Max = NaN(1,iNumFiles);
vRatio_Mean = NaN(1,iNumFiles);
vRatio_Max = NaN(1,iNumFiles);
vFound = NaN(1,iNumFiles);
vAllPoints = NaN(2,iNumFiles);

vGreenROI_Mean2 = NaN(1,iNumFiles);
vGreenBack_Mean2 = NaN(1,iNumFiles);
vGreenROI_Max2 = NaN(1,iNumFiles);
vGreenBack_Max2 = NaN(1,iNumFiles);
vRedROI_Mean2 = NaN(1,iNumFiles);
vRedBack_Mean2 = NaN(1,iNumFiles);
vRedROI_Max2 = NaN(1,iNumFiles);
vRedBack_Max2 = NaN(1,iNumFiles);
vRatio_Mean2 = NaN(1,iNumFiles);
vRatio_Max2 = NaN(1,iNumFiles);
vAllPoints_auto = NaN(2,iNumFiles);

handles = setfield(handles, 'sDirName', sDirName);
handles = setfield(handles, 'vFiles', vFiles);
handles = setfield(handles, 'iNumFiles', iNumFiles);
handles = setfield(handles, 'iFile', iFile);
handles = setfield(handles, 'vPoint', []);
handles = setfield(handles, 'vAllPoints', vAllPoints);
handles = setfield(handles, 'vGreenROI_Mean', vGreenROI_Mean);
handles = setfield(handles, 'vGreenBack_Mean', vGreenBack_Mean);
handles = setfield(handles, 'vGreenROI_Max', vGreenROI_Max);
handles = setfield(handles, 'vGreenBack_Max', vGreenBack_Max);
handles = setfield(handles, 'vRedROI_Mean', vRedROI_Mean);
handles = setfield(handles, 'vRedBack_Mean', vRedBack_Mean);
handles = setfield(handles, 'vRedROI_Max', vRedROI_Max);
handles = setfield(handles, 'vRedBack_Max', vRedBack_Max);
handles = setfield(handles, 'vRatio_Mean', vRatio_Mean);
handles = setfield(handles, 'vRatio_Max', vRatio_Max);
handles = setfield(handles, 'vFound', vFound);
handles = setfield(handles, 'rgImage', rgImage);
handles = setfield(handles, 'objReader', objReader);
handles = setfield(handles, 'sVidName', sVidName);

handles = setfield(handles, 'vAllPoints_auto', vAllPoints_auto);
handles = setfield(handles, 'vGreenROI_Mean2', vGreenROI_Mean2);
handles = setfield(handles, 'vGreenBack_Mean2', vGreenBack_Mean2);
handles = setfield(handles, 'vGreenROI_Max2', vGreenROI_Max2);
handles = setfield(handles, 'vGreenBack_Max2', vGreenBack_Max2);
handles = setfield(handles, 'vRedROI_Mean2', vRedROI_Mean2);
handles = setfield(handles, 'vRedBack_Mean2', vRedBack_Mean2);
handles = setfield(handles, 'vRedROI_Max2', vRedROI_Max2);
handles = setfield(handles, 'vRedBack_Max2', vRedBack_Max2);
handles = setfield(handles, 'vRatio_Mean2', vRatio_Mean2);
handles = setfield(handles, 'vRatio_Max2', vRatio_Max2);
handles = setfield(handles, 'vPoint_auto', []);


guidata(hObject, handles);



% --- Executes during object creation, after setting all properties.
function text2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called



function iYSize_button_Callback(hObject, eventdata, handles)
% hObject    handle to iYSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iYSize_button as text
%        str2double(get(hObject,'String')) returns contents of iYSize_button as a double

handles.iYSize = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function iYSize_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iYSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.iYSize = str2num(get(hObject,'String'));

guidata(hObject,handles);

function iXSize_button_Callback(hObject, eventdata, handles)
% hObject    handle to iXSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iXSize_button as text
%        str2double(get(hObject,'String')) returns contents of iXSize_button as a double

handles.iXSize = str2num(get(hObject,'String'));

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function iXSize_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iXSize_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.iXSize = str2num(get(hObject,'String'));

guidata(hObject,handles);

function dSigma_button_Callback(hObject, eventdata, handles)
% hObject    handle to dSigma_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dSigma_button as text
%        str2double(get(hObject,'String')) returns contents of dSigma_button as a double

handles.dSigma = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function dSigma_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dSigma_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.dSigma = str2num(get(hObject,'String'));

guidata(hObject,handles);

function dThresh_button_Callback(hObject, eventdata, handles)
% hObject    handle to dThresh_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of dThresh_button as text
%        str2double(get(hObject,'String')) returns contents of dThresh_button as a double

handles.dThresh = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function dThresh_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to dThresh_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.dThresh = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function axes2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes2


% --- Executes on button press in analyze_image.
function analyze_image_Callback(hObject, eventdata, handles)
% hObject    handle to analyze_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)




if isempty(handles.vPoint)
    

    
%     % Find brightest image
%     axes(handles.axes2)
%     title('Finding Brightest Frame')
%     pause(.1)
%     [rgImage, iBestFrame, dMax] = findBrightestImage(handles);
%     handles.dMax = dMax;
    
    % Zoom
    if handles.bZoom
        axes(handles.axes2)
        imagesc(handles.rgImage)
        axis image
        title('Select Zoom Region')
        [rgImage, vRect] = imcrop;
        handles.vZoomRect = vRect;
    else
        handles.vZoomRect = [0 0 size(handles.rgImage,2) size(handles.rgImage,1)];
    end
    
    %Show Image
    axes(handles.axes2)
    imagesc(imcrop(handles.rgImage,handles.vZoomRect))
    axis image
    title('Click on Neuron')
    [iX, iY] = getpts;
    handles.vPoint = [iX, iY];
    handles.vPoint_auto = [iX, iY];
    
    % Manual Offset
    if handles.bManualOffset
        axes(handles.axes2)
        imagesc(rgImage)
        axis image
        title('Click on Comparison Region')
        [iX2, iY2] = getpts;
        iXOffset = iX2-iX;
        iYOffset = iY2 - iY;
        handles.iBackX = iXOffset;
        handles.iBackY = iYOffset;
        handles.vBackPoint = [iX2, iY2];
        
        set(handles.iBackX_button,'String',sprintf('%i',iXOffset))
        set(handles.iBackY_button,'String',sprintf('%i',iYOffset))
    end
    
    % title(sprintf('Brightest Frame (Image %i out of %i)',iBestFrame,handles.iNumFiles))

else

% Get vPoint

    %Show Image
    axes(handles.axes2)
    imagesc(imcrop(handles.rgImage,handles.vZoomRect))
    axis image
    title('Click on Neuron')
    [iX, iY] = getpts;
    handles.vPoint = [iX, iY];
    handles.vPoint_auto = [iX, iY];
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))


end
% Run Analysis Code
handles = findNeuron4(handles);

guidata(hObject,handles);


% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

for i = 1:handles.iNumFiles
    
    handles.iFile = i;
    handles = findNeuron4(handles);
    
end

guidata(hObject, handles);


% --- Executes on button press in load_next. 
% "Next Button"
function load_next_Callback(hObject, eventdata, handles)
% hObject    handle to load_next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Load Next Image
if handles.iFile < handles.iNumFiles
    handles.iFile = handles.iFile + 1;
    set(handles.frame_number, 'String', sprintf('%i',handles.iFile));
    set(handles.frame_slider, 'Value', handles.iFile);
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
        , handles.iFile, handles.iNumFiles));

    if handles.bImages
        rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    else
        rgImage = read(handles.objReader, handles.iFile);
    end
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    if exist('handles.vZoomRect')
        imagesc(imcrop(rgImage,handles.vZoomRect))
    else
        imagesc(rgImage)
    end
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    axes(handles.axes5)
    vPlot = handles.vRatio_Mean/handles.vRatio_Mean(1);
    vX_axis = [1:length(handles.vRatio_Mean)];
    plot(vX_axis,vPlot);
    hold on
    scatter(vX_axis(handles.iFile),vPlot(handles.iFile),100,[0 0 1],'LineWidth',2)
    hold off
    xlabel('Frame')
    ylabel('F/Fo')
    title('vRatio_Mean')
    
else
    fprintf('Already looking at last image \n');
end

guidata(hObject, handles)

% --- Executes on button press in load_previous. 
% "Previous Button"
function load_previous_Callback(hObject, eventdata, handles)
% hObject    handle to load_previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if handles.iFile >1
    handles.iFile = handles.iFile - 1;
    set(handles.frame_number, 'String', sprintf('%i',handles.iFile));
    set(handles.frame_slider, 'Value', handles.iFile);
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
        , handles.iFile, handles.iNumFiles));
    
    if handles.bImages
        rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    else
        rgImage = read(handles.objReader,handles.iFile);
    end
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    if exist('handles.vZoomRect')
        imagesc(imcrop(rgImage,handles.vZoomRect))
    else
        imagesc(rgImage)
    end
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    axes(handles.axes5)
    vPlot = handles.vRatio_Mean/handles.vRatio_Mean(1);
    vX_axis = [1:length(handles.vRatio_Mean)];
    plot(vX_axis,vPlot);
    hold on
    scatter(vX_axis(handles.iFile),vPlot(handles.iFile),100,[0 0 1],'LineWidth',2)
    hold off
    xlabel('Frame')
    ylabel('F/Fo')
    title('vRatio_Mean')
    
    
else
    fprintf('Already at first frame \n');
end

guidata(hObject, handles)


% --- Executes during object creation, after setting all properties.
function axes3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes3


% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes on button press in save_data.
function save_data_Callback(hObject, eventdata, handles)
% hObject    handle to save_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

sDirName = handles.sDirName;
sDescriptor = handles.sDescriptor;
bImages = handles.bImages;    
bSlash = sDirName=='\';
iIndex = find(bSlash,1,'last');
if bImages
    sVidName = sDirName(iIndex+1:end);
    sDirName = sDirName(1:iIndex);
else
    sVidName = handles.sVidName(1:end-4);
    sDirName = sDirName(1:iIndex);
end
% vDashIndex = find(sDirName == '\');
% sDirShort = sDirName(vDashIndex(end) + 1: end);
% sDirShort(sDirShort == ' ') = '_';

vGreenROI_Mean = handles.vGreenROI_Mean;
vGreenBack_Mean = handles.vGreenBack_Mean;
vGreenROI_Max = handles.vGreenROI_Max;
vGreenBack_Max = handles.vGreenBack_Max;
vRedROI_Mean = handles.vRedROI_Mean;
vRedBack_Mean = handles.vRedBack_Mean;
vRedROI_Max = handles.vRedROI_Max;
vRedBack_Max = handles.vRedBack_Max;
vRatio_Mean = handles.vRatio_Mean;
vRatio_Max = handles.vRatio_Max;
vFound = handles.vFound;
dSigma = handles.dSigma;
iSmall = handles.iSmall;
iBig = handles.iBig;
bBackRing = handles.bBackRing;
vAllPoints = handles.vAllPoints;
iBackX = handles.iBackX;
iBackY = handles.iBackY;
vZoomRect = handles.vZoomRect;

vGreenROI_Mean2 = handles.vGreenROI_Mean2;
vGreenBack_Mean2 = handles.vGreenBack_Mean2;
vGreenROI_Max2 = handles.vGreenROI_Max2;
vGreenBack_Max2 = handles.vGreenBack_Max2;
vRedROI_Mean2 = handles.vRedROI_Mean2;
vRedBack_Mean2 = handles.vRedBack_Mean2;
vRedROI_Max2 = handles.vRedROI_Max2;
vRedBack_Max2 = handles.vRedBack_Max2;
vRatio_Mean2 = handles.vRatio_Mean2;
vRatio_Max2 = handles.vRatio_Max2;

if ~(exist([sDirName 'data\']))
    mkdir([sDirName 'data\'])
end


save([sDirName 'data\' sVidName sDescriptor '_data'], 'vGreenROI_Mean', ...
    'vGreenBack_Mean', 'vGreenROI_Max', 'vGreenBack_Max','vRedROI_Mean',...
    'vRedBack_Mean', 'vRedROI_Max', 'vRedBack_Max', 'vRatio_Mean', ...
    'vRatio_Max', 'vFound','dSigma','iSmall','iBig','bBackRing',...
    'vAllPoints','iBackX','iBackY','vZoomRect', 'vGreenROI_Mean2', ...
    'vGreenBack_Mean2', 'vGreenROI_Max2', 'vGreenBack_Max2','vRedROI_Mean2',...
    'vRedBack_Mean2', 'vRedROI_Max2', 'vRedBack_Max2');

CaData_Plots(sDirName,sVidName, sDescriptor);


guidata(hObject,handles);


% --- Executes when selected object is changed in uipanel2.
function uipanel2_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uipanel2 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

handles.sAutoMode = get(eventdata.NewValue,'Tag');
guidata(hObject,handles);


% --- Executes on button press in pushbutton11.
function pushbutton11_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iFile = handles.iFile;

for i = iFile:handles.iNumFiles
    
    % Load Image
    handles.iFile = i;
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
    , handles.iFile, handles.iNumFiles));

    rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    imagesc(rgImag)
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    % Run Analysis Code
    handles = findNeuron(handles);
    
    
end

guidata(hObject, handles);



function edit7_Callback(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit7 as text
%        str2double(get(hObject,'String')) returns contents of edit7 as a double


% --- Executes during object creation, after setting all properties.
function edit7_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function uipanel2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to uipanel2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function Manual_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Manual (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in run_auto.
function run_auto_Callback(hObject, eventdata, handles)
% hObject    handle to run_auto (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of run_auto

bRunAuto = get(hObject,'Value');

if bRunAuto
    
% Get vPoint
if isempty(handles.vPoint)
    
%     % Find brightest image
%     [rgImage, iBestFrame, dMax] = findBrightestImage(handles);
%     handles.dMax = dMax;
%     
    % Zoom
    if handles.bZoom
        axes(handles.axes2)
        imagesc(rgImage)
        axis image
        [rgImage, vRect] = imcrop;
        handles.vZoomRect = vRect;
    end
    
    %Show Image
    axes(handles.axes2)
    imagesc(rgImage)
    axis image
    title('Click on Neuron')
    [iX, iY] = getpts;
    handles.vPoint = [iX, iY];
    handles.vPoint_auto = [iX, iY];
    title(sprintf('Brightest Frame (Image %i out of %i)',iBestFrame,handles.iNumFiles))

end


iFile = handles.iFile;

while (iFile<=handles.iNumFiles && get(hObject,'Value'))
    
    % Load Image
    handles.iFile = iFile;
    set(handles.frame_number,'string',sprintf('%i',handles.iFile));
    set(handles.frame_slider,'value',handles.iFile);
    set(handles.edit7, 'string', sprintf('Analyzing Image %i out of %i '...
    , handles.iFile, handles.iNumFiles));

    if handles.bImages
        rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    else
        rgImage = read(handles.objReader, handles.iFile);
    end
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    imagesc(imcrop(rgImage, handles.vZoomRect))
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    % Run Analysis Code
    handles = findNeuron4(handles);

    % Next Image
    iFile = iFile + 1;
    
    guidata(hObject, handles);
    
    pause(.08);

end
end

guidata(hObject, handles);
guidata(handles.output, handles);



function iSmall_button_Callback(hObject, eventdata, handles)
% hObject    handle to iSmall_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iSmall_button as text
%        str2double(get(hObject,'String')) returns contents of iSmall_button as a double

handles.iSmall = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function iSmall_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iSmall_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
handles.iSmall = str2num(get(hObject,'String'));

guidata(hObject,handles);



function iBig_button_Callback(hObject, eventdata, handles)
% hObject    handle to iBig_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iBig_button as text
%        str2double(get(hObject,'String')) returns contents of iBig_button as a double

handles.iBig = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function iBig_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iBig_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

handles.iBig = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes on selection change in popupmenu1.
function popupmenu1_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu1 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu1


iValue = get(hObject,'Value');

if iValue==1
    bPickGreen = true;
else
    bPickGreen = false;
end

handles.bPickGreen = bPickGreen;

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function popupmenu1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in back_method.
function back_method_Callback(hObject, eventdata, handles) 
% hObject    handle to back_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns back_method contents as cell array
%        contents{get(hObject,'Value')} returns selected item from back_method

iValue = get(hObject,'Value');
contents = cellstr(get(hObject,'String'));
strValue = contents{get(hObject,'Value')};

 bManualOffset = false;
if strcmp(strValue,'Ring')
    bBackRing = true;
else
    bBackRing = false;
    if strcmp(strValue,'Offset (Manual)')
        bManualOffset = true;
    end
end



handles.bBackRing = bBackRing;
handles.bManualOffset = bManualOffset;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function back_method_CreateFcn(hObject, eventdata, handles)
% hObject    handle to back_method (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iBackX_button_Callback(hObject, eventdata, handles)
% hObject    handle to iBackX_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iBackX_button as text
%        str2double(get(hObject,'String')) returns contents of iBackX_button as a double

handles.iBackX = str2num(get(hObject,'String'));

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function iBackX_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iBackX_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function iBackY_button_Callback(hObject, eventdata, handles)
% hObject    handle to iBackY_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of iBackY_button as text
%        str2double(get(hObject,'String')) returns contents of iBackY_button as a double


handles.iBackY = str2num(get(hObject,'String'));

guidata(hObject,handles);

% --- Executes during object creation, after setting all properties.
function iBackY_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to iBackY_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in clear_data.
function clear_data_Callback(hObject, eventdata, handles)
% hObject    handle to clear_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

iFrame = handles.iFile;

handles.vGreenROI_Mean(iFrame) = NaN;
handles.vGreenBack_Mean(iFrame) = NaN;
handles.vGreenROI_Max(iFrame) = NaN;
handles.vGreenBack_Max(iFrame) = NaN;
handles.vRedROI_Mean(iFrame) = NaN;
handles.vRedBack_Mean(iFrame) = NaN;
handles.vRedROI_Max(iFrame) = NaN;
handles.vRedBack_Max(iFrame) = NaN;
handles.vRatio_Mean(iFrame) = NaN;
handles.vRatio_Max(iFrame) = NaN;
handles.vFound(iFrame) = false;

handles.vGreenROI_Mean2(iFrame) = NaN;
handles.vGreenBack_Mean2(iFrame) = NaN;
handles.vGreenROI_Max2(iFrame) = NaN;
handles.vGreenBack_Max2(iFrame) = NaN;
handles.vRedROI_Mean2(iFrame) = NaN;
handles.vRedBack_Mean2(iFrame) = NaN;
handles.vRedROI_Max2(iFrame) = NaN;
handles.vRedBack_Max2(iFrame) = NaN;
               
handles.vRatio_Mean2(iFrame) = NaN;
handles.vRatio_Max2(iFrame) = NaN;

guidata(hObject,handles);


function edit12_Callback(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit12 as text
%        str2double(get(hObject,'String')) returns contents of edit12 as a double

handles.iROIPixels = str2double(get(hObject,'String'));

guidata(hObject,handles);



% --- Executes during object creation, after setting all properties.
function edit12_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit12 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on selection change in popupmenu3.
function popupmenu3_Callback(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popupmenu3 contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popupmenu3

contents = cellstr(get(hObject,'String'));
sOption = contents{get(hObject,'Value')};

if strcmp(sOption, 'Images')
    handles.bImages = true;
else
    handles.bImages = false;
end

guidata(hObject,handles);




% --- Executes during object creation, after setting all properties.
function popupmenu3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popupmenu3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

contents = cellstr(get(hObject,'String'));
sOption = contents{get(hObject,'Value')};

if strcmp(sOption, 'Images')
    handles.bImages = true;
else
    handles.bImages = false;
end

guidata(hObject,handles);


function vid_descriptor_Callback(hObject, eventdata, handles)
% hObject    handle to vid_descriptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of vid_descriptor as text
%        str2double(get(hObject,'String')) returns contents of vid_descriptor as a double

sDescriptor = get(hObject,'String');
handles.sDescriptor = sDescriptor;

guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function vid_descriptor_CreateFcn(hObject, eventdata, handles)
% hObject    handle to vid_descriptor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

sDescriptor = get(hObject,'String');
handles.sDescriptor = sDescriptor;

guidata(hObject,handles);


% --- Executes on button press in zoom_option.
function zoom_option_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_option (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of zoom_option

bZoom = get(hObject,'Value');
handles.bZoom = bZoom;

guidata(hObject,handles);


% --- Executes on slider movement.
function frame_slider_Callback(hObject, eventdata, handles)
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider

iFile = round(get(hObject,'Value'));
if iFile < 1 || iFile > handles.iNumFiles
    fprintf('Slider Frame Value Out of Range \n');
else
    handles.iFile = iFile;
    set(handles.frame_number, 'String', sprintf('%i',iFile));
    set(handles.frame_slider, 'Value', handles.iFile);
    
    % Show worm image
    
    if handles.bImages
        rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    else
        rgImage = read(handles.objReader,handles.iFile);
    end
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    imagesc(imcrop(handles.rgImage,handles.vZoomRect))
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    axes(handles.axes5)
    vPlot = handles.vRatio_Mean/handles.vRatio_Mean(1);
    vX_axis = [1:length(handles.vRatio_Mean)];
    plot(vX_axis,vPlot);
    hold on
    scatter(vX_axis(handles.iFile),vPlot(handles.iFile),100,[0 0 1],'LineWidth',2)
    hold off
    xlabel('Frame')
    ylabel('F/Fo')
    title('vRatio_Mean')
    
end


guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function frame_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end



function frame_number_Callback(hObject, eventdata, handles)
% hObject    handle to frame_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of frame_number as text
%        str2double(get(hObject,'String')) returns contents of frame_number as a double


iFile = str2double(get(hObject,'String'));
if iFile < 1 || iFile > handles.iNumFiles
    fprintf('Slider Frame Value Out of Range \n');
else
    handles.iFile = iFile;
    set(handles.frame_number, 'String', sprintf('%i',iFile));
    set(handles.frame_slider, 'Value', handles.iFile);
    
    % Show worm image
    
    if handles.bImages
        rgImage = imread(sprintf('%s/frame%i.png',handles.sDirName,handles.iFile));
    else
        rgImage = read(handles.objReader,handles.iFile);
    end
    if size(rgImage,3)==3
        rgImage = rgb2gray(rgImage);
    end
    rgImage = double(rgImage);
    handles.rgImage = rgImage;

    axes(handles.axes2)
    imagesc(imcro(rgImage,handles.vZoomRect))
    title(sprintf('Original (Image %i out of %i)',handles.iFile,handles.iNumFiles))
    axis image
    
    axes(handles.axes5)
    vPlot = handles.vRatio_Mean/handles.vRatio_Mean(1);
    vX_axis = [1:length(handles.vRatio_Mean)];
    plot(vX_axis,vPlot);
    hold on
    scatter(vX_axis(handles.iFile),vPlot(handles.iFile),100,[0 0 1],'LineWidth',2)
    hold off
    xlabel('Frame')
    ylabel('F/Fo')
    title('vRatio_Mean')
    
end



guidata(hObject,handles);


% --- Executes during object creation, after setting all properties.
function frame_number_CreateFcn(hObject, eventdata, handles)
% hObject    handle to frame_number (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in live_tracking.
function live_tracking_Callback(hObject, eventdata, handles)
% hObject    handle to live_tracking (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of live_tracking

bTrack = get(hObject,'Value');
handles.bTrack = bTrack;

guidata(hObject,handles);


function text11_CreateFcn(hObject, eventdata, handles)
% hObject    handle to text11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function browse_CreateFcn(hObject, eventdata, handles)
% hObject    handle to browse (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on button press in max_fluor.
function max_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to max_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of max_fluor
bMaxFluor = get(hObject,'Value');
handles.bMaxFluor = bMaxFluor;

guidata(hObject,handles);

% --- Executes on key press with focus on max_fluor and none of its controls.
function max_fluor_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to max_fluor (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in total_fluor.
function total_fluor_Callback(hObject, eventdata, handles)
% hObject    handle to total_fluor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of total_fluor

bTotalFluor = get(hObject,'Value');
handles.bTotalFluor = bTotalFluor;

guidata(hObject,handles);
