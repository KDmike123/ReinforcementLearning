function [ gg ] = goadvance( action,gg )
%GOADVANCE Summary of this function goes here
%   Detailed explanation goes here
%start point

     switch action
        case 1
           gg.nextstate.x=gg.state.x+gg.actionstep*sqrt(2)/2;
           gg.nextstate.y=gg.state.y+gg.actionstep*sqrt(2)/2;
         case 2
           gg.nextstate.x=gg.state.x;
           gg.nextstate.y=gg.state.y+gg.actionstep;
         case 3
           gg.nextstate.x=gg.state.x-gg.actionstep*sqrt(2)/2;
           gg.nextstate.y=gg.state.y+gg.actionstep*sqrt(2)/2;
         case 4
           gg.nextstate.x=gg.state.x-gg.actionstep;
           gg.nextstate.y=gg.state.y;
         case 5
           gg.nextstate.x=gg.state.x-gg.actionstep*sqrt(2)/2;
           gg.nextstate.y=gg.state.y-gg.actionstep*sqrt(2)/2; 
         case 6
           gg.nextstate.x=gg.state.x;
           gg.nextstate.y=gg.state.y-gg.actionstep*sqrt(2)/2;
         case 7
           gg.nextstate.x=gg.state.x+gg.actionstep*sqrt(2)/2;
           gg.nextstate.y=gg.state.y-gg.actionstep*sqrt(2)/2;
         case 8
           gg.nextstate.x=gg.state.x+gg.actionstep*sqrt(2)/2;
           gg.nextstate.y=gg.state.y;
     end
     
     
     
end

