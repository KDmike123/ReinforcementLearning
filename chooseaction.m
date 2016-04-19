function [ action,maxQ,r] = chooseaction(gg,isnext)
%CHOOSEACTION Summary of this function goes here
%   Detailed explanation goes here
cx=repmat(gg.cellcX,20,1);
cy=repmat(gg.cellcY,1,20);
if isnext==0
 p1=(cx-gg.state.x).^2;
 p2=(cy-gg.state.y).^2;
else
 p1=(cx-gg.nextstate.x).^2;
 p2=(cy-gg.nextstate.y).^2;   
end
p3=(p1+p2)./(2*gg.delta);
r=exp(-p3);
nr=r(:);
for i=1:8
    W=gg.gridweights(:,:,i);
    nW=W(:)';
    Q(i)=nW*nr;
end

[M,I]=max(Q);

 st=rand();
 action=I;
 if isnext==1
   if st>(1-gg.epsilon)
       action=I;
    else
        action=randi(8);
       while(action==I)
         action=randi(8);
       end
   end
 end
 
 maxQ=Q(action);

    
end

