function [ isin ] = checkifin( gg )
%CHECKIFIN Summary of this function goes here
%   Detailed explanation goes here
distance=sqrt((gg.nextstate.x-gg.goal.x)^2+(gg.nextstate.y-gg.goal.y)^2);
isin=0;
if distance<=gg.radius
    isin=1;
end

