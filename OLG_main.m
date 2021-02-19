clc
clear
close all

syms k_tplus1
syms x

% Solve equation 3x^2 - 4x + 2 = 8
equation1 = 3 * x^2 - 4 * x + 2 == 8;

% method 1: solve
method1_solution_x = solve(equation1, x);

% method 2: vpasolve
method2_solution_x = vpasolve(equation1, x);


% method 3: fsolve with two different iteration starting points
method3_solution_x = [];
initial1 = 0;
initial2 = 100;
method3_solution_x(1, 1) = fsolve(@func, initial1);
method3_solution_x(2, 1) = fsolve(@func, initial2);
clc

% display solutions
str1 = sprintf('With "solve" method, the first root is %.4g.', ...
    method1_solution_x(1, 1));
str2 = sprintf('With "solve" method, the second root is %.4g.', ...
    method1_solution_x(2, 1));
disp(str1);
disp(str2);
fprintf('\n');

str3 = sprintf('With "vpasolve" method, the first root is %.4g.', ...
    method2_solution_x(1, 1));
str4 = sprintf('With "vpasolve" method, the second root is %.4g.', ...
    method2_solution_x(2, 1));
disp(str3);
disp(str4);
fprintf('\n');

str5 = sprintf(...
    'With "fsolve" method and a starting point at 0, the root is %.4g.', ...
    method3_solution_x(1, 1));
str6 = sprintf(...
    'With "fsolve" method and a starting point at 100, the root is %.4g.', ...
    method3_solution_x(2, 1));
disp(str5);
disp(str6);
fprintf('\n');

%% Field

% CES weights
alpha = 0.2;

% CES elasticity of substitution
e = 0.95;

% initial capital level if t = 0
k_t = 1;

% rate of time preference
theta = 0.8;

% coefficient of relative risk aversion
rho = 0.03;

% population growth
n = 0.1;

% period (1 period is approximately 30 years)
period = 3;

%% Find the capital of next period and contruct capital accumulation path
consumption_firstPeriod = [];
consumption_secondPeriod = [];
capital_vector = [];
capital_vector(1, 1) = k_t;
time = linspace(1, period, period);

for i = 1 : period
    
    % Constructor
    r_t = F_prime(alpha, e, k_t);
    w_t = F(alpha, e, k_t) - k_t * F_prime(alpha, e, k_t);
    
    equation2 = k_tplus1 - ...
        ((saving(F_prime(alpha, e, k_tplus1), theta, rho) / (1 + n)) * w_t);
    solution_k_tplus1 = vpasolve(equation2, k_tplus1);
    
    % Consumption of the two periods
    c1 = (1 - ...
        saving(F_prime(alpha, e, solution_k_tplus1), theta, rho)) * w_t;
    c2 = (1 + ...
        F_prime(alpha, e, solution_k_tplus1)) * (w_t - c1);
    
    % Store Values
    if i < period
        capital_vector(1, i + 1) = solution_k_tplus1;
    end
    consumption_firstPeriod(1, i) = c1;
    consumption_secondPeriod(1, i) = c2;
    
    k_t = solution_k_tplus1;
end

% Steady State
str7 = sprintf('The capital level at the steady state is %.4sg.', ...
    capital_vector(1, length(capital_vector)));
disp(str7);
str8 = sprintf(...
    'The first period consumption level at the steady state is %.4sg.', ...
    consumption_firstPeriod(1, length(consumption_firstPeriod)));
disp(str8);
str9 = sprintf(...
    'The second period consumption level at the steady state is %.4sg.', ...
    consumption_secondPeriod(1, length(consumption_secondPeriod)));
disp(str9);

figure(1)
subplot(3, 1, 1);
plot(time, capital_vector);
title('Capital Transition Path')
legend('k_t')
xlabel('Time')
ylabel('Capital')

subplot(3, 1, 2);
plot(time, consumption_firstPeriod);
title('First Period Consumption Transition Path')
legend('c_{1,t}')
xlabel('Time')
ylabel({'First Period', 'Consumption'})

subplot(3, 1, 3);
plot(time, consumption_secondPeriod);
title('Second Period Consumption Transition Path')
legend('c_{2,t+1}')
xlabel('Time')
ylabel({'Second Period', 'Consumption'})