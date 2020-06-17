% balance a pole on a moving cart by applying horizontal forces to the cart.

% The pole is considered successfully balanced if both of the following conditions are satisfied:
%    1.The pole angle remains within a given threshold of the vertical position, where the vertical position is zero radians.
%    2. The magnitude of the cart position remains below a given threshold.

% There are two cart-pole environment variants, which differ by the agent action space:
%    1.Discrete — Agent can apply a force of either Fmax or -Fmax to the cart, where Fmax is the MaxForce property of the environment.
%    2. Continuous — Agent can apply any force within the range [-Fmax,Fmax]

% create a cart-pole environment
env = rlPredefinedEnv('CartPole-Discrete');   %Discrete action space
%env = rlPredefinedEnv('CartPole-Continuous');  %Continuous action space
plot(env)


%Environment Properties
%{
 Gravity = 9.8  %Acceleration due to gravity in meters per second
 MassCart = 1  %Mass of the cart in kilograms
 MassPole = 0.1  %Mass of the pole in kilograms
 Length = 0.5   %Half the length of the pole in meters
 MaxForce = 10    %Maximum horizontal force magnitude in newtons
 Ts = 0.02     %Sample time in seconds.
 ThetaThresholdRadians = 0.2094   %Pole angle threshold in radians
 XThreshold  = 2.4   %Cart position threshold in meters
 RewardForNotFalling = 1  %Reward for each time step the pole is balanced
 PenaltyForFalling = -5 for Discrete & -50 for Continuous    %Reward penalty for failing to balance the pole
 state = [0 0 0 0]   %Environment state, specified as a column vector with the following state variables:
                     (1)Cart position
                     (2)Derivative of cart position
                     (3)Pole angle
                     (4)Derivative of pole angle
%}


% Actions : s, the agent interacts with the environment using a single action signal,the horizontal force applied to the cart.
% Observations: observe all the environment state variables in env.State