function ev = sampleHelp_seq(dbn, readval, T)

% create empty evidence for T time steps
ev = cell(dbn.nnodes_per_slice, T);

% get index of observation variables
onode1 = dbn.names('TaskTime');
onode2 = dbn.names('Correct');


for t=1:T
  % sample value of variable
  oval1 = stoch_obs('TaskTime', dbn, readval);

  % store sampled value into evidence structure
  ev{onode1, t} = oval1;
end

for t=1:T
    oval2 = stoch_obs('Correct', dbn, readval);
    ev{onode2, t} = oval2;
end    