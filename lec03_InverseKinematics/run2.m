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

% Початкове положення основи роботу
x0=5;
y0=5;
% Розмір сегментів
l1=2;
l2=2;

%  Полігон для коллізій
poly= [6,4;6,6;8,6;8,4];
iscollision=zeros(360,360);

%Програма руху
program=[0 0
     45 -90
     60 -90
     80 -130
     50 -130
     30 -90
     45 -90
     0 0
];

program=[program;-program]

t10=program(1,1);
t20=program(1,2);

% Робот-імітатор
[pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t10,t20,l1,l2);
track_fake_x=pos_fake_x(:)';
track_fake_y=pos_fake_y(:)';

% Підготовка графіки
figure(1)
ax=gca();
axis equal;
fill(poly(:,1),poly(:,2),'c')
axis([-1,11,-1,11]);
grid on;


% Зображення робота
h_fake_robot=line(ax,
            "xdata",pos_fake_x,...
            "ydata",pos_fake_y,...
            "LineWidth",2,...
            "Color",[0.5,0.5,0.5],...
            "Marker","o");


% Лінія траектрії руху
h_track_s1_fake=line(ax,...
            "xdata",track_fake_x(:,2),...
            "ydata",track_fake_y(:,2),...
            "LineWidth",.5,...
            "Color",[.5,0.5,0.5]);
h_track_s2_fake=line(ax,...
            "xdata",track_fake_x(:,3),...
            "ydata",track_fake_y(:,3),...
            "LineWidth",2,...
            "Color",[1.0,0,0]);


% Відпрацювання програми руху
printf("Start simulation\n");
% Кількість проміжних точок програми, для згладжування
pause;

Npoint = 10;
for np=1:(size(program,1)-1)*Npoint,
  pause(0.05);
  % Зміщення позиції
  t1 = interp1([1:size(program,1)],program(:,1),1+np/Npoint);
  t2 = interp1([1:size(program,1)],program(:,2),1+np/Npoint);
  % Розрахунок положення
  [pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t1,t2,l1,l2);
  %Збереження траекторії
  track_fake_x=[track_fake_x;pos_fake_x(:)'];
  track_fake_y=[track_fake_y;pos_fake_y(:)'];


  % Модифікація графіки
  set(h_fake_robot,"xdata",pos_fake_x,"ydata",pos_fake_y);
  set(h_track_s1_fake,...
      "xdata",track_fake_x(:,2),...
      "ydata",track_fake_y(:,2));
  set(h_track_s2_fake,...
      "xdata",track_fake_x(:,3),...
      "ydata",track_fake_y(:,3));

endfor

figure(2)
clf();
subplot(2,2,1)
plot(track_fake_x(:,2),...
     track_fake_y(:,2),...
     "LineWidth",2,...
     "Color",[.5,0.5,1.0],...
      track_fake_x(:,3),...
      track_fake_y(:,3),...
      "LineWidth",2,...
      "Color",[1.0,0,0]);
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


pause
disp("Start collision");
pause
iscollision=zeros(360,360);
[pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t10,t20,l1,l2);

for t1=1:1:360,
  for t2 = 1:1:360,
    [pos_fake_x,pos_fake_y] = fakerobot(x0,y0,t1,t2,l1,l2);
    iscollision(t1,t2) = inpolygon (pos_fake_x(end), pos_fake_y(end), poly(:,1),poly(:,2));
  endfor
  disp(t1,"/360");
endfor

figure(3)
imshow(iscollision);
set(gca,'Ydir','normal')
grid on;
axis on;

