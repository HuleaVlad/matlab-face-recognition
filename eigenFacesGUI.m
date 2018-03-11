function varargout = eigenFacesGUI(varargin)
% EIGENFACESGUI MATLAB code for eigenFacesGUI.fig
%      EIGENFACESGUI, by itself, creates a new EIGENFACESGUI or raises the existing
%      singleton*.
%
%      H = EIGENFACESGUI returns the handle to a new EIGENFACESGUI or the handle to
%      the existing singleton*.
%
%      EIGENFACESGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EIGENFACESGUI.M with the given input arguments.
%
%      EIGENFACESGUI('Property','Value',...) creates a new EIGENFACESGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before eigenFacesGUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to eigenFacesGUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help eigenFacesGUI

% Last Modified by GUIDE v2.5 12-Jan-2017 14:34:39

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @eigenFacesGUI_OpeningFcn, ...
                   'gui_OutputFcn',  @eigenFacesGUI_OutputFcn, ...
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


% --- Executes just before eigenFacesGUI is made visible.
function eigenFacesGUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to eigenFacesGUI (see VARARGIN)

% Choose default command line output for eigenFacesGUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes eigenFacesGUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = eigenFacesGUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Browse image
[FileName PathName] = uigetfile({'*.pgm;*.PGM','PGM Files(*.pgm,*.PGM)'},'File Select');

% Test image
if isequal(FileName, 0) || isequal(PathName, 0)
    warndlg('Error: user pressed cancel.Please select an image file.','Load Error');
else
    
    s = strcat(PathName, FileName);    
    [pathstr, name, ext] = fileparts(s);
    if isequal(ext, '.pgm')
        
        handles.FileName = FileName;
        inputIMG=imread(s);
        axes(handles.axes1);
        cla
        %afiseaza poza
        imshow(inputIMG);
        axis image;
        grid off;
        title('Poza cautata...','FontWeight','bold','Fontsize',14,'color','blue');
        handles.inputIMG = inputIMG;
        guidata(hObject,handles);
    else
        warndlg('Error: invalid file format. Please select an image file.','Load Error');
    end
    
end

save('img.mat','inputIMG');

% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



B = EF_load_database();  

%% Poza input
%input = imresize(handles.inputIMG,[N N]);
input = handles.inputIMG;
input  =  im2single(input);
fileID = fopen('avImg.txt','r');
avImg = fscanf(fileID,'%f');
avImg = single(avImg);
fclose(fileID);
wi = dlmread('wi.txt');wi = single(wi);
EigFaces = dlmread('EigFaces.txt');

Nr = 50;
M = 400;
Aface = input(:)-avImg(:);
for tt=1:Nr
  wface(tt)  =  sum(EigFaces(:,tt).* Aface) ;
end


%% Compute distance
for i=1:M  
    fsumcur=0;
    for tt=1:Nr
        fsumcur = fsumcur + (wface(tt) - wi(i,tt)).^2;
    end
    diffWeights(i) = sqrt(fsumcur);
end

%% Afisare poza
k1 = 1;
k2 = 1;
x=0;
for i=1:M
    if(diffWeights(i) < 600)
        vec1(k1) = diffWeights(i);
        vec2(k2) = i;
        k1 = k1 + 1 ;
        k2 = k2 + 1;
        x = 1;
    end
end

if x == 0
    warndlg('Image not found','Load Error');
else
    [~,b] = sort(vec1,'ascend');
    vec2(b(1));
    asd = B(:,vec2(b(1)));
    asd = reshape(asd, 112 , 92);
    axes(handles.axes2);
    imshow(asd,'Initialmagnification','fit');
end


% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

GUI2



% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


%% database
% Am introdus setul imaginilor de antrenare deja redimensionate

B = EF_load_database(); 
%N = 50;
M = 400;

%% Normalizarea imaginilor
avImg=zeros(92*112,1);
for i = 1:M
    A = im2single(B);
    avImg = avImg  + (1/M)*A(:,i);
end
    %average = reshape(avImg, 50 , 50);
    %figure(1);
    % Afisam trasaturile comune tuturor celor 400 de imagini
    %imshow(average,'Initialmagnification','fit');
    % Scadem aceste trasaturi din fiecare imagine
for i = 1:M
    A(:,i) = A(:,i) - avImg;
end
    
%% Calculam matricea de covarianta redusa
C = A'*A;
%figure(2),imagesc(C);title('covariance')
%colorbar

%% Calculam vectorii si valorile proprii ale matricei C
% Calculam vectorii proprii si valorile proprii
[ Vecprop,Diagprop ]  = eig(C);
% Revenim la dimensiunea initiala de 2500 x 1
Vlarge = A * Vecprop;
x=diag(Diagprop);
[~,xci]=sort(x,'descend');% largest eigenval
Nr = 50;
EigFaces = zeros(92*112,Nr);
for i = 1:Nr
    EigFaces(:,i) = Vlarge(:,xci(i));
end
%% Reprezentarea setului de imagini sub forma eigenvectorilor + avgImg

for i = 1:M  % Numarul de imagini
    for k = 1:Nr % Numarul de eigenfaces
        wi(i,k) = sum(EigFaces(:,k) .* A(:,i));
    end
end


fileID = fopen('avImg.txt','w');
fprintf(fileID,'%f\n',avImg);
fclose(fileID);
dlmwrite('wi.txt',wi);
dlmwrite('EigFaces.txt',EigFaces)

warndlg('Database reloaded','');
