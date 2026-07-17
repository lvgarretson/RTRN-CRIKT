%[text] This function adds a better formatted legend to the graphs automatically. It only gets the different zones as input.
%[text] 
function legends = graph_legend(zones)
    % Convert input to a string array 
    zones_str = string(zones);
    
    % Replace underscores with spaces
    legends = replace(zones_str, "_", " ");
end

%[appendix]{"version":"1.0"}
%---
