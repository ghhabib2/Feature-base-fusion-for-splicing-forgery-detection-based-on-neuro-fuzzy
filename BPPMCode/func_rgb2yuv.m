function O = rgb2yuv( I )
  [i,j,k] = size(I);
  CONVERTER = [0.299    0.587    0.114
              -0.14713 -0.28886 0.436
               0.615    -0.51498 -0.10001];
  for row = 1:i
    for col = 1:j
      RGB = [I(row, col, 1)
             I(row, col, 2)
             I(row, col, 3)];
      YUV = CONVERTER * double(RGB);
      O(row, col, :) = YUV;
    end
  end
return