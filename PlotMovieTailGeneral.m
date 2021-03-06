%% Parameters
Path = '/media/RED/RLS1P/Data/2018-10-31/Run 11/'
FirstFrame = 1;

%% Plot behavior (tail) with a red line
for frame = 1:size(Tail, 1)
    img = imread([Path, 'BehaviorTail/Behavior', num2str(frame-1, '%04d'), '.tif']);
    img = cat(3, img, img, img);
    figure(1)
    im2 = imshow(rescalegd2( img));
    axis off;
    hold on;
    % Plot Tail bar
    x = 103;
    y = 120;
    l = 170;
    li = line([x, x+(l*(sin(Tail.Angle(frame)*pi/180)))], [y, y+(l*(cos(Tail.Angle(frame)*pi/180)))]);
    li.Color = 'red';
    li.LineWidth = 3;
    Tail.Angle(frame);
    mkdir([Path, 'MovieTail/']);
    saveas(im2, [Path, 'MovieTail/frame', num2str(frame-1, '%04d')], 'jpg');
    clc; disp(['Frame number:' num2str(frame)]);
    pause(0.01)
end

%% Script with figure showing an animation of the tail angle
figure (2)
clf
h = animatedline('MaximumNumPoints',200);
h.LineWidth = 3;
h.Color = 'red';
xlabel('Time (s)', 'fontweight', 'bold', 'fontsize', 16);
ylabel('Tail Angle (Degree)', 'fontweight', 'bold', 'fontsize', 16);
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 16;
angle = Tail.Angle';
Time = Tail.Time';
Time = Time - Time(1);
ylim([-35 35])
mkdir([Path, 'MoviePlotTailAngle/']);

for frame = 1:size(Tail, 1)
    addpoints(h,Time(frame),angle(frame));
    drawnow
    saveas(gcf, [Path, 'MoviePlotTailAngle/frame', num2str(frame-1, '%04d')], 'jpg');
    clc; disp(['Frame number:' num2str(frame)]);
    pause(0.01)
end

%% Script with figure showing an animation of the motor angle
figure (3)
clf
h = animatedline('MaximumNumPoints',200);
h.LineWidth = 3;
xlabel('Time (s)', 'fontweight', 'bold', 'fontsize', 16);
ylabel('Motor Angle (Degree)', 'fontweight', 'bold', 'fontsize', 16);
ax = gca;
ax.FontWeight = 'bold';
ax.FontSize = 16;
angle = Feedback.e00';
Time = Feedback.e01';
Time = Time - Time(1);
ylim([-35 35])

for frame = 1:size(Feedback, 1)
    addpoints(h,Time(frame),angle(frame));
    angle(frame)
    drawnow
    saveas(gcf, [Path, 'MoviePlotMotorAngle/frame', num2str(frame-1, '%04d')], 'jpg');
    clc; disp(['Frame number:' num2str(frame)]);
    pause(0.01)
end

%% Plot Motor scheme
figure (4)
clf
for frame = 1:size(Feedback, 1)
    img = imread([Path, 'MovieMotor/Motor.png']);
    im2 = imshow(imrotate(img, angle(frame), 'crop', 'bilinear'));
    saveas(im2, [Path, 'MovieMotor/frame', num2str(frame-1, '%04d')], 'jpg');
    clc; disp(['Frame number:' num2str(frame)]);
    pause(0.01)
end
%% Plot FrontViewZF scheme
figure (5)
clf
for frame = 1:size(Feedback, 1)
    img = imread([Path, 'SchemeFrontViewZF.png']);
    im2 = imshow(imrotate(img, angle(frame), 'crop', 'bilinear'));
    saveas(im2, [Path, 'MovieFrontViewZF/frame', num2str(frame-1, '%04d')], 'jpg');
    clc; disp(['Frame number:' num2str(frame)]);
    pause(0.01)
end
