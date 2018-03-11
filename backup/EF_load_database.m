function out = EF_load_database()
    % declaram variabilele locale
    persistent loaded;
    persistent w;
    %N = 50;
    % nu se mai incarca nici o alta baza de date
    if(isempty(loaded))
        % A = matricea baza de date, 10304 = rezolutia unei poze, 400 = numarul de poze din baza de date
        A = zeros(92*112, 400);
        
        % 40 = numarul de persoane din baza de date
        for i = 1:40
            % incarcam toate pozele in matricea cu baza de date
            for j = 1:10
                s = sprintf('database/s%d/%d.pgm',i,j);
                img = imread(s);
                %img = imresize(img,[N N] );
                %   reshape transforma poza in vector coloana
                A(:, (i - 1) * 10 + j) = reshape(img, size(img, 1) * size(img, 2), 1);
                
            end

        end
        
        % covertim in numere unsigned 8 bit numbers pentru a ocupa mai putin spatiu in memorie
        w = uint8(A);
    end
    
    % pentru a nu mai incarca inca o data baza de date
    loaded = 1;
    out = w;
end
