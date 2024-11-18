% script for making a schedule for MRF ASL
% the events happen in this order:
% deatime - pcasl - pcasl_pld - prep1 - prep1 _pld - prep2 -prep2_pld-readout
% 
% the TYPE codes for the pcasl, prep1 and prep2 types are defined in the epic
% code as
%   1: label/selective 
%   0: control/non-selective
%   -1: nothing during specified duration
% 

% desired frame TR
TR = 5

% PCASL duration and post delay
pcld = 1.8; 
pcpld = 1.8;

% vsasl pulse 1 duration and post delay
p1_ld = 0;
p1_pld = 0;

% vsasl pulse 2 duration and post delay
p2_ld = 0.0274;
p2_pld = 0;

% assumed duration of the readout.
% may need to adjust in applications
ro_time = 0.03*8;

% deadtime calculation to maintain TR
d0 = TR - pcld - pcpld - p1_ld - p1_pld - p2_ld - p2_pld - ro_time

% Create the schedule table for the time series using above constants
%
% Number of frames
Nframes = 32;

total_scantime = 0;

pcasl_type = ones(Nframes,1);
pcasl_type(1:2:end) = 0;

pcasl_duration = ones(Nframes,1)*pcld;
total_scantime = total_scantime + sum(pcasl_duration);

pcasl_pld = linspace(0.1, 2, Nframes/4)';
pcasl_pld = repmat(pcasl_pld,1,4)';
pcasl_pld = pcasl_pld(:);

total_scantime = total_scantime + sum(pcasl_pld);

vs1_type = -ones(Nframes,1);

vs1_ld = ones(Nframes,1) *p1_ld;
vs1_pld = ones(Nframes,1)*p1_pld;
total_scantime = total_scantime + sum(vs1_ld);
total_scantime = total_scantime + sum(vs1_pld);

vs2_type = ones(Nframes,1);

vs2_ld = ones(Nframes,1) *p2_ld;
vs2_pld = ones(Nframes,1)*p2_pld;
total_scantime = total_scantime + sum(vs2_ld);
total_scantime = total_scantime + sum(vs2_pld);

deadtime = TR - pcasl_duration - pcasl_pld - vs1_ld - vs1_pld - vs2_ld - vs2_pld;
total_scantime = total_scantime + sum(deadtime);


schedule = [deadtime pcasl_type pcasl_duration pcasl_pld vs1_type vs1_pld vs2_type vs2_pld]

save mrf_schedule.txt schedule -ascii

total_scantime = total_scantime + ro_time;
