function [Processed_events, Coincidence_events,  Coincidence_grouped, Bad_coincidence] = Thresholding_markers(Processed,threshold,Timepoints,Coincidence_wiggle);

%Uses loop to go through Processed in a similar fashion to treshold but
%keeping only event markers (i.e. logic goes to 1 on spike above/below
%threshold). Note this is adjusted to only trigger once on crossing a
%threshold, on rise/drop through it. So watch out for saturation - if
%signals don't ever drop below threshold no new event marker is laid down.

%Coincidence_wiggle indicates the number of datapoints by which a peak can
%vary in time and still be considered to coincide. Note that 1 point = 1/fs
%= 1/30000

%Outputs coincidence events (how many time each peak is repeated, and
%coincidence grouped (data from which bar graph is created, but per
%channel). Also outputs Bad_coincidence: how many spikes have been
%determined to coincide too many times (i.e. more than there are channels),
%as a fraction of total spike events.
%This must be low, if it becomes high, wiggle is too high or threshold is
%too low. May aim for badly sorted percent < 5%

%Processed_events=NaN(size(Processed,1),size(Processed,2));
%pks=NaN(size(Processed,1),size(Processed,2)); %Used only to dump unused output
fs=30000;
n=size(Processed,1); %Number of channels to analyse
Abs_Processed=abs(Processed); %Generates absolute value of array for marker
                %Currently unused as only detecting positive peaks. If this
                %needs to be changed, sub Processed for Abs_Processed
                %below.

%%
%Previous version used "logic" events calculated per timepoint when
%threshold exceeded. As a result, marker lied on threshold crossing, not on
%maxima.

% i=1;
% i2=1;
% while i2 <= size(Abs_Processed,1)
%     while i <= size(Abs_Processed,2)  
%      if  Abs_Processed(i2,i) < threshold
%         Processed_events(i2,i) = 0;
%      elseif  i==1 && Abs_Processed(i2,i) > threshold;
%              Processed_events(i2,i) = 1;
%      elseif  Abs_Processed(i2,i-1) > threshold && Abs_Processed(i2,i) > threshold;
%              Processed_events(i2,i) = 0;
%      elseif  Abs_Processed(i2,i-1) < threshold && Abs_Processed(i2,i) > threshold;
%              Processed_events(i2,i) = 1;
%      end
%         i=i+1;
%     end
%     i=1;
%     i2=i2+1;
% end

%%
%Uses find peak maxima to find peaks.
%Min peak distance can be adjusted to cover more or less width. Currently
%only selects peak with more than 0.5ms separation (30k sampling rate)

i=1;
while i <= size(Processed,1)
    [pks,locs] = findpeaks(Abs_Processed(i,:),'MinPeakDistance',15,'MinPeakHeight',threshold);
    Processed_events(i,1:size(locs,2)) = locs;
    i=i+1;
end

Processed_events(Processed_events==0) = NaN;



%%
%Plot figures
%Ylim can also be changed here (or a forced value removed altogether)

L = length(Processed); %Used to remap X axis in figures to seconds
Lsmol= L/fs; 

Timepoints_datapoints=Timepoints*fs; %Converts datapoints back from seconds to datapoint
Timepoints_datapoints(2,:)=Timepoints_datapoints; %Prepares array to add vertical lines for timepoints

Fig = figure('Name','Filtered data');
xx=1;
while (xx<=n)
    h=subplot(n,1,xx);
    line([Processed_events(xx,:)',Processed_events(xx,:)'],[0 1],'Color','black')
    set(gca,'XTick',0:round(Lsmol/10)*fs:L)
    set(gca,'XTickLabel',0:round(Lsmol/10):Lsmol)
    ylim([-0.5 1.5]); %Set ylim to show logic events (0 and 1)
    line(Timepoints_datapoints,[-10000 10000],'Color','red','LineStyle','--')
    xx=xx+1;
end
linkaxes;
xlabel('time (s)')

%%
%Carry out coincidence detection (how many times spikes occur for a given
%channel).

i=1;
i2=1;
while i <= size(Processed_events,1);
    while i2 <= sum(~isnan(Processed_events(i,:)));
        Coincidence_events(i,i2) = sum(and(Processed_events>=Processed_events(i,i2)-Coincidence_wiggle,Processed_events<=Processed_events(i,i2)+Coincidence_wiggle),'All');
        i2=i2+1;
    end
    i2=1;
    i=i+1;
end


%Number of events coinciding a certain number of times per channel
i=1;
i2=1;
while i <= size(Processed_events,1);
    while i2 <= size(Processed_events,1);
        Coincidence_grouped(i,i2) = sum(Coincidence_events(i,:)==(size(Processed_events,1)+1-i2));
        i2=i2+1;
    end
    i2=1;
    i=i+1;
end

%Plot coincidence (adding coincidence pattern from all channels - the
%individual ones can still be found in the Coincidence_grouped output.

Fig2 = figure('Name','Coincidence detection');
bar(flip(sum(Coincidence_grouped)));
xlabel('Number of channels spike is co-detected');
ylabel('Number of spikes');

Bad_coincidence = sum(Coincidence_events>=size(Processed_events,1)+1,'All') / sum(~isnan(Processed_events),'All')

%%
%Make a second histogram, corresponding to the channel which gave rise to
%each of the 1ch spikes (i.e. uniquely recorded spikes).

Coincidence_onespike=Coincidence_events;
Coincidence_onespike(Coincidence_onespike~=1)=NaN;
Coincidence_onespike_grouped = nansum(Coincidence_onespike,2);
Fig3 = figure('Name','Unique spike recordings by channel');
bar(Coincidence_onespike_grouped);
xlabel('Channel performing unique spike recording');
ylabel('Number of spikes');




