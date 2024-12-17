
%chunk0 = load('Ballenwerper_sync_380fps_006.npychunk_0.mat');
%chunk1 = load('Ballenwerper_sync_380fps_006.npychunk_0 (1).mat');
chunk2 = load('Ballenwerper_sync_380fps_006.npychunk_2.mat');
chunk3 = load('Ballenwerper_sync_380fps_006.npychunk_3.mat');
chunk4 = load('Ballenwerper_sync_380fps_006.npychunk_4.mat');
%chunk5 = load('Ballenwerper_sync_380fps_006.npychunk_5.mat');
%chunk6 = load('Ballenwerper_sync_380fps_006.npychunk_6.mat');
%chunk7 = load('Ballenwerper_sync_380fps_006.npychunk_7.mat');
%chunk8 = load('Ballenwerper_sync_380fps_006.npychunk_8.mat');
%chunk9 = load('Ballenwerper_sync_380fps_006.npychunk_9.mat');
 

%video = cat(1, chunk0, chunk1, chunk2, chunk3, chunk4, chunk5, chunk6, chunk7, chunk8, chunk9);
video = cat(1 , chunk2.video_data , chunk3.video_data , chunk4.video_data);


disp(length(video(:,1,1)))

for i = 1 : length(video(:,1,1))
    
    frame = video(i,:,:);
    frame = squeeze(frame);

    %maybe use grayscale dilation!
    framead =imadjust(frame,[0 1],[0 1], 0.18);
   
    imshow(frame)
    hold on 

   
    %big circles (on the arm)
    [centers, radii, metric] = imfindcircles(framead,[20 50], 'ObjectPolarity','dark'  , 'EdgeThreshold',0.2 , 'Method', 'TwoStage', 'Sensitivity',0.9 );

    viscircles(centers, radii,'EdgeColor','b');
    
    %smaller points (on the base)
    [centersH, radiiH, metricH] = imfindcircles(framead,[10 20], 'ObjectPolarity','dark'  );
    
    %get the lowest 2 points
    help = find(centersH(:,2) > 1300);
    lowpoints = centersH(help , :);
    viscircles(lowpoints, radiiH(help),'EdgeColor','g');
    
    
    %distance between them 
    %distanceBetween = sqrt((lowpoints(1,1)-lowpoints(2,1))^2+(lowpoints(1,2)-lowpoints(2,2))^2); 
    plot([lowpoints(1,1),lowpoints(2,1)],[lowpoints(1,2),lowpoints(2,2)],'Color','r','LineWidth',2);



    %for points of the arm
    
    p1 = [0 0];
    p2 = [0 0];
    if (length(centers)>2)
        for i = 1 : length(centers)
            for j = 1 : length(centers)
                dis = sqrt((centers(i,1)-centers(j,1))^2+(centers(i,2)-centers(j,2))^2);
                if((489 < dis) &&(dis < 493))
                    p1 = centers(i,:);
                    p2 = centers(j,:);
                    break
                end
            end
        end
    end

    %standerdize direction ig 
    if(p1(1) < p2(1) )
        %point 1 is on the left
    else 
        ptussen = p1 ;
        p1 = p2;
        p2 = ptussen;
    end

    

    
    plot([p1(1),p2(1)],[p1(2),p2(2)],'Color','r','LineWidth',2);

    %vector P2P1
    vecP2P1 = [p1(1)-p2(1)  p1(2)-p2(2)];
    vecP2P1 = vecP2P1/norm(vecP2P1);
    %center of line (ongeveer)
    center = p2+vecP2P1*488/2;
    %plot center of line
    viscircles(center,10)


    %point on right side of arm 
    frameB = frame;
    frameB(frame>100) = 0;
    frameB = imbinarize(frameB);
    
    s = regionprops(frameB);
    Area = cat(1, s.Area); 
    Center = cat(1 , s.Centroid);

    

    big = Center((Area>100 & Area <10000 ),:);
    p3=0;
    for i = 1:length(big)
        dis = sqrt((big(i,1)-p2(1,1))^2+(big(i,2)-p2(1,2))^2); %should be 493.9777
        if (493 < dis) && (dis < 494.9)
            p3 = big(i,:);
            plot([p2(1),p3(1)],[p2(2),p3(2)],'Color','r','LineWidth',2);

        end
    end




    hold off

    pause(0.00001)
end

%%
frame = video_data(150,:,:);
frame = squeeze(frame);


framead =imadjust(frame,[0 1],[0 1], 0.2);


figure, imshow(frame)
figure, imshow(framead)

hold on 

%bigger points (on the arm)
[centers, radii, metric] = imfindcircles(framead,[20 50], 'ObjectPolarity','dark'  );
viscircles(centers, radii,'EdgeColor','b');

%smaller points (on the base)
[centersH, radiiH, metricH] = imfindcircles(framead,[10 20], 'ObjectPolarity','dark'  );

%get the lowest 2 points
help = find(centersH(:,2) > 1300);
lowpoints = centersH(help , :);
viscircles(lowpoints, radiiH(help),'EdgeColor','g');


%distance between them 
distanceBetween = sqrt((lowpoints(1,1)-lowpoints(2,1))^2+(lowpoints(1,2)-lowpoints(2,2))^2); 
plot([lowpoints(1,1),lowpoints(2,1)],[lowpoints(1,2),lowpoints(2,2)],'Color','r','LineWidth',2)


p1 = [0 0];
p2 = [0 0];
for i = 1 : length(centers)
    for j = 1 : length(centers)
        dis = sqrt((centers(i,1)-centers(j,1))^2+(centers(i,2)-centers(j,2))^2);
        if((488 < dis) &&(dis < 495))
            p1 = centers(i,:);
            p2 = centers(j,:);
            break
        end
    end
end

%standerdize direction ig 
if(p1(1) < p2(1) )
    %point 1 is on the left
else 
    ptussen = p1 ;
    p1 = p2;
    p2 = ptussen;
end

%line between them
plot([p1(1),p2(1)],[p1(2),p2(2)],'Color','r','LineWidth',2)
%vector P2P1
vecP2P1 = [p1(1)-p2(1)  p1(2)-p2(2)];
vecP2P1 = vecP2P1/norm(vecP2P1);
%center of line (ongeveer)
center = p2+vecP2P1*488/2;
%plot center of line
viscircles(center,10)




%found the 2 circels that are on the main stick

%COnStick = [centersStrong5(1,:) ;centersStrong5(3,:)];

%nu om de afstand tussen de 2 te berekenen zodat men 'altijd' de 2 punten kan
%vinden en koppelen

%distanceBetween = sqrt((COnStick(1,1)-COnStick(2,1))^2+(COnStick(1,2)-COnStick(2,2))^2); 

% = 491.7979


%try to create a recktangular mask around the arm
heightR = 300;
widthR = 1700-500; %500 is space between the points 

%the shape has more hight above the points than above so no /2

if(p1(1) < p2(1) )
    %point 1 is on the left
else 
    ptussen = p1 ;
    p1 = p2;
    p2 = ptussen;
end

%p1 is on the left 

vecP2P1 = [p1(1)-p2(1)  p1(2)-p2(2)];
vecP2P1 = vecP2P1/norm(vecP2P1);

vectorPerUp = vecP2P1;


point = p1 + vecP2P1*widthR/2;
%point2 = point + vectorPerUp*heightR*3/4 ;
%point3 = point - vectorPerUp*heightR/4;

%points = [point ; point2 ; point3];

viscircles(point,10)

plot(point,'.')

%%


centerint = int32(center);
yea = RegGrow(frame , 20 , centerint);

imshow(yea)























