%[text] This functions help load the datafiles for the app.
% Load all data into the base workspace
fprintf('Loading datasets, please wait...\n');
air_reference = readtable("Data/air_quality_reference.csv");
sensor_location = readtable("Data/air_quality_sensor_locations.csv");

% Loads MAT files and extracts their interior contents
co2_data = load("Data/co2_concentration.mat");
temp_data = load("Data/temperature_humidity.mat");
vent_data = load("Data/ventilation_system_status.mat");
voc_data = load("Data/voc_concentration.mat");

% Packs everything into a single structure
appData = struct(...
    'air_reference', air_reference, ...
    'sensor_location', sensor_location, ...
    'co2', co2_data.co2_concentration, ...
    'temp', temp_data.temperature_humidity, ...
    'vent', vent_data.ventilation_system_status, ...
    'voc', voc_data.voc_concentration ...
);

% Launches the welcome screen and passes the loaded data structure
fprintf('Starting Chirp AQI...\n');
welcome_app = welcome(appData);


%[appendix]{"version":"1.0"}
%---
%[metadata:view]
%   data: {"layout":"onright","rightPanelPercent":19.8}
%---
