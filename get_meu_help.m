function [action, eu_help] = get_meu_help(prNeedHelp)

% default value
action = 'None';

% compute the expected utility of each action.
eu_none = 0;
eu_help = prNeedHelp * util_help(2) + ...
          (1 - prNeedHelp) * util_help(1);

% override default if helping is a better action
if eu_help > eu_none
  action = 'Help';
end