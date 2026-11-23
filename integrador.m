% Parâmetros de entrada
Av = 2;           % Ganho linear do amplificador inversor na malha de feedback quando f = 0 hz (V/V)
Cf = 100e-9;      % Capacitor de feedback (integrador)
f_sinal = 1e3;    % Frequência do sinal a ser integrador

fc = f_sinal/20;  % Frequência de corte, garantindo uma região segura do integração útilde_expand

% Cálculo dos componentes
Rf = 1/(2*pi*fc*Cf);
Ri = Rf/Av;
Rp = (Ri*Rf)/(Ri+Rf);
fo = 1/(2*pi*Ri*Cf);

printf("--- Componentes do circuito ---\n\nRf -> %.3f\nRi´ -> %.3f\nRp -> %.3f\nfo -> %.3f\n", Rf, Ri, Rp, fo);

% --- Resposta em Frequência (Diagrama de Bode) ---
f = logspace(0, 5, 1000);
s = 1j * 2 * pi * f;

% Função de transferência H(s) = -Zf(s) / Ri
Zf = Rf ./ (1 + s * Rf * Cf);
H  = -Zf / Ri;

mag_dB = 20 * log10(abs(H));
fase   = rad2deg(unwrap(angle(H)));

% --- Plotagem ---
figure('Position', [100, 100, 900, 650]);

% Gráfico de Módulo (dB)
subplot(2, 1, 1);
semilogx(f, mag_dB, 'b', 'LineWidth', 2); hold on;
grid on;

y_min = min(mag_dB) - 5;
y_max = max(mag_dB) + 8;
ylim([y_min, y_max]);
xlim([min(f), max(f)]);

% Região 1: Amplificador Inversor (f <= fc)
patch([min(f) fc fc min(f)], [y_min y_min y_max y_max], ...
      [0.85 0.92 1.0], 'EdgeColor', 'none', 'FaceAlpha', 0.45);

% Região 2: Integração Útil (f >= 10*fc)
patch([10*fc max(f) max(f) 10*fc], [y_min y_min y_max y_max], ...
      [0.85 1.0 0.88], 'EdgeColor', 'none', 'FaceAlpha', 0.45);

semilogx(f, mag_dB, 'b', 'LineWidth', 2);
line([fc fc], [y_min y_max], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.2);
line([fo fo], [y_min y_max], 'Color', [0.85 0.45 0], 'LineStyle', '-.', 'LineWidth', 1.2);
line([f_sinal f_sinal], [y_min y_max], 'Color', [0 0.5 0], 'LineStyle', '--', 'LineWidth', 1.5);

text(3, y_max - 4, 'Amplificador Inversor', 'FontWeight', 'bold', 'Color', [0 0.2 0.6]);
text(2e3, y_max - 4, 'Região de Integração (-20 dB/déc)', 'FontWeight', 'bold', 'Color', [0 0.45 0.1]);
text(fc*1.1, y_min + 6, sprintf('f_c = %.0f Hz', fc), 'Color', 'r');
text(fo*1.1, y_min + 14, sprintf('f_o = %.0f Hz (0 dB)', fo), 'Color', [0.85 0.45 0]);
text(f_sinal*1.1, y_min + 6, sprintf('f_{sinal} = %.0f Hz', f_sinal), 'Color', [0 0.5 0], 'FontWeight', 'bold');

ylabel('Ganho |H(jf)| (dB)');
title('Resposta em Frequência do Integrador Prático');

% Gráfico de Fase (Graus)
subplot(2, 1, 2);
semilogx(f, fase, 'm', 'LineWidth', 2); hold on;
grid on;
ylim([80, 190]);
xlim([min(f), max(f)]);

patch([min(f) fc fc min(f)], [80 80 190 190], ...
      [0.85 0.92 1.0], 'EdgeColor', 'none', 'FaceAlpha', 0.45);
patch([10*fc max(f) max(f) 10*fc], [80 80 190 190], ...
      [0.85 1.0 0.88], 'EdgeColor', 'none', 'FaceAlpha', 0.45);

semilogx(f, fase, 'm', 'LineWidth', 2);
line([fc fc], [80 190], 'Color', 'r', 'LineStyle', '--', 'LineWidth', 1.2);
line([f_sinal f_sinal], [80 190], 'Color', [0 0.5 0], 'LineStyle', '--', 'LineWidth', 1.5);

text(fc*1.1, 145, '135° (em f_c)', 'Color', 'r');
text(f_sinal*1.1, 102, sprintf('%.1f° (em f_{sinal})', interp1(f, fase, f_sinal)), 'Color', [0 0.5 0], 'FontWeight', 'bold');

xlabel('Frequência (Hz)');
ylabel('Fase (graus)');
