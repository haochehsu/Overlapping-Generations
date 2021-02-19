function s = saving(r, theta, rho)
s = (1 + r)^(1/theta -1) / ((1 + r)^(1/theta -1) + (1 + rho)^(1/theta));
end