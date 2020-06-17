% control the position of a mass in a second-order system by applying a force input.
% Specifically, the second-order system is a double integrator with a gain.

% Training episodes for these environments end when either of the following events occurs:
%    （1） The mass moves beyond a given threshold from the origin.
%    （2）The norm of the state vector is less than a given threshold.

% There are two double integrator environment variants, which differ by the agent action space.
%    （1）  Discrete — Agent can apply a force of either Fmax or -Fmax to the cart, where Fmax is the MaxForce property of the environment.
%    （2）  Continuous — Agent can apply any force within the range [-Fmax,Fmax].


%  create a double integrator environment,
env = rlPredefinedEnv('DoubleIntegrator-Discrete');  % Discrete action space
% env = rlPredefinedEnv('DoubleIntegrator-Continuous');  % Continuous action space
plot(env)


% Environment Properties
%{
Gain = 1   %Gain for the double integrator
Ts  = 0.1  %Sample time in seconds
MaxDistance = 5   %Distance magnitude threshold in meters
GoalThreshold = 0.01   %State norm threshold
Q = [10 0 ; 0 1] %Weight matrix for observation component of reward signal
R = 0.01   %Weight matrix for action component of reward signal
MaxForce = 2 for discrete & Inf for continuous
State = [0 0]  ;  [ Mass position     Derivative of mass position  ]
%}

% Actions:   a single action signal, the force applied to the mass.
% Observations:  the agent can observe both of the environment state variables in env.State.
%reward
%{
\text {reward}=-\int\left(x^{\prime} Q x+u^{\prime} R u\right) d t
 %%%%is analogous to the cost function of an LQR controller.
 %%%%Q and R are environment properties.
 %%%%x is the environment state vector
 %%%%u is the input force.
 This reward is the episodic reward, that is, the cumulative reward across the entire training episode.
%}