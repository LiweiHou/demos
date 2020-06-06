% train a Q-learning agent to solve a MDP environment.

% 1 Create MDP Environment
MDP = createMDP(8,["up";"down"]); %eight states and two actions ("up" and "down").
%%% state 1 transtition and reward
MDP.T(1,2,1) = 1;
MDP.R(1,2,1) = 3;
MDP.T(1,3,2) = 1;
MDP.R(1,3,2) = 1;
%%% state 2 transtition and reward
MDP.T(2,4,1) = 1;
MDP.R(2,4,1) = 2;
MDP.T(2,5,2) = 1;
MDP.R(2,5,2) = 1;
%%% state 3 transtition and reward
MDP.T(3,5,1) = 1;
MDP.R(3,5,1) = 2;
MDP.T(3,6,2) = 1;
MDP.R(3,6,2) = 4;
%%% state 4 transtition and reward
MDP.T(4,7,1) = 1;
MDP.R(4,7,1) = 3;
MDP.T(4,8,2) = 1;
MDP.R(4,8,2) = 2;
%%% state 5 transtition and reward
MDP.T(5,7,1) = 1;
MDP.R(5,7,1) = 1;
MDP.T(5,8,2) = 1;
MDP.R(5,8,2) = 9;
%%% state 6 transtition and reward
MDP.T(6,7,1) = 1;
MDP.R(6,7,1) = 5;
MDP.T(6,8,2) = 1;
MDP.R(6,8,2) = 1;
%%% state 7 transtition and reward
MDP.T(7,7,1) = 1;
MDP.R(7,7,1) = 0;
MDP.T(7,7,2) = 1;
MDP.R(7,7,2) = 0;
%%% State 8 transition and reward
MDP.T(8,8,1) = 1;
MDP.R(8,8,1) = 0;
MDP.T(8,8,2) = 1;
MDP.R(8,8,2) = 0;
%%%
MDP.TerminalStates = ["s7";"s8"];  %Specify states "s7" and "s8" as terminal states of the MDP.
env = rlMDPEnv(MDP); %Create RL MDP env for this process model
env.ResetFcn = @() 1;  %specify that the initial state of the agent is always state 1
rng(1) %Fix the random generator seed for reproducibility.

% 2 Create Q-Learning Agent
%%%  create a Q table
obsInfo = getObservationInfo(env);
actInfo = getActionInfo(env);
qTable = rlTable(obsInfo, actInfo);
qRepresentation = rlQValueRepresentation(qTable, obsInfo, actInfo);
qRepresentation.Options.LearnRate = 1;
%%% creating Q-learning agents
agentOpts = rlQAgentOptions;
agentOpts.DiscountFactor = 1.0;
agentOpts.EpsilonGreedyExploration.Epsilon = 0.9;
agentOpts.EpsilonGreedyExploration.EpsilonDecay = 0.01;
qAgent = rlQAgent(qRepresentation,agentOpts);

% 3 Train Q-Learning Agent
trainOpts = rlTrainingOptions;
trainOpts.MaxStepsPerEpisode = 50;
trainOpts.MaxEpisodes = 400;
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 13;
trainOpts.ScoreAveragingWindowLength = 30;

% 4 Train!
trainingStats = train(qAgent,env,trainOpts);

% 5 Validate Q-Learning Results
Data = sim(qAgent,env);
cumulativeReward = sum(Data.Reward)
%%%cumulativeReward = 13

% Since the discount factor is set to 1, 
%the values in the Q table of the trained agent 
% match the undiscounted returns of the environment.
QTable = getLearnableParameters(getCritic(qAgent));
QTable{1}
%{
ans = 8×2

 13 12
  5 10
  11 9
  3 2
  1 9
  5 1
  0 0
  0 0

%}




