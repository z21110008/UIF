clear;
clc;

constForVS = 1.27;%fixed
constForGM = 386;%fixed
constForChrom = 130;%fixed
alpha = 0.40;%fixed
lambda = 0.020;%fixed
sigmaF = 1.34;%fixed donot change
omega0 = 0.0210;%fixed
sigmaD = 145;%fixed
sigmaC = 0.001;%fixed

img1 = imread('317_1.bmp');
img2 = imread('317_2.bmp');

UIFscore  = UIF_1(img1,img2)

