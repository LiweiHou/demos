% solve a grid world environment using Q-learning and SARSA agents.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% grid world environment configuration and rules:
% 1） The grid world is 5-by-5 and bounded by borders, with four possible actions (North = 1, South =2, East = 3, West = 4).
% 2） The agent begins from cell [2,1] (second row, first column).
% 3)  The agent receives a reward +10 if it reaches the terminal state at cell [5,5] (blue).
% 4） The environment contains a special jump from cell [2,4] to cell [4,4] with a reward of +5.
% 5） The agent is blocked by obstacles (black cells)
% 6） All other actions result in –1 reward.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% 1 Create Grid World Environment
env = rlPredefinedEnv("BasicGridWorld");
env.ResetFcn = @() 2; %To specify that the initial state of the agent is always [2,1], reset function that returns the state number for the initial agent state
rng(0)  %Fix the random generator seed for reproducibility

% 2 Create Q-Learning Agent  (agent=policy&algorithms)
%%% creat policy
qTable = rlTable(getObservationInfo(env),getActionInfo(env));
qRepresentation = rlQValueRepresentation(qTable,getObservationInfo(env),getActionInfo(env));
qRepresentation.Options.LearnRate = 1;  %learning rate
%%% chose RL algorithms
agentOpts = rlQAgentOptions;
agentOpts.EpsilonGreedyExploration.Epsilon = .04;
qAgent = rlQAgent(qRepresentation,agentOpts);

% Train Q-Learning Agent
%%% training configuration
trainOpts = rlTrainingOptions;
trainOpts.MaxStepsPerEpisode = 50; % each episode lasts for most 50 time steps
trainOpts.MaxEpisodes= 200; %Train for at most 200 episodes
trainOpts.StopTrainingCriteria = "AverageReward";
trainOpts.StopTrainingValue = 11;
trainOpts.ScoreAveragingWindowLength = 30;
%%% Do training
trainingStats = train(qAgent,env,trainOpts);

% Validate Q-Learning Results
plot(env)
env.Model.Viewer.ShowTrace = true;
env.Model.Viewer.clearTrace;
sim(qAgent,env) %Simulate the agent in the environment
