function [ wall ] = checkifout( gg )
%CHECKIFOUT Summary of this function goes here
%   Detailed explanation goes here
        wall=0;
         if gg.nextstate.x>=1
            wall=1;
         elseif gg.nextstate.x<=0
             wall=1;
         elseif gg.nextstate.y>=1
             wall=1;
         elseif gg.nextstate.y<=0
             wall=1;
         else
             wall=0;           
         end

end

