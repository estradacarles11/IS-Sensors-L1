function eq = fitresult2equation(fitresult)
% Returns the fitresult from the fitresult = fit() function into a string, 
% including the parameters.  
%
% The code is found on a matlab forum 
% Ben van Oeveren, VU Amsterdam, 2015
eq = formula(fitresult); %Formula of fitted equation
parameters = coeffnames(fitresult); %All the parameter names
values = coeffvalues(fitresult); %All the parameter values
for idx = 1:numel(parameters)
      param = parameters{idx};
      l = length(param);
      loc = regexp(eq, param); %Location of the parameter within the string
      while ~isempty(loc)     
          %Substitute parameter value
          eq = [eq(1:loc-1) num2str(values(idx)) eq(loc+l:end)];
          loc = regexp(eq, param);
      end
end
end