function [angle] = CalculateAngle(point1,point2)
% Calculates the angle between 2 points
%   The 0° angle is pointed downwards 

% vector van motor center naar moving point
dx = point2(1) - point1(1);
dy = point2(2) - point1(2);
    
% hoek berekenen via atan2
theta_deg = rad2deg(atan2(dy, dx)); 

% Aanpassen zodat 0 naar beneden is + wrap rond 360°
angle = mod((theta_deg + 270), 360); 
end