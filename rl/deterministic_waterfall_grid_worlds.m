%includes a waterfall that pushes the agent toward the bottom of the grid
env = rlPredefinedEnv('WaterFallGridWorld-Deterministic');
plot(env)
%{
Actions: four possible directions (north, south, east, or west).
Rewards:
	• +10 reward for reaching the terminal state at [4,5]
	• -1 penalty for every other action

Waterfall Dynamics:
The intensity of the waterfall varies between the columns, as shown at the top of the preceding
figure. When the agent moves into a column with a nonzero intensity, the waterfall pushes it
downward by the indicated number of squares. For example, if the agent goes east from state [5,2], it
reaches state [7,3].
%}