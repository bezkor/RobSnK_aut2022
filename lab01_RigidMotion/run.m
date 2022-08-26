%
% Моделювання руху мобільної платформи
%
% Платформа уявляє собою мобільного робота (наприклад робопилососа),
% що рухається по горизонтальній площині.
% Рухома платформа може виконувати 2 типи руха:
% 1. Лінійне переміщення на деяку відстань
% 2. Доворот на певний кут


% Початкове положення платформи
x0=0;
y0=0;
% Початкова оріентація платформи
a0=0;

% Програма руху платформи
% Уявляє собою матрицю розміром (N)x(2)
% де N - кількість команд (строк матриці)
% перший стовпчик - команда, другий стовпчик - параметр
% Команди:
% 1 - зміститися вперед (в одиницях)
% 2 - повернутися на кут (в градусах)
% Наприклад:
% [1,2] - зміститися вперед на 2 одиниці
% [2,10] - повернутися на 10 градусів проти годинникової стрілки

program=[2 45;
     1 3;
     2 45;
     1 3;
     2 -45;
     1 3 ;
     2 -45;
     1 3];

% Перетворення початкових координат у гомогенний вигляд
position=[x0;y0;1];
direction = hrotmat(a0)*[1;0;1];

% Запис траекторії руху для аналізу
track = [position(1),position(2)];

% Підготовка графіки
figure(1)
clf();
ax=gca();
axis equal;
axis([-1,11,-1,11]);
grid on;
% Лінія траектрії руху
htrack=line(ax,...
            "xdata",track(:,1),...
            "ydata",track(:,2),...
            "LineWidth",2,...
            "Color",[0,1,0]);
% Зображення робота
hrobot=rectangle(ax,
             "Position",[position(1)-0.5, position(2)-0.5, 1,1],...
             "Curvature",1,...
             "FaceColor",[1,1,1],...
             "EdgeColor",[0,0,0]);
% Зображення вектору руху
hdirection=line(ax,...
             "xdata",position(1)+[0,direction(1)],...
             "ydata",position(2)+[0,direction(2)],...
             "LineWidth",2,...
             "Color",[1,0,0]);

% Відпрацювання програми руху
printf("Start simulation\n");
for np=1:size(program,1),
  pause(0.5);
  % Зміщення позиції
  if program(np,1)==1,
    position_shift=direction*program(np,2);
    position = hposmat(position_shift)*position;
    printf("Move forward %d units\n",program(np,2));
  endif
  % Поворот
  if program(np,1)==2,
    direction_angle=program(np,2);
    direction= hrotmat(direction_angle)*direction;
    printf("Rotate %d degrees\n",program(np,2));
  endif
  %Збереження нової позиції
  track = [track;position(1),position(2)];
  % Модифікація графіки
  set(hrobot,"Position",[position(1)-0.5, position(2)-0.5, 1,1]);
  set(hdirection,"xdata",position(1)+[0,direction(1)],"ydata",position(2)+[0,direction(2)]);
  set(htrack, "xdata",track(:,1), "ydata",track(:,2));
endfor
printf("Done\n");

