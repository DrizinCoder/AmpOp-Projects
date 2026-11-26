pkg load symbolic

syms Vin Vo VA VB K s
syms R1 R2 C positive

eq_ganho = Vo == K * VB;
eq_A     = (Vin - VA)*s*C == (VA - K*VB)/R2 + (VA - VB)*s*C;
eq_B     = (VA - VB)*s*C == VB/R1;

sol = solve([eq_ganho, eq_A, eq_B], [VA, VB, Vo]);
H   = simplify(sol.Vo / Vin)

% Extrai numerador e denominador
[num, den] = numden(H);

% Coeficientes do denominador em s: [a2, a1, a0]
c = coeffs(expand(den), s, 'all');
a2 = c(1);
a1 = c(2);
a0 = c(3);

% Forma canônica (s^2 com coeficiente 1)
H_canonica = simplify(num / a2) / collect(expand(den / a2), s)

% Parâmetros do filtro: s^2 + (w0/Q)*s + w0^2
w0_quadrado = simplify(a0 / a2)
w0_sobre_Q  = simplify(a1 / a2);
Q           = simplify(sqrt(w0_quadrado) / w0_sobre_Q)
