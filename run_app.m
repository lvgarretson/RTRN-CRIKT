% run_app.m
% Loads data, launches the welcome app, and forces a dark UI with white text.

fprintf('Loading datasets, please wait...\n'); %[output:60e33dd4]

% Root data folder relative to run_app.m
dataRoot = fullfile(fileparts(which('run_app')), 'Data');

air_reference = readtable(fullfile(dataRoot, 'air_quality_reference.csv'));
sensor_location = readtable(fullfile(dataRoot, 'air_quality_sensor_locations.csv'));

% Loads MAT files and extracts their interior contents
co2_data = load(fullfile(dataRoot, 'co2_concentration.mat'));
temp_data = load(fullfile(dataRoot, 'temperature_humidity.mat'));
vent_data = load(fullfile(dataRoot, 'ventilation_system_status.mat'));
voc_data = load(fullfile(dataRoot, 'voc_concentration.mat'));

% Preferred theme for the app (we enforce dark UI here)
preferredTheme = "dark";

% Packs everything into a single structure
appData = struct(...
    'air_reference', air_reference, ...
    'sensor_location', sensor_location, ...
    'co2', co2_data.co2_concentration, ...
    'temp', temp_data.temperature_humidity, ...
    'vent', vent_data.ventilation_status, ...
    'voc', voc_data.voc_concentration, ...
    'preferredTheme', preferredTheme ...
);

% Launch the welcome screen and pass the data
fprintf('Starting Chirp AQI...\n'); %[output:7ce3505f]
welcome_app = welcome(appData);

% If welcome_app exposes a UIFigure, enforce dark styling and set up a short
% timer to reapply styling for UI created later (e.g., after role selection).
if ~isempty(welcome_app) && isvalid(welcome_app) && isprop(welcome_app, "UIFigure")
    try
        uifig = welcome_app.UIFigure;
        % Force manual dark theme where supported
        try
            uifig.ThemeMode = "manual";
            uifig.Theme = "dark";
        catch
            % ignore if not supported
        end

        % Apply styling immediately
        applyDarkUI(uifig);

        % Create a short-lived timer that reapplies the styling a few times
        % to catch screens created after callbacks (stops itself after done).
        t = timer( ...
            'ExecutionMode', 'fixedSpacing', ...
            'Period', 0.75, ...
            'TasksToExecute', 6, ... % runs ~4.5 seconds total
            'TimerFcn', @(~,~) safeApply(uifig), ...
            'StopFcn', @(~,~) delete(timerfind('Name','applyDarkTimer')) ...
        );
        t.Name = 'applyDarkTimer';
        start(t);
    catch
        % ignore any failures
    end
end

% -------------------------------------------------------------------------
% Local helper: safely call applyDarkUI (catch errors so timer keeps running)
function safeApply(uifig)
    try
        applyDarkUI(uifig);
    catch
        % ignore
    end
end

% -------------------------------------------------------------------------
% Local function: apply dark background and white text to a UIFigure tree
function applyDarkUI(uifig)
% applyDarkUI Force dark background and white text on a uifigure and its children.

if isempty(uifig) || ~isvalid(uifig)
    return
end

% Colors
darkBg = [0.12 0.12 0.12]; % dark background RGB
whiteColor = [1 1 1];
mutedWhite = [0.85 0.85 0.85];

% Attempt to set theme mode and theme again (no harm if unsupported)
try
    uifig.ThemeMode = "manual";
    uifig.Theme = "dark";
catch
end

% Set top-level colors where properties exist
if isprop(uifig, 'Color')
    try, uifig.Color = darkBg; end
end
if isprop(uifig, 'BackgroundColor')
    try, uifig.BackgroundColor = darkBg; end
end

% Find all descendant components and set appropriate color properties
% Use findall to include graphics and UI components
allComp = findall(uifig);
for k = 1:numel(allComp)
    c = allComp(k);
    try
        % Background-like properties
        if isprop(c, 'BackgroundColor')
            c.BackgroundColor = darkBg;
        end
        if isprop(c, 'FaceColor')                % for some graphics objects
            c.FaceColor = darkBg;
        end

        % Text color properties: set common names
        if isprop(c, 'FontColor')
            c.FontColor = whiteColor;
        end
        if isprop(c, 'Color')
            c.Color = whiteColor;
        end
        if isprop(c, 'ForegroundColor')
            c.ForegroundColor = whiteColor;
        end
        if isprop(c, 'LabelColor')               % custom controls
            c.LabelColor = whiteColor;
        end

        % For editable fields use a slightly dimmer background and white text
        if isa(c, 'matlab.ui.control.EditField') || isa(c, 'matlab.ui.control.TextArea') ...
                || isa(c, 'matlab.ui.control.NumericEditField') || isa(c, 'matlab.ui.control.DropDown')
            try
                if isprop(c, 'BackgroundColor'), c.BackgroundColor = [0.15 0.15 0.15]; end
                if isprop(c, 'FontColor'), c.FontColor = whiteColor; end
                if isprop(c, 'Color'), c.Color = whiteColor; end
            catch
            end
        end

        % Buttons and lamp labels sometimes use 'Text' child or different props
        if isa(c, 'matlab.ui.control.Button') || isa(c, 'matlab.ui.control.ButtonGroup')
            try
                if isprop(c, 'FontColor'), c.FontColor = whiteColor; end
                if isprop(c, 'BackgroundColor'), c.BackgroundColor = darkBg; end
                if isprop(c, 'Color'), c.Color = whiteColor; end
            catch
            end
        end

        % Axes-specific tweaks
        if isa(c, 'matlab.ui.control.UIAxes') || isa(c, 'matlab.graphics.axis.Axes')
            try
                if isprop(c, 'Color'), c.Color = darkBg; end
                if isprop(c, 'XColor'), c.XColor = whiteColor; end
                if isprop(c, 'YColor'), c.YColor = whiteColor; end
                if isprop(c, 'ZColor'), c.ZColor = whiteColor; end
                if isprop(c, 'GridColor'), c.GridColor = mutedWhite; end
            catch
            end
        end
    catch
        % ignore per-control failures
    end
end
end


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":19.8}
%---
%[output:60e33dd4]
%   data: {"dataType":"text","outputData":{"text":"Loading datasets, please wait...\n","truncated":false}}
%---
%[output:7ce3505f]
%   data: {"dataType":"text","outputData":{"text":"Starting Chirp AQI...\n","truncated":false}}
%---
