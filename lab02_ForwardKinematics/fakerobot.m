function [x,y]=fakerobot(x0,y0,t1,t2,l1,l2)
  x=x0+[0, l1*cosd(t1) , l1*cosd(t1)+l2*cosd(t1+t2)];
  y=y0+[0, l1*sind(t1) , l1*sind(t1)+l2*sind(t1+t2)];
endfunction
