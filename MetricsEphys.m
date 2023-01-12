function [Output_variances, Output_var_sig, Output_var_noise, Output_avgPeak, Output_spikeRate] = MetricsEphys (Processed,timings)
%Timings should be in datapoints. In an array with pairs in each row
%representing beginning and end time, for Median_signal, Median_noise,
%Ulnar_signal, Ulnar_noise, Radial_signal, Radial_noise.
%Calculates variances, for RMS calculation, average peak amplitude, and
%spike rate in given periods.

clear Output;
fs=30000; %to provide spike rate in Hz

%Calculating variance for RMS of the period
Output_var_sig(1)=var(Processed(1,timings(1,1):timings(1,2)));
Output_var_noise(2)=var(Processed(1,timings(2,1):timings(2,2)));
Output_var_sig(3)=var(Processed(2,timings(3,1):timings(3,2)));
Output_var_noise(4)=var(Processed(2,timings(4,1):timings(4,2)));
Output_var_sig(5)=var(Processed(3,timings(5,1):timings(5,2)));
Output_var_noise(6)=var(Processed(3,timings(6,1):timings(6,2)));
Output_var_sig(6)=0;

%Calculating average peak height of the signal period.
%Threshold calculated from 2.5*std noise
threshold_1 = sqrt(Output_var_noise(2))*2.5;
threshold_2 = sqrt(Output_var_noise(4))*2.5;
threshold_3 = sqrt(Output_var_noise(6))*2.5;

[pks1,locs] = findpeaks(Processed(1,timings(1,1):timings(1,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_1);
Output_avgPeak(1)=mean(pks1);
Output_spikeRate(1)=numel(pks1)/((timings(1,2)-timings(1,1))/fs);
[pks2,locs] = findpeaks(Processed(2,timings(3,1):timings(3,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_2);
Output_avgPeak(3)=mean(pks2);
Output_spikeRate(3)=numel(pks2)/((timings(3,2)-timings(3,1))/fs);
[pks3,locs] = findpeaks(Processed(3,timings(5,1):timings(5,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_3);
Output_avgPeak(5)=mean(pks3);
Output_spikeRate(5)=numel(pks3)/((timings(5,2)-timings(5,1))/fs);


Output_var_sig=Output_var_sig';
Output_var_noise=Output_var_noise';
Output_avgPeak=Output_avgPeak';
Output_spikeRate=Output_spikeRate';
Output_variances=Output_var_sig+Output_var_noise;

% [pks1,locs] = findpeaks(Processed(1,timings(7)*30000:timings(8)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_1);
% Output_avgPeak(10)=mean(pks1);
% Output_spikeRate(10)=numel(pks1)/(timings(8)-timings(7));
% [pks2,locs] = findpeaks(Processed(2,timings(7)*30000:timings(8)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_2);
% Output_avgPeak(11)=mean(pks2);
% Output_spikeRate(11)=numel(pks2)/(timings(8)-timings(7));
% [pks3,locs] = findpeaks(Processed(3,timings(7)*30000:timings(8)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_3);
% Output_avgPeak(12)=mean(pks3);
% Output_spikeRate(12)=numel(pks3)/(timings(8)-timings(7));
% 
% [pks1,locs] = findpeaks(Processed(1,timings(9)*30000:timings(10)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_1);
% Output_avgPeak(13)=mean(pks1);
% Output_spikeRate(13)=numel(pks1)/(timings(10)-timings(9));
% [pks2,locs] = findpeaks(Processed(2,timings(9)*30000:timings(10)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_2);
% Output_avgPeak(14)=mean(pks2);
% Output_spikeRate(14)=numel(pks2)/(timings(10)-timings(9));
% [pks3,locs] = findpeaks(Processed(3,timings(9)*30000:timings(10)*30000),'MinPeakDistance',15,'MinPeakHeight',threshold_3);
% Output_avgPeak(15)=mean(pks3);
% Output_spikeRate(15)=numel(pks3)/(timings(10)-timings(9));

%Plot Processed with peaks as well for checking purposes
figure
findpeaks(Processed(1,timings(1,1):timings(1,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_1);
figure
findpeaks(Processed(2,timings(3,1):timings(3,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_2);
figure
findpeaks(Processed(3,timings(5,1):timings(5,2)),'MinPeakDistance',15,'MinPeakHeight',threshold_3);
