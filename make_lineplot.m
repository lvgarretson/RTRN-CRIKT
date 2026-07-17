%[text] Here we define a function that makes scatter plots. This code gets an input for the time frame, the data you want to plot, and the different areas in the gym where the sensors are. It returns a graph with each area in different colors, the graph does not contain x or y labels, a title, and a colorbar. Those things can be added after the function has been called.
function plot_labels = make_lineplot(ax, time, data, zones_Gym, safe_threshold)

    if nargin < 5
        safe_threshold = []; 
    end
    
    groups = categorical(zones_Gym);
    unique_groups = categories(groups);

    hold(ax, 'on');

    % Loops locations, cleans them, and plots exactly ONE line per area
    for i = 1:numel(unique_groups)
        % Find rows that belong to the zone
        zone_mask = (groups == unique_groups{i});
    
        % Gets data for zone
        zone_time = time(zone_mask);
        zone_data  = data(zone_mask);
    
        % CLEANING DATA UP
        % Removes missing values
        missing_idx = isnan(zone_data) | isnan(zone_time);
        zone_time(missing_idx) = [];
        zone_data(missing_idx)  = [];
    
        % really strong filtering cuts the values using the mean of multiple values
        [unique_times, ~, idx] = unique(zone_time);
        mean_data = accumarray(idx, zone_data, [], @mean);
    
        % Smooths the line
        mean_data = smoothdata(mean_data, "movmean", SmoothingFactor=0.3);
           
        % Plots line
        plot(ax, unique_times, mean_data, 'LineWidth', 2);
    end

    % Process the clean legend names
    plot_labels = graph_legend(unique_groups);

    % Draw the threshold line exactly once at the end if provided
    if ~isempty(safe_threshold)
        x_limits = xlim(ax);
        plot(ax, x_limits, [safe_threshold, safe_threshold], 'r--', 'LineWidth', 1.5);
        plot_labels = [plot_labels; "Safe Threshold"]; % Append to legend list
    end

    hold(ax, 'off');
end


%[appendix]{"version":"1.0"}
%---
