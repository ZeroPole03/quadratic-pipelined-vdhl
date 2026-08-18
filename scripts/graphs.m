% Leer archivo generado por VHDL
data = load('salida_y.txt');  % Asume dos columnas: x y

x_vhdl = data(:,1);
y_vhdl = data(:,2);

% Coeficientes
a = -2; b = -3; c =-1;

% Calcular curva teórica
y_teorica = a*x_vhdl.^2 + b*x_vhdl + c;

% Graficar
figure;
plot(x_vhdl, y_vhdl, 'bo-', 'DisplayName', 'Simulación VHDL');
hold on;
plot(x_vhdl, y_teorica, 'r--', 'DisplayName', 'Curva Teórica');
grid on;
xlabel('x');
ylabel('y');
title('Comparación curva VHDL vs Curva Teórica');
legend('Location','best');
