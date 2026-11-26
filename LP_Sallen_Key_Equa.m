pkg load symbolic

syms Vi Vo VA VB K s
syms R1 R2 C positive %

% Equações da análise nodal
eq_ganho = Vo == K * VB;
eq_A     = (Vi - VA)/R1 == (VA - VB)/R2 + (VA - K*VB)*s*C;
eq_B     = (VA - VB)/R2 == VB*s*C;

% Resolve o sistema
sol = solve([eq_ganho, eq_A, eq_B], [VA, VB, Vo]);

% Função de transferência H(s) = Vo / Vi
H = simplify(sol.Vo / Vi);

% Extrai numerador e denominador e pega os coeficientes em s: [a2, a1, a0]
[num, den] = numden(H);
c = coeffs(expand(den), s, 'all');

a2 = c(1);
a1 = c(2);
a0 = c(3);

% Forma canônica (dividindo tudo por a2 para deixar s^2 com coeficiente 1)
H_canonica = simplify(num / a2) / collect(expand(den / a2), s)

% Parâmetros do filtro: s^2 + (w0/Q)*s + w0^2
w0_quadrado = simplify(a0 / a2)
w0_sobre_Q  = simplify(a1 / a2);
Q           = simplify(sqrt(w0_quadrado) / w0_sobre_Q)
