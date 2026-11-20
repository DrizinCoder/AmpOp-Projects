graphics_toolkit("fltk");
% --- Parâmetros de projeto ---
F_sup = 6000;             % Frequência de corte superior (Hz)
F_inf = 500;              % Frequência de corte inferior (Hz)
f0 = sqrt(F_sup * F_inf); % 1732.05 Hz
wt = 2 * pi * f0;         % Frequência central alvo (rad/s)
Qt = f0 / (F_sup - F_inf);% Fator de qualidade alvo

C = 10e-9;                % 10 nF
K = 2;                    % Ganho (1 + R4/R5). Se K = 1 -> Seguidor de tensão

% --- Equações extraídas do symbolic ---
R  = 2*Qt*(4 - K)/(C*wt*(sqrt(2*K*Qt^2 - 8*Qt^2 + 1) + 1));
R3 = (sqrt(2*K*Qt^2 - 8*Qt^2 + 1) + 1)/(C*Qt*wt*(4 - K));
Hp = K*R3/(-K*R3 + R + 4*R3);

printf("R1 = R2 = %.2f Ohms\n", R);
printf("R3      = %.2f Ohms\n", R3);
printf("Hp      = %.4f (%.2f dB)\n", Hp, 20*log10(Hp));

% --- Resposta em frequência ---
f = logspace(1, 5, 1000);
s = 1j * 2 * pi * f;

H = ((K/(R*C)) * s) ./ (s.^2 + ((R + (4 - K)*R3)/(R*R3*C))*s + 2/(R*R3*C^2));
mag_dB = 20 * log10(abs(H));

figure;
semilogx(f, mag_dB, 'LineWidth', 1.8);
hold on;

corte_dB = 20*log10(Hp) - 3;
plot(xlim, [corte_dB, corte_dB], '--r', 'LineWidth', 1.2);
plot([F_inf, F_inf], ylim, '--k', 'LineWidth', 1.2);
plot([F_sup, F_sup], ylim, '--k', 'LineWidth', 1.2);

grid on;
xlabel('Frequência (Hz)');
ylabel('Magnitude (dB)');
title('Resposta em Frequência - Sallen-Key Bandpass');

% --- Análise das frequências de corte ---
w0_real = sqrt(2) / (C * sqrt(R * R3));
f0_real = w0_real / (2 * pi);
Q_real  = (sqrt(2 * R * R3)) / (R + (4 - K) * R3);

% --- A partir do desenvolvimento ---
fc_inf = f0_real * (sqrt(1 + 1/(4 * Q_real^2)) - 1/(2 * Q_real));
fc_sup = f0_real * (sqrt(1 + 1/(4 * Q_real^2)) + 1/(2 * Q_real));

printf("fc inferior = %.2f Hz\n", fc_inf);
printf("fc superior = %.2f Hz\n", fc_sup);
printf("Banda (BW)  = %.2f Hz\n", fc_sup - fc_inf);

% --- Via Gráfico ---
[pico_dB, idx_pico] = max(mag_dB);
alvo_dB = pico_dB - 3;
idx_inf = find(mag_dB(1:idx_pico) <= alvo_dB, 1, 'last');
idx_sup = find(mag_dB(idx_pico:end) <= alvo_dB, 1, 'first') + idx_pico - 1;

printf("Corte gráfico: %.2f Hz e %.2f Hz\n", f(idx_inf), f(idx_sup));
