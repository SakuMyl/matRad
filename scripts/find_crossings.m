function crossings_x = find_crossings(x, y, level)
    % Find crossings of signal y at level
    crossings_x = [];
    
    for i = 2:length(y)
        if (y(i-1) <= level && y(i) >= level) || (y(i-1) >= level && y(i) <= level)
            % Linear interpolation to find crossing point
            crossing_x = interp1([y(i-1) y(i)], [x(i-1) x(i)], level);
            
            % Find the nearest data point to the crossing point
            [~, nearest_index] = min(abs(x - crossing_x));
            nearest_y = y(nearest_index);
            
            crossings_x = [crossings_x, nearest_y];
        end
    end
end