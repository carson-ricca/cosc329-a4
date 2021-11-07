function prHelp = sim_help_decision( dbn, ex, file_name )
% function prHelp = sim_help_decision( dbn, ex, file_name )
% ARGS: dbn = dynamic bayes net model specified by BNT syntax
%       ex  = a specific setting used to generate evidence
%       file_name = the file_name for the graph

engine = bk_inf_engine(dbn);   % set up inference engine 
T = 50;                        % define number of time steps in problem

if ex == 1
  ev = sample_dbn(dbn, T);
  evidence = cell(3, T);
  onodes = dbn.observed;
  evidence(onodes, :) = ev(onodes, :);
elseif ex == 2
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 1;
    evidence{3,ii} = 1;
  end
elseif ex == 3
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 1;
    evidence{3,ii} = 2;
  end
elseif ex == 4
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 2;
    evidence{3,ii} = 1;
  end 
elseif ex == 5
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 2;
    evidence{3,ii} = 2;
  end 
elseif ex == 6
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 3;
    evidence{3,ii} = 1;
  end 
elseif ex == 7
  evidence = cell(3, T);
  for ii=1:T
    evidence{2,ii} = 3;
    evidence{3,ii} = 2;
  end   
else
  % NeedHelp = True  
  helpval = 2;
  evidence = sampleHelp_seq(dbn, helpval, T);
end
evidence

% inference process
% setup results to be stored
belief = [];
exputil = [];
subplot( 1, 2, 1 );

% at t=0, no evidence has been entered, so the probability is same as the
% prior encoded in the DBN itself
prHelp = get_field( dbn.CPD{ dbn.names('NeedHelp') }, 'cpt' );
belief = [belief, prHelp(2)];
subplot( 1, 2, 1 );
plot( belief, 'o-' );

% log best decision
[bestA, euHelp] = get_meu_help(prHelp(2));
exputil = [exputil, euHelp]; 
fprintf('t=%d: best action = %s, euHelp = %f\n', 0, bestA, euHelp);
subplot( 1, 2, 2 );
plot( exputil, '*-' );

% at t=1: initialize the belief state
[engine, ll(1)] = dbn_update_bel1(engine, evidence(:,1));

marg = dbn_marginal_from_bel(engine, 1);
prHelp = marg.T;
belief = [belief, prHelp(2)];
subplot(1, 2, 1);
plot( belief, 'o-' );

% log best decision
[bestA, euHelp] = get_meu_help(prHelp(2));
exputil = [exputil, euHelp]; 
fprintf('t=%d: best action = %s, euHelp = %f\n', 1, bestA, euHelp);
subplot( 1, 2, 2 );
plot( exputil, '*-' );

% Repeat inference steps for each time step
%
for t=2:T
  % update belief with evidence at current time step
  [engine, ll(t)] = dbn_update_bel(engine, evidence(:,t-1:t));
  
  % extract marginals of the current belief state
  i = 1;
  marg = dbn_marginal_from_bel(engine, i);
  prHelp = marg.T;

  % log best decision
  [bestA, euHelp] = get_meu_help(prHelp(2));
  exputil = [exputil, euHelp]; 
  fprintf('t=%d: best action = %s, euHelp = %f\n', t, bestA, euHelp);
  subplot( 1, 2, 2 );
  plot( exputil, '*-' );
  xlabel( 'Time Steps' );
  ylabel( 'EU(Help)' );
  axis( [ 0 T -5 5] );

  % keep track of results and plot it
  belief = [belief, prHelp(2)];
  subplot( 1, 2, 1 );
  plot( belief, 'o-' );
  xlabel( 'Time Steps' );
  ylabel( 'Pr(NeedHelp)' );
  axis( [ 0 T 0 1] );
  pause(0.1);
end
exportgraphics(gcf, [file_name, '.png'])
