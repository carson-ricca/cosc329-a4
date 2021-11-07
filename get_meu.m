function [action, eu_help, eu_hint] = get_meu(prNeedHelp, prRead)

% default value
action = 'None';

% compute the expected utility of each action.
eu_none = 0;
eu_help = prNeedHelp * util_help(2) + ...
          (1 - prNeedHelp) * util_help(1);
eu_hint = prRead * util(2) + ...
    (1 - prRead) * util(1);

% override default if helping is a better action
if eu_help > eu_none && eu_help > eu_hint
  action = 'Help';
elseif eu_hint > eu_none
  action = 'Hint';      
end