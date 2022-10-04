%
% Моделювання руху двосегментного робота
%
% Робот уявляє собою двосегментний маніпулятор,
% що рухається в вертикальній площині.
% Може виконувати 2 рухи:
% 1. Кутове зміщення на кут t1 сегменту 1 відносно основи
% 2. Кутове зміщення на кут t2 сегменту 2 відносно сегменту 1

clear all
close all


% Положення основи роботу
x0=5;
y0=5;
% Розмір сегментів
l1=2;
l2=2;

% Програма руху робочого органу робота
% Уявляє собою матрицю розміром (N)x(2)
% де N - кількість команд (строк матриці)
% перший стовпчик - положення x, другий стовпчик - положення y
% Наприклад:
% [6,4] - задати положення робочого органу x=6, y=4

program_position = [8,4;6,4;8,6;6,6;8,4;8,6;7,7;6,6;6,4];

% Перерахунок просторової програми у координати робота
program_angles =zeros(size(program_position));
for i = 1:size(program_position,1),
  [program_angles(i,1),program_angles(i,2)] = inverse(program_position(i,1), program_position(i,2),x0,y0,l1,l2);
endfor


% Запис траекторії руху для аналізу
t10=program_angles(1,1);
t20=program_angles(1,2);
% Робот-імітатор
[pos_x,pos_y] = forward(t10,t20,x0,y0,l1,l2);
track_x=pos_x(:)';
track_y=pos_y(:)';

% Підготовка графіки
figure(1)
ax=gca();
axis equal;
axis([-1,11,-1,11]);
grid on;

% Зображення робота
h_robot=line(ax,
            "xdata",pos_x,...
            "ydata",pos_y,...
            "LineWidth",2,...
            "Color",[0.5,0.5,0.5],...
            "Marker","o");


% Лінія траектрії руху
h_track_s1_fake=line(ax,...
            "xdata",track_x(:,2),...
            "ydata",track_y(:,2),...
            "LineWidth",.5,...
            "Color",[.5,0.5,0.5]);
h_track_s2_fake=line(ax,...
            "xdata",track_x(:,3),...
            "ydata",track_y(:,3),...
            "LineWidth",2,...
            "Color",[1.0,0,0]);

h_program = line(ax,...
            "xdata",program_position(:,1),...
            "ydata",program_position(:,2),...
            "LineWidth",2,...
            "LineStyle",":",...
            "Color",[0,1.0,0]);

% Відпрацювання програми руху
printf("Start simulation\n");
printf("Press ENTER...\n");
pause;
% Кількість проміжних точок програми, для згладжування
Npoint = 10;
for np=1:(size(program_angles,1)-1)*Npoint,
  pause(0.05);
  % Зміщення позиції
  t1 = interp1([1:size(program_angles,1)],program_angles(:,1),1+np/Npoint);
  t2 = interp1([1:size(program_angles,1)],program_angles(:,2),1+np/Npoint);
  % Розрахунок положення
  [pos_x,pos_y] = forward(t1,t2,x0,y0,l1,l2);
  %Збереження траекторії
  track_x=[track_x;pos_x(:)'];
  track_y=[track_y;pos_y(:)'];


  % Модифікація графіки
  set(h_robot,"xdata",pos_x,"ydata",pos_y);
  set(h_track_s2_fake,...
      "xdata",track_x(:,end),...
      "ydata",track_y(:,end));

endfor

figure(2)
clf();
subplot(2,2,1)
plot( track_x(:,end),...
      track_y(:,end),...
      "LineWidth",2,...
      "Color",[1.0,0,0],...
       program_position(:,1),...
       program_position(:,2),...
       "LineWidth",2,...
       "LineStyle",":",...
       "Color",[0,1.0,0]);
xlabel("x")
ylabel("y");
axis equal
grid on
subplot(2,2,2);
plot([1:size(program_angles,1)],program_angles(:,1))
grid on;
xlabel("N")
ylabel("Координата t1");

subplot(2,2,4);
plot([1:size(program_angles,1)],program_angles(:,2))
grid on;
xlabel("N")
ylabel("Координата t2");

subplot(2,2,3);
plot(program_angles(:,1),program_angles(:,2));
grid on;
xlabel("Координата t1");
ylabel("Координата t2");
printf("Done\n");

