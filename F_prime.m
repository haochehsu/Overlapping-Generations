function myFunction = F_prime(alpha, elasticity, k2)
myFunction = 1/elasticity * (alpha * k2^elasticity + (1 - alpha))^(1/elasticity - 1) * elasticity * alpha * k2^(elasticity - 1);
end