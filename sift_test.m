function sift_test = sift_test(I)
    sift_test = single(rgb2gray(I)) ;
    image(sift_test);
    [f,d] = vl_sift(sift_test) ;
    perm = randperm(size(f,2)) ;
    sel = perm(1:50) ;
    h1 = vl_plotframe(f(:,sel)) ;
    h2 = vl_plotframe(f(:,sel)) ;
    set(h1,'color','k','linewidth',3) ;
    set(h2,'color','y','linewidth',2) ;
end