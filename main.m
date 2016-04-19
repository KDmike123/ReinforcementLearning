clear all

gg.cellcX=0:1/19:1;
gg.cellcY=(0:1/19:1)';
gg.gridweights=rand(20,20,8);
%gg.gridweights=gg.gridweights./sqrt(gg.gridweights(:)'*gg.gridweights(:));
gg.distance=1/19;
gg.elitrace=zeros(20,20,8);
%reward with respect to the current state
gg.delta=0.05^2;
%8 directions
gg.direction=8;
%epsilon-greedy strategy to choose action
gg.epsilon=0.95;
gg.actionstep=0.03;
gg.radius=0.1;
%goal area
gg.goal.x=0.8;
gg.goal.y=0.8;
gg.goal.r=10;
%start point
gg.state.x=0.1;
gg.state.y=0.1;
gg.nextstate.x=0;
gg.nextstate.y=0;

gg.gamma=0.95;
gg.lamda=0.95;
gg.eta=0.05;

trials=50;
Nmax=10000;
action=1;

figure
hold on
axis([0 1 0 1]);
for trytr=1:100
      gg.state.x=0.1;
      gg.state.y=0.1;
   gg.elitrace=zeros(20,20,8);
     [action, Qc,r]=chooseaction(gg,0);
     
    for iteration=1:Nmax
        reward=0;
        X(iteration)=gg.state.x;
        Y(iteration)=gg.state.y;
        gg=goadvance(action,gg);
        %check if collide with the walls
        iswall=checkifout(gg);
        if iswall
            reward=-2;
            gg.nextstate.x=gg.state.x;
            gg.nextstate.y=gg.state.y;
        end
        %check if get the goal area,reward and stop
        isgoal=checkifin(gg);
        if isgoal
            reward=10;
        end
        
        %next action
        [nextaction, Qn,nr]=chooseaction(gg,1);
        %update
        delta=reward-(Qc-Qn*gg.gamma);
        for i=1:8
            if i==action && ~iswall
               gg.elitrace(:,:,action)=gg.gamma*gg.lamda*gg.elitrace(:,:,action)+r;
            else
               gg.elitrace(:,:,i)=gg.gamma*gg.lamda*gg.elitrace(:,:,i);  
            end
        end
        
        %update weight (1-gg.eta)*
        %we can use (1-gg.eta)*gg.gridweights to replace gg.gridweights
        gg.gridweights=(1-gg.eta)*gg.gridweights+gg.eta*delta*gg.elitrace;
        
        %old become a, old s become s
        %start point update
         gg.state.x=gg.nextstate.x;
         gg.state.y=gg.nextstate.y;
         action=nextaction;
         Qc=Qn;
         r=nr;
         %this can be commented and just for optimization
         %if collide with the wall, take the opposite direction with the
         %probability 0.5
%              if iswall
%                  if rand()>0.5
%                      action=mod(action+4,8);
%                  else
%                      action=nextaction;
%                  end 
%              end
            
        
         if(isgoal)
             % disp(['got the goal trials:',num2str(trytr)]);
             break;    
         end
    end
    it(trytr)=iteration;
    disp(['trial=',num2str(trytr),' iteration= ',num2str(iteration)]);
    plot(X,Y,'-');
end

 hold on
 plot(0.8,0.8,'*');
 hold off



