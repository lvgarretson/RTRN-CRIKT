%[text] This function follows the formula provided by the US EPA to return the AQI. The value is the reading from the sensor. The break\_points are top values for each range of measurements and the aqi\_range is the associated aqi score.
function aqi_num = AQI_math(value, break_points, aqi_range)
    
    % This checks the limits
    if value <= break_points(1)
        aqi_num = aqi_range(1);
        return;
    elseif value >= break_points(end)
        aqi_num = aqi_range(end);
        return;
    end
    
    % Identifies in what range value
    aqi_area = discretize(value, break_points);
    
    % Gets max and min of the range value
    bp_min = break_points(aqi_area);
    bp_max = break_points(aqi_area + 1);
    
    aqi_min = aqi_range(aqi_area);
    aqi_max = aqi_range(aqi_area + 1);
    
    % Math
    proportional_factor = (aqi_max - aqi_min) / (bp_max - bp_min);
    aqi_num = proportional_factor * (value - bp_min) + aqi_min;
end
%[text] 

%[appendix]{"version":"1.0"}
%---
