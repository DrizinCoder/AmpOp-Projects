% Parâmetros de entrada (L(s) = 1 e phi = 0 -> Barkhausen Criteria)

f = 1000;       % Frequência desejada
C = 100e-9;     % Capacitor desejado
R1 = 1000;      % Resistor para o gnd na malha de realimentação negativa

Vcc = 12;       % Tensão simétrica (+/- Vcc)
Vop = 5;        % Tensão de pico desejada na saída (V)
Vd = 0.7;       % Queda de tensão direta dos diodos

% Rf e Cálculo da ponte de Wien
Rf = R1*2.2;
R = 1/(2*pi*f*C);

% Cálculos do Limitador de Amplitude (D1/D2 + Divisores)
R4 = Rf;
R5 = R4;

R3 = R4 * (3*Vcc + Vop + 3*Vd) / (2*Vop - 3*Vd);
R6 = R3;

% Saída
printf("Valores do circuito:\n");
printf("R  (Ponte) -> %.3f Ohms\n", R);
printf("R1         -> %.3f Ohms\n", R1);
printf("Rf         -> %.3f Ohms (Av inicial = %.2f)\n", Rf, 1 + Rf/R1);
printf("R4 = R5    -> %.3f Ohms\n", R4);
printf("R3 = R6    -> %.3f Ohms (para Vop = %.2f V)\n", R3, Vop);
