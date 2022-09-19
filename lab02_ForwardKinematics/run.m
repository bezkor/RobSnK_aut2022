%
% Моделювання руху двосегментного робота
%
% Робот уявляє собою двосегментний маніпулятор,
% що рухається в вертикальній площині.
% Може виконувати 2 рухи:
% 1. Кутове зміщення на кут t1 сегменту 1 відносно основи
% 2. Кутове зміщення на кут t2 сегменту 2 відносно сегменту 1


% Початкове положення основи роботу
x0=5;
y0=5;
% Розмір сегментів
l1=3;
l2=2;
% Початкове положення
t10=45;
t20=-45;

% Програма руху платформи
% Уявляє собою матрицю розміром (N)x(2)
% де N - кількість команд (строк матриці)
% перший стовпчик - положення t1, другий стовпчик - положення t2
% Наприклад:
% [10,20] - задати положення сегментів на 10 та 20 градусів, відповідно

program=[t10 t20;
     45 45;
     90 -45;
     90 -135;
     45 -45;
];

% Запис траекторії руху для аналізу

% Робот-імітатор
[pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t10,t20,l1,l2);
track_fake_x=pos_fake_x(:)';
track_fake_y=pos_fake_y(:)';

% Робот-реал
[pos_real_x,pos_real_y] = realrobot(x0,y0,t10,t20,l1,l2);
track_real_x=pos_real_x(:)';
track_real_y=pos_real_y(:)';



% Підготовка графіки
figure(1)

ax=gca();
axis equal;
axis([-1,11,-1,11]);
grid on;

% Зображення робота
h_fake_robot=line(ax,
            "xdata",pos_fake_x,...
            "ydata",pos_fake_y,...
            "LineWidth",2,...
            "Color",[0.5,0.5,0.5],...
            "Marker","o");
h_real_robot=line(ax,
            "xdata",pos_real_x,...
            "ydata",pos_real_y,...
            "LineWidth",3,...
            "Color",[1.0,0.0,0.0],...
            "Marker","o");


% Лінія траектрії руху
h_track_s1_fake=line(ax,...
            "xdata",track_fake_x(:,2),...
            "ydata",track_fake_y(:,2),...
            "LineWidth",1,...
            "Color",[.5,0.5,0.5]);
h_track_s2_fake=line(ax,...
            "xdata",track_fake_x(:,3),...
            "ydata",track_fake_y(:,3),...
            "LineWidth",1,...
            "Color",[.5,1.0,0.5]);

h_track_s1_real=line(ax,...
            "xdata",track_real_x(:,2),...
            "ydata",track_real_y(:,2),...
            "LineWidth",2,...
            "Color",[.5,0.5,1.0]);
h_track_s2_real=line(ax,...
            "xdata",track_real_x(:,3),...
            "ydata",track_real_y(:,3),...
            "LineWidth",2,...
            "Color",[.5,1.0,0.5]);


% Відпрацювання програми руху
printf("Start simulation\n");
% Кількість проміжних точок програми, для згладжування
Npoint = 5;
for np=1:(size(program,1)-1)*Npoint,
  pause(0.25);
  % Зміщення позиції
  t1 = interp1([1:size(program,1)],program(:,1),1+np/Npoint);
  t2 = interp1([1:size(program,1)],program(:,2),1+np/Npoint);
  % Розрахунок положення
  [pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t1,t2,l1,l2);
  [pos_real_x,pos_real_y] = realrobot(x0,y0,t1,t2,l1,l2);
  %Збереження траекторії
  track_fake_x=[track_fake_x;pos_fake_x(:)'];
  track_fake_y=[track_fake_y;pos_fake_y(:)'];

  track_real_x=[track_real_x;pos_real_x(:)'];
  track_real_y=[track_real_y;pos_real_y(:)'];

  % Модифікація графіки
  set(h_fake_robot,"xdata",pos_fake_x,"ydata",pos_fake_y);
  set(h_real_robot,"xdata",pos_real_x,"ydata",pos_real_y);
  set(h_track_s1_fake,...
      "xdata",track_fake_x(:,2),...
      "ydata",track_fake_y(:,2));
  set(h_track_s2_fake,...
      "xdata",track_fake_x(:,3),...
      "ydata",track_fake_y(:,3));
  set(h_track_s1_real,...
      "xdata",track_real_x(:,2),...
      "ydata",track_real_y(:,2));
  set(h_track_s2_real,...
      "xdata",track_real_x(:,3),...
      "ydata",track_real_y(:,3));

endfor

figure(2)
clf();
subplot(2,2,1)
plot(track_real_x(:,2),...
     track_real_y(:,2),...
     "LineWidth",2,...
     "Color",[.5,0.5,1.0],...
      track_real_x(:,3),...
      track_real_y(:,3),...
      "LineWidth",2,...
      "Color",[.5,1.0,0.5]);
xlabel("x")
ylabel("y");
axis equal
grid on
subplot(2,2,2);
plot([1:size(program,1)],program(:,1))
grid on;
xlabel("N")
ylabel("Координата t1");

subplot(2,2,4);
plot([1:size(program,1)],program(:,2))
grid on;
xlabel("N")
ylabel("Координата t2");

subplot(2,2,3);
plot(program(:,1),program(:,2));
grid on;
xlabel("Координата t1");
ylabel("Координата t2");
printf("Done\n");

