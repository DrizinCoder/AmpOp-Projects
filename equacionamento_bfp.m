pkg load symbolic
syms s R R3 C K Vin VA VB wt Qt positive

C_num = 10e-9; % 10 nF
K_num = 2;     % Ganho (1 + R4/R5)

%LCK
no_a = (Vin - VA)/R == (VA - K*VB)/R + (VA - VB)*s*C;
no_b = (VA - VB)*s*C == VB/R3 + VB*s*C;

[VAs, VBs] = solve(no_b, no_a, VA, VB);

H = simplify(K*VBs/Vin);
[N, D] = numden(H);

% coeficientes de D = a2 s^2 + a1 s + a0
a2 = diff(D, s, 2)/2;
a1 = subs(diff(D, s), s, 0);
a0 = subs(D, s, 0);
b1 = diff(N, s);

w0 = simplify(sqrt(a0/a2))
Q  = simplify(w0*a2/a1)
Hp = simplify(b1/a1)

[sol_R, sol_R3] = solve([w0 == wt, Q == Qt], [R, R3]);

printf("R  = %s;\n", char(sol_R(2)));
printf("R3 = %s;\n", char(sol_R3(2)));
printf("Hp = %s;\n", char(Hp));
