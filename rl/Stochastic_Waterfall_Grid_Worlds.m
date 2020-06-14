% a two-dimensional 8-by-7 grid
% includes a waterfall that pushes the agent towards 
% the bottom of the grid with a stochastic intensity
env = rlPredefinedEnv('WaterFallGridWorld-Stochastic');
plot(env)
%{
Actions: four possible directions (north, south, east, or west).
Rewards:
	• +10 reward for reaching the terminal state at [4,5]
	• -10 penalty for reaching any terminal state in the bottom row of the grid
	• -1 penalty for every other action
Waterfall Dynamics:
 a waterfall pushes the agent towards the bottom of the grid with a stochastic
intensity. The baseline intensity matches the intensity of the deterministic waterfall environment.
However, in the stochastic waterfall case, the agent has an equal chance of experiencing the
indicated intensity, one level above that intensity, or one level below that intensity. For example, if the
agent goes east from state [5,2], it has an equal chance of reaching state [6,3], [7,3], or [8,3].
%}