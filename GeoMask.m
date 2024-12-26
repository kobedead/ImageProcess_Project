function [mask] = GeoMask(rightJoint,leftJoint , height , widht , frame)


    disBetween = sqrt((rightJoint(1)-leftJoint(1))^2 + (rightJoint(2) - leftJoint(2))^2);


 %first we will try to create a recktangle around the main arm, to do so
    %well first rotate the arm so the line between the 2 joints are
    %parallel to the x-axi

    % Calculate the angle of rotation
    dx = rightJoint(1) - leftJoint(1);
    dy = rightJoint(2) - leftJoint(2);
    theta = atan2(dy, dx);

    % Rotation matrix for -theta
    R = [cos(-theta), -sin(-theta); sin(-theta), cos(-theta)];
    
    %get points parallel to x-axis 
    rotLeftJoint = R * transpose(leftJoint) ;
    rotRightJoint = R *transpose(rightJoint);
    
    %now we can calculate recktangle around the arm 
    bottomleft = rotLeftJoint;          
    bottomleft(1) = bottomleft(1) - (widht-disBetween)/2;
    bottomleft(2) = bottomleft(2) + height/6 ; 
    
    topleft = bottomleft;
    topleft(2) = bottomleft(2) - height;
        

    topright = rotRightJoint;
    topright(1) = topright(1) + (widht-disBetween)/2;
    topright(2) = topright(2) - 5*height/6;


    bottomright = topright;                 %geo arm
    bottomright(2) = bottomright(2) + height - 100 ;


    rotRightJoint(2) = rotRightJoint(2) + 50 ;

    %matrix to rotate back
    R_t = transpose(R);

    %convert back
    topleft = R_t * topleft;
    bottomleft = R_t * bottomleft;
   
    topright = R_t * topright;
    bottomright = R_t * bottomright ; 

    rightJoinHelp = R_t * rotRightJoint ;
    
    reckAroundArm =  [ topright(1)  topright(2)  ; bottomright(1)  bottomright(2) ; rightJoinHelp(1) rightJoinHelp(2) ; bottomleft(1) bottomleft(2) ; topleft(1)  topleft(2) ];
    
    [col, row] = size(frame);
    mask = poly2mask(reckAroundArm(:,1) , reckAroundArm(:,2) ,col , row);







end

