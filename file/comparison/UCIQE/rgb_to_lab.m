function lab = rgb_to_lab(rgb)

cform = makecform('srgb2lab');  %rgbתlab��ʽ
lab = applycform(rgb,cform);    %lab��ʽ

end