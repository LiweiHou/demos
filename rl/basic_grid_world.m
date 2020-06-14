%{
Agent location is a red circle. 
By default, the agent starts in state [1,1].
Terminal location is a blue square.
Obstacles are black squares.
The agent can move in one of four possible directions (north, south, east, or west).
The agent receives the following rewards or penalties:
	• +10 reward for reaching the terminal state at [5,5]
	• +5 reward for jumping from state [2,4] to state [4,4]
	• -1 penalty for every other action
%}
env = rlPredefinedEnv('BasicGridWorld');
plot(env)