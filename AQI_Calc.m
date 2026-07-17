%[text] The official US EPA AIQ is calculated by giving the worse score after a series of calculations of different pollutants. This function does the same. It calculates the AQI sub score for voc and co2 using AQI\_math.mlx. Then it calculates the deviation from the ideal for humidity and temperature. After gathering all of those numbers it just returns the highest value obtained after all of the calculations.
%[text] The areas is the list of possible areas and the target\_zone is the one the user wants to see.
function AQI_num = AQI_Calc(temperature, co2, humidity, voc, areas, target_zone)

   
    groups = categorical(areas);

    zone_mask = (groups == target_zone);

    % Get the filtered info per area
    zone_temp = temperature(zone_mask);
    zone_temp = zone_temp(end);

    zone_co2 = co2(zone_mask);
    zone_co2 = zone_co2(end);

    zone_hum = humidity(zone_mask);
    zone_hum = zone_hum(end);

    zone_voc = voc(zone_mask);
    zone_voc = zone_voc(end);

    % CO2 Sub AQI
    bp_co2 = [400, 800, 1000, 1500, 2000, 5000];
    i_co2 = [0, 50, 100, 150, 200, 500];
    sub_co2 = AQI_math(zone_co2, bp_co2, i_co2);

    % VOC Sub AQI
    bp_voc = [0, 65, 220, 660, 1430, 2200];
    i_voc  = [0, 50, 100, 150, 200, 500];
    sub_voc = AQI_math(zone_voc, bp_voc, i_voc);

    % VOC SUB AQI (Deviation from 22 which is the middle point of the 2 temperatures
    % provided by air_quality_reference.mat)
    sub_temp = abs(zone_temp - 22) * 15;
    if sub_temp > 500, sub_temp = 500; end

    % HUmidity sub AQI (Deviation from 45% which is the middle point of the
    % 2 humidities provided by air_quality_reference.mat)
    sub_hum = abs(zone_hum - 45) * 5;
    if sub_hum > 500, sub_hum = 500; end

    %Gets the worse value from all of the data to get the AQI
    AQI_num = max([sub_co2, sub_voc, sub_temp, sub_hum]);
end
%[text] 
%[text] 

%[appendix]{"version":"1.0"}
%---
