function prBoth = sim_both(hint_dbn, help_dbn, ex, file_name)
% function prBoth = sim_both( hint_dbn, help_dbn, ex, file_name )
% ARGS: hint_dbn = dynamic bayes net model for hints
%       help_dbn = dynamic bayes net model for help
%       ex  = a specific setting used to generate evidence
%       file_name = the file name to export the plot to
%

hint_engine = bk_inf_engine( hint_dbn );
help_engine = bk_inf_engine( help_dbn );
T = 50;

if ex == 1
    hint_evidence = cell(2, T);
    help_evidence = cell(3, T);
  for ii=1:T
    help_evidence{2,ii} = 2;
    help_evidence{3,ii} = 2;
    hint_evidence{2,ii} = 1;
  end  
elseif ex == 2
    hint_evidence = cell(2, T);
    help_evidence = cell(3, T);
    for ii=1:T
        help_evidence{2,ii} = 3;
        help_evidence{3,ii} = 1;
        hint_evidence{2,ii} = 2;
    end
elseif ex == 3
    readval = 1;
    helpval = 1;
    hint_evidence = sampleHint_seq( hint_dbn, readval, T );
    help_evidence = sampleHelp_seq( help_dbn, helpval, T );
elseif ex == 4
    readval = 2;
    helpval = 1;
    hint_evidence = sampleHint_seq( hint_dbn, readval, T );
    help_evidence = sampleHelp_seq( help_dbn, helpval, T );    
else
    readval = 2;
    helpval = 2;
    hint_evidence = sampleHint_seq( hint_dbn, readval, T );
    help_evidence = sampleHelp_seq( help_dbn, helpval, T );
end

% inference process
% setup results to be stored
belief = [];
help_exputil = [];
hint_exputil = [];
subplot( 1, 2, 1 );

prHelp = get_field( help_dbn.CPD{ help_dbn.names('NeedHelp') }, 'cpt' );
belief = [belief, prHelp(2)];
subplot( 1, 2, 1 );
plot( belief, 'o-' , 'DisplayName', 'Pr(NeedHelp)');
hold on
prRead = get_field( hint_dbn.CPD{ hint_dbn.names('Read') }, 'cpt' );
belief = [belief, prRead(2)];
plot( belief, '*-', 'DisplayName', 'Pr(Read)' );
hold off

[bestA, euHelp, euHint] = get_meu(prHelp(2), prRead(2));
help_exputil = [help_exputil, euHelp]; 
fprintf('t=%d: best action = %s, euHelp = %f\n', 0, bestA, euHelp);
subplot( 1, 2, 2 );
plot( help_exputil, 'o-',  'DisplayName', 'EU(NeedHelp)');
hold on
hint_exputil = [hint_exputil, euHint]; 
fprintf('t=%d: best action = %s, euHint = %f\n', 0, bestA, euHint);
plot( hint_exputil, '*-', 'DisplayName','EU(Read)' );
hold off

% at t=1: initialize the belief state 
%
[help_engine, ll(1)] = dbn_update_bel1(help_engine, help_evidence(:,1));

marg = dbn_marginal_from_bel(help_engine, 1);
prHelp = marg.T;
belief = [belief, prHelp(2)];
subplot( 1, 2, 1 );
plot( belief, 'o-', 'DisplayName', 'Pr(NeedHelp)' );
hold on

[hint_engine, ll(1)] = dbn_update_bel1(hint_engine, hint_evidence(:,1));

marg = dbn_marginal_from_bel(hint_engine, 1);
prRead = marg.T;
belief = [belief, prRead(2)];
plot( belief, '*-', 'DisplayName', 'Pr(Read)' );
hold off

% log best decision
[bestA, euHelp, euHint] = get_meu(prHelp(2), prRead(2));
help_exputil = [help_exputil, euHelp]; 
fprintf('t=%d: best action = %s, euHelp = %f\n', 1, bestA, euHelp);
subplot( 1, 2, 2 );
plot( help_exputil, 'o-',  'DisplayName', 'EU(NeedHelp)' );
hold on
hint_exputil = [hint_exputil, euHint]; 
fprintf('t=%d: best action = %s, euHint = %f\n', 1, bestA, euHint);
plot( hint_exputil, '*-', 'DisplayName','EU(Read)' );
hold off

% Repeat inference steps for each time step
%
for t=2:T
  % update belief with evidence at current time step
  [help_engine, ll(t)] = dbn_update_bel(help_engine, help_evidence(:,t-1:t));
  [hint_engine, ll(t)] = dbn_update_bel(hint_engine, hint_evidence(:,t-1:t));

  % extract marginals of the current belief state
  i = 1;
  marg = dbn_marginal_from_bel(help_engine, i);
  prHelp = marg.T;
  marg = dbn_marginal_from_bel(hint_engine, i);
  prRead = marg.T;

  % log best decision
  [bestA, euHelp, euHint] = get_meu(prHelp(2), prRead(2));
  help_exputil = [help_exputil, euHelp];
  hint_exputil = [hint_exputil, euHint]; 
  fprintf('t=%d: best action = %s, euHelp = %f\n', t, bestA, euHelp);
  fprintf('t=%d: best action = %s, euHint = %f\n', t, bestA, euHint);
  subplot( 1, 2, 2 );
  plot( help_exputil, 'o-', 'DisplayName', 'EU(NeedHelp)' );
  hold on
  plot( hint_exputil, '*-', 'DisplayName','EU(Read)' );
  hold off
  xlabel( 'Time Steps' );
  ylabel( 'Expected Utility' );
  axis( [ 0 T -5 5] );

  % keep track of results and plot it
  belief = [belief, prHelp(2)];
  subplot( 1, 2, 1 );
  plot( belief, 'o-', 'DisplayName', 'Pr(NeedHelp)' );
  belief = [belief, prRead(2)];
  hold on
  plot( belief, '*-', 'DisplayName', 'Pr(Read)' );
  hold off
  xlabel( 'Time Steps' );
  ylabel( 'Probability' );
  axis( [ 0 T 0 1] );
  pause(0.1);
end
exportgraphics(gcf, [file_name, '.png'])

