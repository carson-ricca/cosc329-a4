% timeopen is short, correct is true, tasktime is ontask
sim_both(mk_hints, mk_needhelp, 1, 'short_true_ontask')

% timeopen is on task, correct is false, tasktime is toolong
sim_both(mk_hints, mk_needhelp, 2, 'ontask_false_long')

% read is false, needhelp is false
sim_both(mk_hints, mk_needhelp, 3, 'false_false')

% read is true, needhelp is false
sim_both(mk_hints, mk_needhelp, 4, 'true_false')

% read is true, needhelp is true
sim_both(mk_hints, mk_needhelp, 5, 'true_true')