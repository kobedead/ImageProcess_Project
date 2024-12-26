function [speedPerSec , listPosition] = GetSpeed(listPosition)

speedPerSec = zeros(1, length(listPosition)); % Preallocate the list with zeros
speedPerSec(1) = 0;
for i = 2:length(listPosition)
    speedPerFrame = (listPosition(i) - listPosition(i-1));

    %check eerst of speed niet te groot, dan foute meting 
    if(abs(speedPerFrame) > 20 && i>302)
        %vanaf i kan fout zijn dus 
        amount = 1 ;
        j = i ;

        while(abs(speedPerFrame) > 20)
            fprintf("%f , %f   \n", i  , listPosition(i) )
            badpointsIndex(j-i+1) = j;
            speedPerFrame = (listPosition(i-1) - listPosition(j) );
            j = j + 1 ;
            amount = amount + 1 ;
        end
        %interpolatie to get good values
        goodpointsIndex = [i-1 j];
        goodpointsValue = [listPosition(i-1) , listPosition(j)];
        vq = interp1(goodpointsIndex, goodpointsValue, badpointsIndex, 'linear');
        listPosition(badpointsIndex) = vq;
        badpointsIndex = 0;

        speedPerFrame = (listPosition(i) - listPosition(i-1));
    end

    %als frame = 1/360 seconde dan 
    speedPerSec(i) = speedPerFrame*360;
        
end
end

