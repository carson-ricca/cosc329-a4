function prRead = sim_help_decision( dbn, ex )
% function prRead = sim_hints_decision( dbn, ex )
% ARGS: dbn = dynamic bayes net model specified by BNT syntax
%       ex  = a specific setting used to generate evidence
%

engine = bk_inf_engine(dbn);   % set up inference engine 
T = 50;                        % define number of time steps in problem

if ex == 1
  ev = sample_dbn(dbn, T);
  evidence = cell(2, T);
  onodes   = dbn.observed;
  evidence(onodes, :) = ev(onodes, :);
elseif ex == 2
  evidence = cell(2, T);
  for ii=1:T
    evidence{2,ii} = 2;
  end
else
  readval = 2;
  evidence = sampleHelp_seq(dbn, readval, T);
end
evidence
