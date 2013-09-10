function load_image = load_image(name)
    scale = 0.3;
    root = 'pictures/';
    
    load_image = imread([root name]);
    load_image = imresize(load_image, scale);
    load_image = im2single(load_image); %Necesary step for vl_sift
    load_image = rgb2gray(load_image);
end