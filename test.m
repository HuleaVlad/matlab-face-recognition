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
figure(1),imagesc(C);title('covariance')
colorbar

%% Calculam vectorii si valorile proprii ale matricei C
% Calculam vectorii proprii si valorile proprii
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
%% Reprezentarea setului de imagini sub forma eigenvectorilor + avgImg

for i = 1:M  % Numarul de imagini
    for k = 1:Nr % Numarul de eigenfaces
        wi(i,k) = sum(EigFaces(:,k) .* A(:,i));
    end
end


%% Poza input
%input = imresize(handles.inputIMG,[N N]);
input = imread('database/s1/4.pgm');
input  =  im2single(input);



Aface = input(:)-avImg(:);
for tt=1:Nr
  wface(tt)  =  sum(EigFaces(:,tt).* Aface) ;
end



%% Compute distance
for i=1:M  
    fsumcur=0;
    for tt=1:Nr
        fsumcur = fsumcur + (wface(tt) -wi(i,tt)).^2;
    end
    diffWeights(i) = sqrt( fsumcur);
end