dim = 20;
num_obstacles = 19;
num_episodes = 500;
plot_freq = 25; % every $plot_freq images are plotted
save_maze = 1; % 0 = false, 1 = true
img_dir = 'images'; % image directory; where to save images
planning = 1; %0 = off, 1 = on
N = 40; %Planning steps
%initialize parameters
epsilon = .75;
gamma =.9;
alpha = .1;
lambda = .9;
mu = .99;
muval = 99; %used for outputing if save_maze = 1
%initialize goal position
goalX = randi( dim ) - .5;
goalY = randi( dim ) - .5;
%goalX = 13.5;
%goalY = 12.5;
%initialize obstacles to zeros
obstaclesX = zeros( 1, num_obstacles );
obstaclesY = zeros( 1, num_obstacles );
%add goal to obstacles so randomly generated obstacles aren't in the goal

obstaclesX(1) = goalX;
obstaclesY(1) = goalY;
%set up the world to make plotting easier later
gridX = repmat( transpose(.5:1:(dim-.5)), 1, dim );
gridY = transpose( gridX );
u = zeros( dim, dim );
v = zeros( dim, dim );
%randomly generate obstacles
for i=2:num_obstacles
 newObX = randi( dim ) - .5;
 newObY = randi( dim ) - .5;
 while Check_obstacle( newObX, newObY, obstaclesX, obstaclesY )
 newObX = randi( dim ) - .5;
 newObY = randi( dim ) - .5;
 end
 obstaclesX(i) = newObX;
 obstaclesY(i) = newObY;
end
%remove goal from obstacles
obstaclesX = obstaclesX(2:end);
obstaclesY = obstaclesY(2:end);
%initialize Q(s,a) arbitrarily
Q = zeros( dim, dim, 4 );
Q( (obstaclesX+.5), (obstaclesY+.5), : ) = 0;
%eligability trace and planning model
et = zeros( dim, dim, 4 );
if planning
 model = zeros(dim, dim, 4, 3);
end
%get optimal solution for each point
%this may be slightly off, depending on obstacle positions
optSol = abs(gridX - goalX) + abs(gridY - goalY);
error = zeros( 1, num_episodes );
for i=1:num_episodes
 %begin an episode
 if(i == num_episodes) %Remove epsilon-greedy
 epsilon = 0;
 end
 %initialize start state -- don't run into obstacles and be a bit from
 %the goal
 X = randi(dim) - .5;
 Y = randi(dim) - .5;
 while (abs(X-goalX) < 2 ) || Check_obstacle(X,Y,obstaclesX,obstaclesY) ||(abs(Y-goalY) < 2 )
 X = randi(dim) - .5;
 Y = randi(dim) - .5;
 end
 startX = X;
 
 
 startY = Y;

 %initialize the action
 if (i == 1)
 action = randi(4);
 else
 [val,action] = max(Q(X+.5,Y+.5,:));
 end

 %these matricies will hold the x,y positions traveled
 xmat = 0;
 ymat = 0;
 steps = 0;
 amat = 0;
 %repeat for each step
 while( 1 )
 %save the number of steps it has taken
 steps = steps + 1;
 sprintf( '%u %u %u\n', steps, X, Y );

 %save the x and y positions and corresponding action
 xmat( steps ) = X;
 ymat( steps ) = Y;
 amat( steps ) = action;

 %take action, observe r,s'
 nextX = X;
 nextY = Y;
 switch action
 case 1
 nextY = Y + 1; %up
 if Check_obstacle( X, nextY, obstaclesX, obstaclesY )
 nextY = Y;
 end
 case 2
 nextX = X + 1; %right
 if Check_obstacle( nextX, Y, obstaclesX, obstaclesY )
 nextX = X;
 end
 case 3
 nextX = X - 1; %left
 if Check_obstacle( nextX, Y, obstaclesX, obstaclesY )
 nextX = X;
 end
 case 4
 nextY = Y - 1; %down
 if Check_obstacle( X, nextY, obstaclesX, obstaclesY )
 nextY = Y;
 end
 end

 %go back if it knocks you off the map
 if nextX > dim || nextX < 0
 nextX = X;
 end
 if nextY > dim || nextY < 0
     
     nextY = Y;
 end

 %only reward for hitting goal
 if nextX == goalX && nextY == goalY
 reward = 1;
 else
 reward = 0;
 end

 %choose next action based on Q using epsilon-greedy
 rannum = rand();
 [val,ind] = max(Q(nextX+.5,nextY+.5,:));
 if rannum > epsilon
 %take greedy
 next_action = ind;
 else
 %take non-greedy
 next_action = randi(4);
 while next_action == ind
 next_action = randi(4);
 end
 end

 delta = reward + gamma*Q(nextX+.5,nextY+.5,next_action) -Q(X+.5,Y+.5,action);
 et(X+.5, Y+.5, action ) = et(X+.5, Y+.5, action ) + 1;

 Q = Q + alpha*delta*et;
 et = gamma*lambda*et;

 if planning
 model(X+.5,Y+.5,action,1) = nextX;
 model(X+.5,Y+.5,action,2) = nextY;
 model(X+.5,Y+.5,action,3) = reward;

 for k=1:N
 prev = randi(length(xmat)); %choose a random previous state
 X = xmat(prev);
 Y = ymat(prev);
 action = amat(prev);
 simX = model(X+.5,Y+.5,action,1);
 simY = model(X+.5,Y+.5,action,2);
 simR = model(X+.5,Y+.5,action,3);
 [val,simA] = max(Q(simX+.5,simY+.5,:));
 Q(X+.5,Y+.5,action) = Q(X+.5,Y+.5,action) + alpha*(simR +gamma*Q(simX+.5,simY+.5,simA) - Q(X+.5,Y+.5,action));
 end
 end

 X = nextX;
 Y = nextY;
 action = next_action;

 if X == goalX && Y == goalY
     error(i) = steps - optSol(startX+.5,startY+.5);
 break;
 end
 end

 %decay epsilon with time
 epsilon = epsilon*mu;
end