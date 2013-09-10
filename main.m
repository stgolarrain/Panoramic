picture_directory = dir('pictures/*.JPG');
npictures = size(picture_directory, 1);
used_picture = zeros(npictures, 1);

image1 = load_image(picture_directory(1).name);
used_picture(1) = 1;

%for i=1:npictures
while npictures - sum(used_picture) > 0
    disp('iteration: i');
    
    image1 = im2single(image1);
    [f1,d1] = vl_sift(image1);
    max_matches = 0;
    max_picture = 0;
    
    for j=1:npictures
        disp('iteration: j');
        %if i ~= j && ~used_picture(j)
        if ~used_picture(j)
            image2 = load_image(picture_directory(j).name);
            [f2,d2] = vl_sift(image2);
            
            [matches, scores] = vl_ubcmatch(d1,d2);
            numMatches = size(matches,2);
            if numMatches > max_matches
                max_matches = numMatches;
                max_picture = j;
            end
            
        end
    end
    % pasar la imagen max_picture y la imagen actual
    % panoramic_picture(image1, image2);
    
    % Obtiene las coordenadas de la matriz f de los puntos de matches
    X1 = f1(1:2,matches(1,:)); 
    X1(3,:) = 1;
    
    X2 = f2(1:2,matches(2,:)); 
    X2(3,:) = 1;
    
    clear f2;
    clear d2;
    
    % Calculando la matriz H entre X1 y X2
    H = Bmv_homographyRANSAC(X1, X2);
    
    box2 = [1 size(image2,2) size(image2,2) 1;
            1 1              size(image2,1) size(image2,1);
            1 1              1              1];
    box2_ = inv(H) * box2;
    box2_(1,:) = box2_(1,:) ./ box2_(3,:);
    box2_(2,:) = box2_(2,:) ./ box2_(3,:);
    ur = min([1 box2_(1,:)]):max([size(image1,2) box2_(1,:)]) ;
    vr = min([1 box2_(2,:)]):max([size(image1,1) box2_(2,:)]) ;    
    
    [u,v] = meshgrid(ur,vr) ;
    image1_ = vl_imwbackward(im2double(image1),u,v) ;

    z_ = H(3,1) * u + H(3,2) * v + H(3,3) ;
    u_ = (H(1,1) * u + H(1,2) * v + H(1,3)) ./ z_ ;
    v_ = (H(2,1) * u + H(2,2) * v + H(2,3)) ./ z_ ;
    image2_ = vl_imwbackward(im2double(image2),u_,v_) ;

    clear z_;
    clear u_;
    clear v_;
    clear u;
    clear v;
    
    mass = ~isnan(image1_) + ~isnan(image2_) ;
    image1_(isnan(image1_)) = 0 ;
    image2_(isnan(image2_)) = 0 ;
    image1 = (image1_ + image2_) ./ mass ;

    
    %figure(2) ; clf ;
    %imagesc(image1) ; axis image off ;
    %title('Mosaic') ;
    
    clear mass;
    clear image1_;
    clear image2_;
    clear H;
    
    used_picture(j) = 1;
    %input('Press any key to continue');
    clf;
end
imshow(image1);
input('Press any key to exit');

