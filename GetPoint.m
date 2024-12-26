function [point] = GetPoint(comparePoint , points , minDis , maxDis)
 
    point = [0 0];
    if (length(points)>1)
        for i = 1 : length(points)
            dis = sqrt((comparePoint(1)-points(i,1))^2+(comparePoint(2)-points(i,2))^2);
            if((minDis < dis) &&(dis < maxDis))
               point = points(i,:);
               break
            end
        end
    end
end

