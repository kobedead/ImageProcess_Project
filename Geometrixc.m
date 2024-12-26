clear
%chunk0 = load('Ballenwerper_sync_380fps_006.npychunk_0.mat');
%chunk1 = load('Ballenwerper_sync_380fps_006.npychunk_0 (1).mat');
%chunk2 = load('Ballenwerper_sync_380fps_006.npychunk_2.mat');
%chunk3 = load('Ballenwerper_sync_380fps_006.npychunk_3.mat');
%chunk4 = load('Ballenwerper_sync_380fps_006.npychunk_4.mat');
%chunk5 = load('Ballenwerper_sync_380fps_006.npychunk_5.mat');
%chunk6 = load('Ballenwerper_sync_380fps_006.npychunk_6.mat');
chunk7 = load('Ballenwerper_sync_380fps_006.npychunk_7.mat');
%chunk8 = load('Ballenwerper_sync_380fps_006.npychunk_8.mat');
%chunk9 = load('Ballenwerper_sync_380fps_006.npychunk_9.mat');
 
%%
%videoD1 = cat(1, chunk0.video_data, chunk1.video_data, chunk2.video_data, chunk3.video_data , chunk4.video_data);
%VideoD2 = cat(1,chunk5.video_data, chunk6.video_data, chunk7.video_data, chunk8.video_data, chunk9.video_data);

videoTest = cat(1,chunk7.video_data);


%select video
video = videoTest ; %%ifstatement do


numFrames = length(video(:,1,1)); % Total number of frames

listPosMotorArm = zeros(1, numFrames); % Preallocate the list with zeros
listPosBottomArm = zeros(1, numFrames); % Preallocate the list with zeros

for f = 1 : length(video(:,1,1))

    subplot(2, 2 ,1)
    
    frame = video(f,:,:);
    frame = squeeze(frame);

    %maybe use grayscale dilation!

    AdjustedIm = imadjust(frame,[0 1],[0 1], 0.18);
    
    imshow(frame)
    hold on 

   
    
    %now to find the static middelpoint of the machine(motor axis)
    %Point Middle (manual)
    pointMiddle = [898, 936];
    plot(pointMiddle(1,1), pointMiddle(1,2), "or")



    %now we can search for the bottom right static joint 
    % Point Bottom (manual)
    pointBottomR = [1354, 1537];
    plot(pointBottomR(1,1), pointBottomR(1,2), "or")
    
    


    %now we can find the left joint of the arm by searching for circles and
    %checking the distance from the motor axis wich will be static

    %big circles (on the arm)
    [centers, radii, metric] = imfindcircles(AdjustedIm,[21 50], 'ObjectPolarity','dark'  , 'EdgeThreshold',0.13 , 'Method', 'TwoStage', 'Sensitivity',0.92 );
    %show circles
    viscircles(centers, radii,'EdgeColor','b');
    

    %distance mid -> p1 : 263.0245 (manual)
    
    minDistanceP1mid = 255 ; 
    maxDistanceP1mid = 268;

    leftJoint = GetPoint(pointMiddle , centers , minDistanceP1mid , maxDistanceP1mid);


    %now to search the right joint on the arm by finding the distance to
    %the bottom static point 
    %distance = 577.0915

    minDistance = 570; 
    maxDistance = 583;

    rightJoint = GetPoint(pointBottomR , centers , minDistance , maxDistance);



    %distance between 2 joints should be 488 (manual)
    
    %now to plot some lines 
    %from center to left joint
    plot([pointMiddle(1),leftJoint(1)],[pointMiddle(2),leftJoint(2)],'Color','r','LineWidth',2);
    
    %from bottom to right joint
    plot([pointBottomR(1),rightJoint(1)],[pointBottomR(2),rightJoint(2)],'Color','b','LineWidth',2);
    
    %between the 2 joints
    plot([leftJoint(1),rightJoint(1)],[leftJoint(2),rightJoint(2)],'Color','b','LineWidth',2);






    % Bereken hoeken
    % Berekenen hoek tussen middle en left joint
    listPosMotorArm(f) = CalculateAngle(pointMiddle, leftJoint);

    % Berekenen hoek tussen middle en right joint
    listPosBottomArm(f) = CalculateAngle(pointMiddle, rightJoint);



    %calculate a mask around the arm (geometrical)
    height = 400 ;
    widht = 1700 ; 
    mask = GeoMask(rightJoint , leftJoint , height , widht , frame);  
    frameWithMask = frame ;
    frameWithMask(mask==0) = 0 ; 



        
    %point on right side of arm (not good)
    frameB = frame;
    frameB(frame>100) = 0;
    frameB = imbinarize(frameB);
    
    s = regionprops(frameB);
    Area = cat(1, s.Area); 
    Center = cat(1 , s.Centroid);

    


   
    %plot angle dynamically
    subplot(2,2,3)

    plot(1:length(listPosMotorArm), listPosMotorArm, '-o', 'LineWidth', 2, 'MarkerSize', 3);

    xlabel('Frames'); 
    ylabel('Hoek (graden)')
    title('Position'); 
    grid on;
    ylim([0, 360]); % y-as van 0 tot 360 graden 

    drawnow

end
%%

%als de loop gedaan is hebben we een list met alle posities, hier kunnen we
%slechte data uitfilteren en speed bepalen 

listPosition1 = load("Position(0-4).mat");
listPosition2 = load("Position(5-9).mat");
listPosition = [listPosition1.listPosition listPosition2.listPosition];


listPosition1 = load("PosBottomArm(0-4).mat");
listPosition2 = load("PosBottomArm(5-9).mat");
%listPosition = [listPosition1.listPosBottomArm listPosition2.listPosBottomArm];


%plot original angles
figure,  plot(1:length(listPosition), listPosition, '-o', 'LineWidth', 2, 'MarkerSize', 3);

%process
[speedPerSec, positions] = GetSpeed(listPosition) ;

    
 
    %plot processed angle

    % Frame-rate en tijd per frame in ms
    frames_per_second = 380;
    tijd_per_frame = 1000 / frames_per_second;  % Tijd per frame in ms (2.6316 ms per frame)
    tijden_video_ms = (1:length(listPosition)) * tijd_per_frame;  % Tijd in ms voor elk frame
        
 
    % plot angle + csv angle

    % CSV file - Position
    data = readmatrix('Dataset encoder 1.csv');  
    tijden_csv = 25:24025;  % 25 = begin data, 24025 is ongeveer 1 cyclus
    graden_csv = data(tijden_csv, 8);    % 8ste kolom is positie
    tijden_csv_ms = data(tijden_csv, 1); % 1e kolom is tijd in ms

    figure, plot(tijden_video_ms, positions, '-or', 'LineWidth', 1, 'MarkerSize', 3);
    hold on;
    plot(tijden_csv_ms, graden_csv, 'b', 'LineWidth', 1);
    
    % Labels en titel
    xlabel('Tijd (ms)');
    ylabel('Hoek (graden)');
    title('Position');
    grid on;
    ylim([0, 360]); 
    legend('Video Angle', 'CSV Angle');

    hold off;
   
    %plot speed
    
    %plot speed + csv speed

    % CSV file - Position
    data = readmatrix('Dataset encoder 1.csv');  
    tijden_csv = 25:24025;  % 25 = begin data, 24025 is ongeveer 1 cyclus
    snelheid_csv = data(tijden_csv, 10);    % 10e kolom is positie
    tijden_csv_ms = data(tijden_csv, 1); % 1e kolom is tijd in ms

    figure, plot(tijden_video_ms, speedPerSec, '-or', 'LineWidth', 1, 'MarkerSize', 3);
    hold on;
    plot(tijden_csv_ms, snelheid_csv, 'b', 'LineWidth', 1);
    
    % Labels en titel
    xlabel('Tijd (ms)');
    ylabel('Speed (graden/sec)');
    title('Speed');
    grid on;
     ylim([-2000, 2000]);
    legend('Video Speed', 'CSV Speed');

    hold off;

