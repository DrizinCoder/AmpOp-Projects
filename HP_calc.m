graphics_toolkit("fltk");

% --- Parâmetros de projeto (Passa-Altas 500 Hz) ---
F_c = 500;                % Frequência de corte (Hz)
C   = 100e-9;             % Capacitor de 100 nF
Rf  = 10e3;               % Resistor de realimentação (10 kOhm)
Rf2 = 10e3;               % Resistor para o terra (10 kOhm)

% --- Contas rápidas com K = 2 ---
K    = 1 + (Rf / Rf2);    % K = 2
m    = (3 + sqrt(5)) / 4; %

R1   = 1 / (2 * pi * C * F_c * sqrt(m));
R2   = m * R1;
Q    = sqrt(R1 * R2) / (2*R2 - R1);
K_dB = 20 * log10(K);
w0   = 2 * pi * F_c;

% --- Saídas no terminal ---
printf("=== DIMENSIONAMENTO SALLEN-KEY HP (Rf = Rf2) ===\n");
printf("Fc           = %.2f Hz\n", F_c);
printf("C1 = C2      = %.2f nF\n", C * 1e9);
printf("R1           = %.2f Ohms\n", R1);
printf("R2           = %.2f Ohms\n", R2);
printf("Rf = Rf2     = %.2f kOhms\n", Rf / 1e3);
printf("Q            = %.4f\n", Q);
printf("Ganho (K)    = %.2f V/V (%.2f dB)\n", K, K_dB);

% --- Resposta em frequência H(jw) ---
f = logspace(1, 5, 1000);
w = 2 * pi * f;
s = 1j * w;

num = K * (s.^2);
den = (s.^2) + (w0 / Q) * s + (w0^2);
H   = num ./ den;

mag_dB = 20 * log10(abs(H));
fase   = angle(H) * (180 / pi);

% --- Plotagem ---
figure(2);

subplot(2, 1, 1);
semilogx(f, mag_dB, 'b', 'LineWidth', 1.8);
hold on;
plot(F_c, K_dB - 3.01, 'ro', 'MarkerSize', 6, 'LineWidth', 1.5);
grid on;
title('Resposta em Frequencia - Filtro Passa-Altas Sallen-Key (2a Ordem)');
ylabel('Magnitude (dB)');
legend('Resposta |H(jw)|', sprintf('Fc = %d Hz (%.2f dB)', F_c, K_dB - 3.01), 'Location', 'southeast');

subplot(2, 1, 2);
semilogx(f, fase, 'r', 'LineWidth', 1.8);
hold on;
plot(F_c, 90, 'bo', 'MarkerSize', 6, 'LineWidth', 1.5);
grid on;
xlabel('Frequencia (Hz)');
ylabel('Fase (graus)');
legend('Fase', 'Fc (+90 graus)', 'Location', 'northeast');
