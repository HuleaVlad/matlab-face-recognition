function varargout = GUI2(varargin)
% GUI2 MATLAB code for GUI2.fig
%      GUI2, by itself, creates a new GUI2 or raises the existing
%      singleton*.
%
%      H = GUI2 returns the handle to a new GUI2 or the handle to
%      the existing singleton*.
%
%      GUI2('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GUI2.M with the given input arguments.
%
%      GUI2('Property','Value',...) creates a new GUI2 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before GUI2_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to GUI2_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help GUI2

% Last Modified by GUIDE v2.5 12-Jan-2017 16:36:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @GUI2_OpeningFcn, ...
                   'gui_OutputFcn',  @GUI2_OutputFcn, ...
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


% --- Executes just before GUI2 is made visible.
function GUI2_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to GUI2 (see VARARGIN)

% Choose default command line output for GUI2
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes GUI2 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = GUI2_OutputFcn(hObject, eventdata, handles) 
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

%% database
% Am introdus setul imaginilor de antrenare deja redimensionate

B = EF_load_database();
M = 400;

%% Normalizarea imaginilor
avImg=zeros(92*112,1);
for i = 1:M
    A = im2single(B);
    avImg = avImg  + (1/M)*A(:,i);
end
    average = reshape(avImg, 112 , 92);
    axes(handles.axes1);
    % Afisam trasaturile comune tuturor celor 400 de imagini
    
    imshow(average);
    xlabel('Trasaturile comune a imaginilor din baza de date','FontWeight','bold','Fontsize',14,'color','black');
    
for i = 1:M
    A(:,i) = A(:,i) - avImg;
end
save('test.mat','A','avImg','B');


% --- Executes on button press in pushbutton2.
function pushbutton2_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Calculam matricea de covarianta redusa
cla reset;
load('test.mat', 'A','avImg','B')
C = A' * A;
imagesc(C);colormap default;
xlabel('Matricea de covarianta','FontWeight','bold','Fontsize',14,'color','black');
colorbar

save('test.mat','A','avImg','C','B');

% --- Executes on button press in pushbutton3.
function pushbutton3_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Calculam vectorii si valorile proprii ale matricei C
% Calculam vectorii proprii si valorile proprii

load('test.mat','A','avImg','C','B')

[ Vecprop,Diagprop ]  = eig(C);
% Revenim la dimensiunea initiala de 2500 x 1
Vlarge = A * Vecprop;
x=diag(Diagprop);
[~,xci]=sort(x,'descend');% largest eigenval
Nr = 100;
EigFaces = zeros(92*112,Nr);
for i = 1:Nr
    EigFaces(:,i) = Vlarge(:,xci(i));
end

for i = 1:400  % Numarul de imagini
    for k = 1:Nr % Numarul de eigenfaces
        wi(i,k) = sum(EigFaces(:,k) .* A(:,i));
    end
end

asd = zeros(500,500);
k = 1;
for i = 1 : 10
    for j = 1 : 10
        X = reshape(EigFaces(:,k), 112 , 92);
        X = imresize(X,[50 50] );
        asd(i*50-49:i*50,j*50-49:j*50) = X;
        k = k + 1;
    end
end

imshow(asd);
xlabel('Setul de EigenFaces','FontWeight','bold','Fontsize',14,'color','black');
save('test.mat','A','avImg','C','B','wi','EigFaces');

% --- Executes on button press in pushbutton4.
function pushbutton4_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%% Poza input

load('test.mat','A','avImg','C','B','wi','EigFaces');
load('img.mat','inputIMG');

%input = imresize(handles.inputIMG,[N N]);
input = inputIMG;
input  =  im2single(input);


Aface = input(:)-avImg(:);
for tt=1:100
  wface(tt)  =  sum(EigFaces(:,tt).* Aface) ;
end



%% Compute distance
for i=1:400  
    fsumcur=0;
    for tt=1:100
        fsumcur = fsumcur + (wface(tt) -wi(i,tt)).^2;
    end
    diffWeights(i) = sqrt( fsumcur);
end

%% Afisare poza
k1 = 1;
k2 = 1;
x=0;
for i=1:400
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
    imshow(asd);
    xlabel('Poza gasita!','FontWeight','bold','Fontsize',14,'color','black');
end

