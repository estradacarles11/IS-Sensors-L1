function [fitresult, gof] = createFit(name, timelog, Tlog)
%CREATEFIT(TIMELOG,TLOG)
%  Create a fit.
%
%  Data for 'linearfit' fit:
%      X Input : timelog
%      Y Output: Tlog
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-Dec-2018 05:10:09


%% Fit: 'linearfit'.
[xData, yData] = prepareCurveData( timelog, Tlog );

% Set up fittype and options.
ft = fittype( 'poly1' );

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft );

% Plot fit with data.
figure( 'Name', 'linearfit' );
h = plot( fitresult, xData, yData );

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

textleg = join(['Data from ',name]);
title('ln(T) vs. t (s)')
legend( h, textleg, eq, 'Location', 'NorthEast' );
txt1 = ['SSE = ', num2str(gof.sse)];
txt2 = ['R^2 = ', num2str(gof.rsquare)];
text(0.05,min(Tlog)+0.1,txt1)
text(0.05,min(Tlog)+0.05,txt2)
% Label axes
xlabel 't (s)'
ylabel 'ln(T)'
axis([0 timelog(end) -inf inf])
grid on


