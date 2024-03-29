function [fitresult, gof] = createFit(name, time, T)
%CREATEFIT(TIME,T)
%  Create a fit.
%
%  Data for 'exponentialfit2' fit:
%      X Input : time
%      Y Output: T
%  Output:
%      fitresult : a fit object representing the fit.
%      gof : structure with goodness-of fit info.
%
%  See also FIT, CFIT, SFIT.

%  Auto-generated by MATLAB on 04-Dec-2018 03:12:44


%% Fit: 'exponentialfit1'.
[xData, yData] = prepareCurveData( time, T );

% Set up fittype and options.
ft = fittype( 'exp2' );
opts = fitoptions( 'Method', 'NonlinearLeastSquares' );
opts.Display = 'Off';
opts.StartPoint = [0.0387644974933427 -0.326121646398407 7.48941916840333e-06 0.436801128024846];

% Fit model to data.
[fitresult, gof] = fit( xData, yData, ft, opts );

% Plot fit with data.
figure( 'Name', 'exponentialfit2' );
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

title('T (�C) vs. time, 2nd order exponential model')
legend( h, textleg, eq, 'Location', 'NorthEast' );
txt1 = ['SSE = ', num2str(gof.sse)];
txt2 = ['R^2 = ', num2str(gof.rsquare)];
text(0.2,2,txt1)
text(0.2,1,txt2)

% Label axes
xlabel 't (s)'
ylabel 'T (�C)'
axis([0 time(end) 0 inf])
grid on


