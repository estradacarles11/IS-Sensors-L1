function probetimeconstant(name, time, T, ambient)


T = T*1000;

figure( 'Name', 'rawdata' );
p = plot(time,T);

textleg = join(['Data from ',name]);
title('T (ºC) vs. t (s)')
legend( p, textleg,'Location', 'NorthEast' );
xlabel 't (s)'
ylabel 'T (ºC)'
axis([0 time(end) -inf inf])
grid on



%Normalize to 0ºC end temperature
T = T-mean(T(end-10:end));

%Eliminate setup time
underamb = find(T<ambient);
T = T(underamb(1):end);
time = time(1:end-underamb(1)+1);

%Find time to reach 37% of initial temperature
under37 = find(T<0.37*max(T));
time37 = time(under37(1));

%Several pairs
second = find(time>1);
maxval = floor(length(time)/second(1));

tt = zeros(maxval,1);
TT = zeros(maxval,1);
for i = 1:maxval
    tt(i) = time(i*second(1));
    TT(i) = T(i*second(1));
end
tau = zeros(maxval-1,1);
fails=0;
for i = 2:maxval
    t1 = tt(i-1);
    T1 = TT(i-1);
    t2 = tt(i);
    T2 = TT(i);
    tdif = t2-t1;
    Tratio = T2/T1;
    if Tratio == 1
        fails=fails+1;
    else
        tau(i-1-fails) = tdif/log(1/Tratio);
    end
end
ind = tau == real(tau);
tau = tau(ind(:,1),:);
tau(tau==0) = [];
arbitrary = mean(tau);

% 90%-10%
t90 = find(T<0.9*max(T));
t10 = find(T<0.1*max(T));
t1 = time(t90(1));
T1 = T(t90(1));
t2 = time(t10(1));
T2 = T(t10(1));
tdif = t2-t1;
Tratio = T2/T1;
ninetyten = tdif/log(1/Tratio);

%Linearization of log(T)
Tpos = find(T<0);
Tlog = T(1:Tpos(1)-1);
Tlog = log(Tlog);
linear_range = find(Tlog<(max(Tlog)-max(Tlog)/3));
Tlog = Tlog(1:linear_range(1));
timelog = time(1:linear_range(1));
[fitresult, gof] = linearfit(name, timelog,Tlog);
coeffslin=coeffvalues(fitresult);
logs = -1/coeffslin(1);

%Fit to 1st order exponential
[fitresult, gof] = exponentialfit1(name,time,T);
coeffs1=coeffvalues(fitresult);
exp1 = -1/coeffs1(2);

%Fit to 2nd order exponential
[fitresult, gof] = exponentialfit2(name,time,T);
coeffs2=coeffvalues(fitresult);
deriv0=coeffs2(1)*coeffs2(2)+coeffs2(3)*coeffs2(4);
graphical_est = -(coeffs2(1)+coeffs2(3))/deriv0;
exp2 = -1/coeffs2(2);

%Display results
disp('a)Graphical or numerical estimation of the initial slope of the response:')
disp('From the derivadtive of the second order exponential approximation:')
disp(num2str(graphical_est))
disp('b)Determination of the time at which the response reaches the 37% of its initial value:')
disp(num2str(time37))
disp('c)Measurement of two arbitrary temperature-time pairs (T1,t1;T2,t2):')
disp('Times:')
disp(tt)
disp('Temperatures:')
disp(TT)
disp('Tau:')
disp(tau)
disp('Average:')
disp(num2str(arbitrary))
disp('d)Measurement of the fall time between 90% and 10% of the variation range:')
disp(num2str(ninetyten))
disp('e)Linearization of the temperature-time curve using the logarithm function and estimation of tau using linear regression:')
disp(num2str(logs))
disp(' ')
disp('Exponential fitting of the temperature curve:')
disp(num2str(exp1))
end
