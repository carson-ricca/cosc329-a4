function val = util_help(giveHelp)

% action is to give help.
% giveHelp = 1(false), 2(true)
% utility value is in [-5, +5]

% reference point
val = 0;

% helping the user cause a disruption penalty
val = val - 1;

% the action depends on whether or not the user uses the autocomplete
% suggestion. If the user doesn't use the autocomplete then the utility is
% very low. If the user does use the autocomplete then the utility is high.
if giveHelp == 1
    val = val - 3;
else
    val = val + 5;
end    