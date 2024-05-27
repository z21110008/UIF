function [UIFscore] = UIF_1(D,R)
%% D is the enhancement image; R is the raw image.

    Dg = double(rgb2gray(D)); 
    Rg = double(rgb2gray(R)); 
    D = double(D);
    R = double(R);

%% Basic SETUP OF FRSIM

    d = diff(getrangefromclass(D));
    C = [(0.01*d).^2 ((0.01*d).^2)/2 ((0.03*d).^2)/2 ];
    a = 0.8; b =0.2;
% MSCN
    MSCN_window = fspecial('gaussian',7,7/6);
    MSCN_window = MSCN_window/sum(sum(MSCN_window));        
    warning('off');  
    
    mu = imfilter(Dg,MSCN_window,'replicate'); %Enhancement image's MSCN.
    mu_sq = mu.*mu;
    sigma = sqrt(abs(imfilter(Dg.*Dg,MSCN_window,'replicate') - mu_sq));
    D_MSCN = (Dg-mu)./(sigma+1);
    %cv = sigma./mu; 
    
    mu1 = imfilter(Rg,MSCN_window,'replicate'); %Raw image's MSCN.
    mu_sq1 = mu1.*mu1;
    sigma1 = sqrt(abs(imfilter(Rg.*Rg,MSCN_window,'replicate') - mu_sq1));
    R_MSCN = (Rg-mu1)./(sigma1+1);
    %cv1 = sigma1./mu1; 
    
%% feature extraction and calculation   
%% Naturalness Index
  mc_mscn = max(var(D_MSCN),var(R_MSCN));
  w_mscn = mc_mscn./sum(mc_mscn(:));
  CM = C(1);
  SM = (2*D_MSCN.*R_MSCN+CM)./(D_MSCN.*D_MSCN+R_MSCN.*R_MSCN+CM);
  mean_SM = mean(SM(:));


%% Sharpness Index
D_gradient = grad(D); 
R_gradient = grad(R); 
%SG = (2*D_gradient.*R_gradient+0.0001)./(D_gradient.*D_gradient+R_gradient.*R_gradient+0.0001);
CG = C(2);
SG = (2*D_gradient.*R_gradient+CG)./(D_gradient.*D_gradient+R_gradient.*R_gradient+CG);
mean_SG = mean(SG(:));

 %% Structure Index
  CS = C(3);
  SS = (2*sigma.*sigma1+CS)./(sigma.^2+sigma1.^2+CS);
  mean_SS = mean(SS(:));
%% pooling

%UIFmap = SM.*((SG).^a) .*((SS).^b)+0.1;

%UIFscore = mean_SG ;
UIFscore = mean_SS^a* mean_SG^b*mean_SM;
%z(cnt,:)=D(cnt,:)^0.8*Z(cnt,:)^0.2*C(cnt,:);
end

function gradimg = grad(Ig)
Ig=double(Ig(:,:,1));
Ig=Ig./255+ eps;
hy = fspecial('Sobel');
hx = hy';
Iy = imfilter(double(Ig), hy, 'replicate');
Ix = imfilter(double(Ig), hx, 'replicate');
gradimg = sqrt(Ix.^2 + Iy.^2);
end
    