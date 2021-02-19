function F = F(alpha, elasticity, k1)
F = (alpha * k1^elasticity + (1 - alpha))^(1 / elasticity);
end