function varargout = featureMatching(varargin)
% FEATUREMATCHING MATLAB code for featureMatching.fig
%      FEATUREMATCHING, by itself, creates a new FEATUREMATCHING or raises the existing
%      singleton*.
%
%      H = FEATUREMATCHING returns the handle to a new FEATUREMATCHING or the handle to
%      the existing singleton*.
%
%      FEATUREMATCHING('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FEATUREMATCHING.M with the given input arguments.
%
%      FEATUREMATCHING('Property','Value',...) creates a new FEATUREMATCHING or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before featureMatching_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to featureMatching_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help featureMatching

% Last Modified by GUIDE v2.5 14-Apr-2021 13:19:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @featureMatching_OpeningFcn, ...
                   'gui_OutputFcn',  @featureMatching_OutputFcn, ...
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


% --- Executes just before featureMatching is made visible.
function featureMatching_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to featureMatching (see VARARGIN)

% Choose default command line output for featureMatching

handles.output = hObject;
%clear, clc

% rows = 200; columns = 5;
% data = cell(rows,columns);
% data(:,:) = {''};
% set(handles.uitable1,'data',data);
% 
% % Update handles structure
% guidata(hObject, handles);
% clc 
% clear
% movegui('center');

% UIWAIT makes featureMatching wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = featureMatching_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
%varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
% function pushbutton1_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton1 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [a b] = uigetfile({'*.jpg;*.tiff;*.bmp;*.ecw','All Files'});
% if ischar(a) && ischar(b)
% img1 = imread([b a]);
% imshow(img1,'Parent',handles.axes1);
% 
% else
%     return
%     
% end
% 
% setappdata(0,'img1', img1);



% --- Executes on button press in pushbutton2.
% function pushbutton2_Callback(hObject, eventdata, handles)
% % hObject    handle to pushbutton2 (see GCBO)
% % eventdata  reserved - to be defined in a future version of MATLAB
% % handles    structure with handles and user data (see GUIDATA)
% [a b] = uigetfile({'*.jpg;*.tiff;*.bmp;*.ecw','All Files'});
% if ischar(a) && ischar(b)
% img2 = imread([b a]);
% imshow(img2,'Parent',handles.axes2);
% 
% else
%     return
%     
% end
% 
% setappdata(0,'img2', img2);


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
img1 = getappdata(0,'img1');
img1 = rgb2gray(img1);
corners1 = detectFASTFeatures(img1,'MinContrast',0.1);
J = insertMarker(img1,corners1,'circle');
imshow(J,'Parent',handles.axes1);


% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% surf = getappdata(0,'surf');
% fast = getappdata(0,'fast');
% brisk = getappdata(0,'brisk');
% harris = getappdata(0,'harris');

img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

ptsimg1 = getappdata(0,'ptsimg1');
ptsimg2 = getappdata(0,'ptsimg2');

[featuresimg1,validPtsimg1]  = extractFeatures(img1,ptsimg1);
[featuresimg2,validPtsimg2] = extractFeatures(img2,ptsimg2);

indexPairs = matchFeatures(featuresimg1,featuresimg2);

matchedimg1  = validPtsimg1(indexPairs(:,1));
matchedimg2 = validPtsimg2(indexPairs(:,2));

%figure; ax = axes;
set(handles.axes1, 'Visible', 'off')
set(handles.axes1, 'HandleVisibility', 'off')
set(handles.axes2, 'Visible', 'off')
set(handles.axes2, 'HandleVisibility', 'off')
set(handles.axes4, 'Visible', 'on')
set(handles.axes4, 'HandleVisibility', 'on')

children1 = get(handles.axes1, 'children');
delete(children1);

children2 = get(handles.axes2, 'children');
delete(children2);

showMatchedFeatures(img1,img2,matchedimg1,matchedimg2, 'montage','Parent',handles.axes4)
title(handles.axes4, 'Candidate matched points (including outliers)')
legend(handles.axes4, 'Matched points 1','Matched points 2');

impixelinfo;
% set(hp,'Position',[5 1 300 20]);

setappdata(0,'matchedimg1', matchedimg1);
setappdata(0,'matchedimg2', matchedimg2);
setappdata(0,'featuresimg1',featuresimg1);
setappdata(0,'featuresimg2',featuresimg2);

match = matchedimg1.Count;
feat1 = validPtsimg1.Count;
feat2 = validPtsimg2.Count;
feats = feat1 + feat2;
eff = (2*match)/feats;
setappdata(0,'eff',eff);




% % I = imread('cameraman.tif');
% % points = detectSURFFeatures(I);
% size(I)
% size(points)

% figure; ax1 = axes;
% gte = vision.GeometricTransformEstimator;
% gte.Transform = 'Projective';
% [tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
% showMatchedFeatures(img1,img2,matchedimg1(inlierIdx),matchedimg2(inlierIdx),'montage','Parent',ax1);
% title('MATCHING INLIERS');

% size(matchedimg2(inlierIdx).Location)
% size(matchedimg2.Location)


% --- Executes on button press in pushbutton5.
function pushbutton5_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matchedimg1 = getappdata(0,'matchedimg1');
matchedimg2 = getappdata(0,'matchedimg2');

img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

[h1, w1, dim1] = size(img1);
[h2, w2, dim2] = size(img2);

ax = handles.axes4;
gte = vision.GeometricTransformEstimator;
gte.Transform = 'Projective';
[tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
showMatchedFeatures(img1,img2,matchedimg1(inlierIdx),matchedimg2(inlierIdx),'montage','Parent',ax);
title('MATCHING INLIERS');

% --- Executes on button press in pushbutton6.
function pushbutton6_Callback(hObject, eventdata, handles)
Pixels_Table
% hObject    handle to pushbutton6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% matchedimg1 = getappdata(0,'matchedimg1');
% matchedimg2 = getappdata(0,'matchedimg2');
% 
% gte = vision.GeometricTransformEstimator;
% gte.Transform = 'Projective';
% [tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
% 
% data1 = matchedimg1(inlierIdx).Location;
% data2 = matchedimg2(inlierIdx).Location;
% 
% scale1 = matchedimg1(inlierIdx).Scale;
% scale2 = matchedimg2(inlierIdx).Scale;
% 
% 
% [nn] = size(data1);
% id = [1:nn(1)]';
% 
% data = [num2cell(id), num2cell(data1), num2cell(data2)];
% [n,m] = size(data);
% 
% for i = 1:n
%     for j = 1:m
%         %if j > 1
%             data{i,j} = sprintf('%0.0f',data{i,j});
%         %elseif j == 1
%             %data{i,j} = sprintf('%0.0f',data{i,j});
%         %end
%     end
% end
% 
% setappdata(0,'hh',data)

%f = figure('Position',[100 100 700 500]);
% set(handles.uitable1,'data',data);
% set(handles.uitable1,'ColumnName',{'ID','Xl','Yl','Xr','Yr'});
% jscrollpane = findjobj(handles.uitable1);
% jTable = jscrollpane.getViewport.getView;
% cellStyle = jTable.getCellStyleAt(0,0);
% cellStyle.setHorizontalAlignment(cellStyle.CENTER);
% jTable.repaint;

%table.Data = data;
%table.NumColumns = m;
%table.NumRows = n;

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gte = vision.GeometricTransformEstimator;
gte.Transform = 'Projective';
%Ir = step(agt, im2single(Iout), tform);
img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

matchedimg1 = getappdata(0,'matchedimg1');
matchedimg2 = getappdata(0,'matchedimg2');

%figure, imshowpair(Iin,Ip,'blend');

I1 = double(img1);
[h1 w1 d1] = size(img1);
I2 = double(img2);
[h2 w2 d2] = size(img2);

[tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
T=tform';
% %T = [a b tx ; -b a ty ; 0 0 1];
% if (strcmp(transformType,'Projective'))
%     T=tform';
% else T=[tform';0 0 1];
% end

% warp incoming corners to determine the size of the output image (in to out)
cp = T*[ 1 1 w2 w2 ; 1 h2 1 h2 ; 1 1 1 1 ]; 
Xpr = min( [ cp(1,:) 0 ] ) : max( [cp(1,:) w1] ); % min x : max x
Ypr = min( [ cp(2,:) 0 ] ) : max( [cp(2,:) h1] ); % min y : max y
[Xp,Yp] = ndgrid(Xpr,Ypr);
[wp hp] = size(Xp); % = size(Yp)

% do backwards transform (from out to in)
X = T \ [ Xp(:) Yp(:) ones(wp*hp,1) ]';  % warp

% re-sample pixel values with bilinear interpolation
clear Ip;
xI = reshape( X(1,:),wp,hp)';
yI = reshape( X(2,:),wp,hp)';
Ip(:,:,1) = interp2(I2(:,:,1), xI, yI, '*bilinear'); % red
Ip(:,:,2) = interp2(I2(:,:,2), xI, yI, '*bilinear'); % green
Ip(:,:,3) = interp2(I2(:,:,3), xI, yI, '*bilinear'); % blue

% offset and copy original image into the warped image
offset =  -round( [ min( [ cp(1,:) 0 ] ) min( [ cp(2,:) 0 ] ) ] );
Ip(1+offset(2):h1+offset(2),1+offset(1):w1+offset(1),:) = double(I1(1:h1,1:w1,:));

% show the result
% set(handles.axes1, 'Visible', 'off')
% set(handles.axes1, 'HandleVisibility', 'off')
% set(handles.axes2, 'Visible', 'off')
% set(handles.axes2, 'HandleVisibility', 'off')
% set(handles.axes4, 'Visible', 'on')
% set(handles.axes4, 'HandleVisibility', 'on')
% 
% children1 = get(handles.axes1, 'children');
% delete(children1);
% 
% children2 = get(handles.axes2, 'children');
% delete(children2);
handles.axes4; image(Ip/255); axis image;

% image(Ip/255); axis image
% imshow(image,'Parent',handles.axes3); axis off; 
% title('Registered Image');


% --- Executes on button press in pushbutton8.
function pushbutton8_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
set(handles.axes1, 'Visible', 'on')
set(handles.axes1, 'HandleVisibility', 'on')
set(handles.axes2, 'Visible', 'on')
set(handles.axes2, 'HandleVisibility', 'on')
set(handles.axes1,'XTick',[], 'YTick', [])
set(handles.axes2,'XTick',[], 'YTick', [])


children = get(handles.axes4, 'children');
delete(children);
axes(handles.axes4); axis on
set(handles.axes4, 'visible', 'off');
set(handles.axes4, 'HandleVisibility', 'off');
set(handles.axes4,'XTick',[], 'YTick', [])
set(handles.edit1,'String', '')

% img1 = '';
% img2 = '';
% setappdata(0,'img1',img1)
% setappdata(0,'img1',img1)


% children3 = get(handles.axes3, 'children');
% delete(children3);
% axes(handles.axes3); axis on

% data = getappdata(0,'hh');
% [rows,columns] = size(data);
% data = cell(rows,columns);
% data(:,:) = {''};
% set(handles.uitable1,'data',data)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_6_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function data_cursor_Callback(hObject, eventdata, handles)
% hObject    handle to data_cursor (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function zoom_on_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom on
waitfor(gcf,'CurrentCharacter',char(13))


% --------------------------------------------------------------------
function zoom_off_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_off (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom off


% --------------------------------------------------------------------
function zoom_reset_Callback(hObject, eventdata, handles)
% hObject    handle to zoom_reset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
zoom reset


% --------------------------------------------------------------------
function load_left_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_left_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg;*.tiff;*.bmp;*.ecw','All Files'});
if ischar(filename) && ischar(pathname)
    fullpathname1 = strcat(pathname, filename);
    img1 = imread(fullpathname1);
    imshow(img1,'Parent',handles.axes1); impixelinfo

else
    return
    
end

assignin('base','image1_location', fullpathname1);
setappdata(0,'img1', img1);

% dcm = datacursormode;
% dcm.Enable = 'on';
% dcm.Enable = 'off';


% --------------------------------------------------------------------
function load_right_image_Callback(hObject, eventdata, handles)
% hObject    handle to load_right_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[filename, pathname] = uigetfile({'*.jpg;*.tiff;*.bmp;*.ecw','All Files'});
if ischar(filename) && ischar(pathname)
    fullpathname2 = strcat(pathname, filename);
    img2 = imread(fullpathname2);
    imshow(img2,'Parent',handles.axes2); impixelinfo

else
    return
    
end

assignin('base','image2_location', fullpathname2);
setappdata(0,'img2', img2);


% --- Executes on button press in radiobutton1.
function radiobutton1_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% surf = get(hObject,'Value')
% setappdata(0,'surf', surf);
% Hint: get(hObject,'Value') returns toggle state of radiobutton1


% --- Executes on button press in radiobutton2.
function radiobutton2_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% fast = get(hObject,'Value');
% setappdata(0,'fast', fast);
% Hint: get(hObject,'Value') returns toggle state of radiobutton2


% --- Executes on button press in radiobutton3.
function radiobutton3_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% harris = get(hObject,'Value');
% setappdata(0,'harris', harris);
% Hint: get(hObject,'Value') returns toggle state of radiobutton3


% --------------------------------------------------------------------
function Untitled_7_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_11_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_11 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Filter_Outliers_Callback(hObject, eventdata, handles)
% hObject    handle to Filter_Outliers (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function surf_Callback(hObject, eventdata, handles)
% hObject    handle to surf (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function sift_Callback(hObject, eventdata, handles)
% hObject    handle to sift (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function harris_corner_detection_Callback(hObject, eventdata, handles)
% hObject    handle to harris_corner_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in radiobutton5.
function radiobutton5_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
gte = vision.GeometricTransformEstimator;
gte.Transform = 'Projective';
%Ir = step(agt, im2single(Iout), tform);
img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

matchedimg1 = getappdata(0,'matchedimg1');
matchedimg2 = getappdata(0,'matchedimg2');

%figure, imshowpair(Iin,Ip,'blend');

I1 = double(img1);
[h1 w1 d1] = size(img1);
I2 = double(img2);
[h2 w2 d2] = size(img2);

[tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
T=tform';
% %T = [a b tx ; -b a ty ; 0 0 1];
% if (strcmp(transformType,'Projective'))
%     T=tform';
% else T=[tform';0 0 1];
% end

% warp incoming corners to determine the size of the output image (in to out)
cp = T*[ 1 1 w2 w2 ; 1 h2 1 h2 ; 1 1 1 1 ]; 
Xpr = min( [ cp(1,:) 0 ] ) : max( [cp(1,:) w1] ); % min x : max x
Ypr = min( [ cp(2,:) 0 ] ) : max( [cp(2,:) h1] ); % min y : max y
[Xp,Yp] = ndgrid(Xpr,Ypr);
[wp hp] = size(Xp); % = size(Yp)

% do backwards transform (from out to in)
X = T \ [ Xp(:) Yp(:) ones(wp*hp,1) ]';  % warp

% re-sample pixel values with bilinear interpolation
clear Ip;
xI = reshape( X(1,:),wp,hp)';
yI = reshape( X(2,:),wp,hp)';
Ip(:,:,1) = interp2(I2(:,:,1), xI, yI, '*bilinear'); % red
Ip(:,:,2) = interp2(I2(:,:,2), xI, yI, '*bilinear'); % green
Ip(:,:,3) = interp2(I2(:,:,3), xI, yI, '*bilinear'); % blue

% offset and copy original image into the warped image
offset =  -round( [ min( [ cp(1,:) 0 ] ) min( [ cp(2,:) 0 ] ) ] );
Ip(1+offset(2):h1+offset(2),1+offset(1):w1+offset(1),:) = double(I1(1:h1,1:w1,:));

% show the result
handles.axes4; image(Ip/255); axis image;
impixelinfo;

% image(Ip/255); axis image
% imshow(image,'Parent',handles.axes3); axis off; 
title('Registered Image');

imwrite(Ip,'registered.jpg');
assignin('base','result',Ip/255); 
% Hint: get(hObject,'Value') returns toggle state of radiobutton5


% --- Executes on button press in radiobutton4.
function radiobutton4_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
matchedimg1 = getappdata(0,'matchedimg1');
matchedimg2 = getappdata(0,'matchedimg2');

img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

[h1, w1, dim1] = size(img1);
[h2, w2, dim2] = size(img2);

ax = handles.axes4;
gte = vision.GeometricTransformEstimator;
gte.Transform = 'Projective';
[tform inlierIdx] = step(gte, matchedimg2.Location, matchedimg1.Location);
showMatchedFeatures(img1,img2,matchedimg1(inlierIdx),matchedimg2(inlierIdx),'montage','Parent',ax);
title('MATCHING INLIERS'); impixelinfo;
assignin('base','matchedimg1', matchedimg1);
assignin('base','matchedimg2', matchedimg2);

% Hint: get(hObject,'Value') returns toggle state of radiobutton4


% --- Executes on button press in radiobutton7.
function radiobutton7_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of radiobutton7


% --------------------------------------------------------------------
function cursorOn_Callback(hObject, eventdata, handles)
% hObject    handle to cursorOn (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%datacursormode on
dcm = datacursormode;
dcm.Enable = 'on';
dcm.SnapToDataVertex = 'off'; 
dcm.UpdateFcn = @displayCoordinates;

alldatacursors = findall(gcf,'type','hggroup','-property','FontSize');
set(alldatacursors,'FontSize',11);
set(alldatacursors,'FontName','Times');
set(alldatacursors,'FontWeight','normal');
set(alldatacursors,'MarkerSize', 15,'MarkerFaceColor','none', ...
              'MarkerEdgeColor','r', 'Marker','+');




% --------------------------------------------------------------------
function cursorOff_Callback(hObject, eventdata, handles)
% hObject    handle to cursorOff (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
datacursormode off


% --- Executes on button press in radiobutton8.
function radiobutton8_Callback(hObject, eventdata, handles)
% hObject    handle to radiobutton8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% brisk = get(hObject,'Value');
% setappdata(0, 'brisk', brisk)
% Hint: get(hObject,'Value') returns toggle state of radiobutton8


% --- Executes on button press in pushbutton9.
function pushbutton9_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton9 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% reg = evalin('base', 'result');
% origRead = evalin('base', 'image1_location');
% orig = imread(origRead);
% 
% orig = rgb2gray(imresize(orig,[350 200]));
% reg = rgb2gray(imresize(reg, [350 200]));
% 
% % m = size(reg(:));
% % 
% % size(reg)
% % size(orig)
% % class(reg)
% % class(orig)
% % figure, imshow(reg), figure, imshow(orig);
% 
% std_error = std(double(orig(:)) - double(reg(:)));
eff = getappdata(0,'eff');
eff = sprintf('%s%s',num2str(eff*100),'%');
set(handles.edit1,'string', eff);



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


% --------------------------------------------------------------------
function Show_Table_Callback(hObject, eventdata, handles)
Pixels_Table
% hObject    handle to Show_Table (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% Hint: get(hObject,'Value') returns toggle state of radiobutton10


% --- Executes when selected object is changed in uibuttongroup2.
function uibuttongroup2_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in uibuttongroup2 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
buttongroup = get(hObject, 'String');
img1 = getappdata(0,'img1');
img2 = getappdata(0,'img2');

img1 = rgb2gray(img1);
img2 = rgb2gray(img2);

if strcmp(buttongroup,'SURF')
    ptsimg1  = detectSURFFeatures(img1);
    ptsimg2 = detectSURFFeatures(img2);
    
elseif strcmp(buttongroup,'FAST')
    ptsimg1  = detectFASTFeatures(img1);
    ptsimg2 = detectFASTFeatures(img2);
    
elseif strcmp(buttongroup,'Harris Corner Detection')
    ptsimg1  = detectHarrisFeatures(img1);
    ptsimg2 = detectHarrisFeatures(img2);
    
else
    ptsimg1  = detectBRISKFeatures(img1);
    ptsimg2 = detectBRISKFeatures(img2);    
end

setappdata(0, 'ptsimg1', ptsimg1)
setappdata(0, 'ptsimg2', ptsimg2)
