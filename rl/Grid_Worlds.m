gw = createGridWorld(10,9); % create a grid world named gw with ten rows and nine columns
gw.TerminalStates = "[7,9]"; %specify the terminal state as the location [7,9]
env = rlMDPEnv(gw); %A grid world needs to be included in a Markov decision process (MDP) environment.