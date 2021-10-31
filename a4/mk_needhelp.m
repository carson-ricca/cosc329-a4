function DBN = mk_needhelp

names = {'NeedHelp', 'TaskTime', 'Correct'};
ss    = length( names );

% intra-stage dependencies
intrac = {...
'NeedHelp', 'TaskTime'; 'NeedHelp', 'Correct'};
[intra, names] = mk_adj_mat( intrac, names, 1 );
DBN = names;

% inter-stage dependencies
interc = {...
'NeedHelp', 'NeedHelp'};
inter = mk_adj_mat( interc, names, 0 );

% observations
onodes = [ find(cellfun(@isempty, strfind(names,'NeedHelp'))==0) ];

% discretize nodes
ns     = [2 3 2];
dnodes = 1:ss;

% define equivalence classes
ecl1 = [1 2];
ecl2 = [1 3];
ecl3 = [4 2];
ecl4 = [4 3];

% create the dbn structure
bnet = mk_dbn( intra, inter, ns, ...
  'discrete', dnodes, ...
  'eclass1', ecl1, ...
  'eclass2', ecl2, ...
  'eclass3', ecl3, ...
  'eclass4', ecl4, ...
  'observed', onodes, ...
  'names', names );
DBN  = bnet;