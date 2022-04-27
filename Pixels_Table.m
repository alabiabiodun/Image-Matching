function varargout = Pixels_Table(varargin)
% PIXELS_TABLE MATLAB code for Pixels_Table.fig
%      PIXELS_TABLE, by itself, creates a new PIXELS_TABLE or raises the existing
%      singleton*.
%
%      H = PIXELS_TABLE returns the handle to a new PIXELS_TABLE or the handle to
%      the existing singleton*.
%
%      PIXELS_TABLE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PIXELS_TABLE.M with the given input arguments.
%
%      PIXELS_TABLE('Property','Value',...) creates a new PIXELS_TABLE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Pixels_Table_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Pixels_Table_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Pixels_Table

% Last Modified by GUIDE v2.5 27-Feb-2021 15:22:52

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Pixels_Table_OpeningFcn, ...
                   'gui_OutputFcn',  @Pixels_Table_OutputFcn, ...
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


% --- Executes just before Pixels_Table is made visible.
function Pixels_Table_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Pixels_Table (see VARARGIN)

% Choose default command line output for Pixels_Table

handles.output = hObject;
rows = 200; columns = 5;
data = cell(rows,columns);
data(:,:) = {''};
set(handles.uitable1,'data',data);

% Update handles structure
guidata(hObject, handles);
clc 
clear
movegui('center');
% Update handles structure
%guidata(hObject, handles);

% UIWAIT makes Pixels_Table wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Pixels_Table_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function pixels_coordinates_Callback(hObject, eventdata, handles)
% hObject    handle to pixels_coordinates (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matchedimg1 = evalin('base', 'matchedimg1');
matchedimg2 = evalin('base', 'matchedimg2');
% matchedimg1 = getappdata(0,'matchedimg1');
% matchedimg2 = getappdata(0,'matchedimg2');

gte = vision.GeometricTransformEstimator;
gte.Transform = 'Projective';
[tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);

data1 = matchedimg1(inlierIdx).Location;
data2 = matchedimg2(inlierIdx).Location;

% scale1 = matchedimg1(inlierIdx).Scale;
% scale2 = matchedimg2(inlierIdx).Scale;


[nn] = size(data1);
id = [1:nn(1)]';

data = [num2cell(id), num2cell(data1), num2cell(data2)];
[n,m] = size(data);

for i = 1:n
    for j = 1:m
        %if j > 1
            data{i,j} = sprintf('%0.0f',data{i,j});
        %elseif j == 1
            %data{i,j} = sprintf('%0.0f',data{i,j});
        %end
    end
end

setappdata(0,'hh',data)

%f = figure('Position',[100 100 700 500]);
set(handles.uitable1,'data',data);
set(handles.uitable1,'ColumnName',{'ID','Xl','Yl','Xr','Yr'});
set(handles.uitable1,'FontName','Times New Roman');
set(handles.uitable1,'FontSize',11);
jscrollpane = findjobj(handles.uitable1);
jTable = jscrollpane.getViewport.getView;
cellStyle = jTable.getCellStyleAt(0,0);
cellStyle.setHorizontalAlignment(cellStyle.CENTER);
jTable.repaint;
