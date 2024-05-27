function [score] = URQ(im)

    r         = im(:,:,1);
    mean_r    = mean(r(:)); 
    if(mean_r<128)
        kr     = mean_r/128;
    else
        kr     = (256 - mean_r)/128;
    end
    im2       = rgb2gray(im);
    [count,~] = imhist(im2);          
    total     = sum(count);
    entropy   = 0;
    for k = 1:256
        p = count(k)/total;
        if p ~= 0
           logp      = log2(p);
           entropele = -p*logp;
           entropy   = entropy + entropele;
        end
    end
    E1= entropy/(log2(256));    
    e       = entropyfilt(im2)/(log2(81));   
    E2  = mean(e(:));    
    score = 0.11 * kr + 0.45 * E1 + 0.44 * E2;
end

