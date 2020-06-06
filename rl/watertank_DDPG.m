% 打开预设系统
open_system('rlwatertank')


%%%%%%%%%%%%%%%%%%%%%%%
%创建环境接口
%%%%%%%%%%%%%%%%%%%%%%%
% 定义观测量
obsInfo = rlNumericSpec([3 1],...   
    'LowerLimit',[-inf -inf 0  ]',...    
    'UpperLimit',[ inf  inf inf]');  % 观测量是一个3*1矩阵，定义其上下限
obsInfo.Name = 'observations';       % 观测量名称
obsInfo.Description = 'integrated error, error, and measured height';   % 观测量描述，观测量的三项分别为... 
numObservations = obsInfo.Dimension(1);    % 定义观测量的维度
% 定义action
actInfo = rlNumericSpec([1 1]);      % action是一个1*1的矩阵
actInfo.Name = 'flow';               % action的名称
numActions = actInfo.Dimension(1);   % 观测量的维度
% 定义环境
env = rlSimulinkEnv('rlwatertank','rlwatertank/RL Agent',...    
    obsInfo,actInfo); 
% 定义reset函数
env.ResetFcn = @(in)localResetFcn(in);  % randomizes the reference values for the model.
% 定义仿真时间和步长
Ts = 1.0; Tf = 200; 
% 定义随机数种子
rng(0) 


%%%%%%%%%%%%%%%%%%%%%%%
%创建一个DDPG agent
%%%%%%%%%%%%%%%%%%%%%%%
% 定义几个神经网络，定义内容主要是输入层、全连接层、池化层等
statePath = [    imageInputLayer([numObservations 1 1],'Normalization','none','Name','State')    
    fullyConnectedLayer(50,'Name','CriticStateFC1')    
    reluLayer('Name','CriticRelu1')    
    fullyConnectedLayer(25,'Name','CriticStateFC2')]; 
actionPath = [    imageInputLayer([numActions 1 1],'Normalization','none','Name','Action')    
    fullyConnectedLayer(25,'Name','CriticActionFC1')]; 
commonPath = [    additionLayer(2,'Name','add')    
    reluLayer('Name','CriticCommonRelu')    
    fullyConnectedLayer(1,'Name','CriticOutput')];
% 将神经网络连接起来形成critic
criticNetwork = layerGraph(); 
criticNetwork = addLayers(criticNetwork,statePath); 
criticNetwork = addLayers(criticNetwork,actionPath); 
criticNetwork = addLayers(criticNetwork,commonPath); 
criticNetwork = connectLayers(criticNetwork,'CriticStateFC2','add/in1'); 
criticNetwork = connectLayers(criticNetwork,'CriticActionFC1','add/in2');
% 将神经网络结构可视化
figure 
plot(criticNetwork)
% 指定网络的相关设置
criticOpts = rlRepresentationOptions('LearnRate',1e-03,'GradientThreshold',1); 
% 使用指定的深度网络机器相关设置创建critic
critic = rlRepresentation(criticNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},criticOpts);
%创建actor
actorNetwork = [
    imageInputLayer([numObservations 1 1],'Normalization','none','Name','State')
    fullyConnectedLayer(3, 'Name','actorFC')
    tanhLayer('Name','actorTanh')
    fullyConnectedLayer(numActions,'Name','Action')
    ];
% 指定网络的相关设置
actorOptions = rlRepresentationOptions('LearnRate',1e-04,'GradientThreshold',1);
% 使用指定的深度网络机器相关设置创建actor
actor = rlRepresentation(actorNetwork,obsInfo,actInfo,'Observation',{'State'},'Action',{'Action'},actorOptions);
%给定一些设置并创建agent
agentOpts = rlDDPGAgentOptions(...
    'SampleTime',Ts,...
    'TargetSmoothFactor',1e-3,...
    'DiscountFactor',1.0, ...
    'MiniBatchSize',64, ...
    'ExperienceBufferLength',1e6); 
agentOpts.NoiseOptions.Variance = 0.3;
agentOpts.NoiseOptions.VarianceDecayRate = 1e-5;
agent = rlDDPGAgent(actor,critic,agentOpts);



%%%%%%%%%%%%%%%%%%%%%%%
% 训练agent
%%%%%%%%%%%%%%%%%%%%%%%
%设置训练参数
maxepisodes = 5000;
maxsteps = ceil(Tf/Ts);
trainOpts = rlTrainingOptions(...
    'MaxEpisodes',maxepisodes, ...
    'MaxStepsPerEpisode',maxsteps, ...
    'ScoreAveragingWindowLength',20, ...
    'Verbose',false, ...
    'Plots','training-progress',...
    'StopTrainingCriteria','AverageReward',...
    'StopTrainingValue',800);
%训练
trainingStats = train(agent,env,trainOpts);



%%%%%%%%%%%%%%%%%%%%%%%
% 验证控制效果
%%%%%%%%%%%%%%%%%%%%%%%
simOpts = rlSimulationOptions('MaxSteps',maxsteps,'StopOnError','on');
experiences = sim(env,agent,simOpts);


% % 自己定义的localResetFcn，前面用到了
% function in = localResetFcn(in)
% 
% % randomize reference signal
% blk = sprintf('rlwatertank/Desired \nWater Level');
% h = 3*randn + 10;
% while h <= 0 || h >= 20
%     h = 3*randn + 10;
% end
% in = setBlockParameter(in,blk,'Value',num2str(h));
% 
% % randomize initial height
% h = 3*randn + 10;
% while h <= 0 || h >= 20
%     h = 3*randn + 10;
% end
% blk = 'rlwatertank/Water-Tank System/H';
% in = setBlockParameter(in,blk,'InitialCondition',num2str(h));
% 
% end