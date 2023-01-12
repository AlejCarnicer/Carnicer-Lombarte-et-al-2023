function [ISI_vector] = ISI_custom(Processed, Ch_proximal, Ch_distal, T_range1, T_range2,threshold,Timepoints);

%Uses loop to go through Processed in a similar fashion to treshold but
%keeping only event markers (i.e. logic goes to 1 on spike above/below
%threshold). Note this is adjusted to only trigger once on crossing a
%threshold, on rise/drop through it. So watch out for saturation - if
%signals don't ever drop below threshold no new event marker is laid down.

%This is combined with a cross-correlatino function to generate spike
%coincidence. This in turn is grouped in bins.




fs=30000;
n=size(Processed,1); %Number of channels to analyse
Abs_Processed=abs(Processed); %Generates absolute value of array for marker
                %Currently unused as only detecting positive peaks. If this
                %needs to be changed, sub Processed for Abs_Processed
                %below.

Processed_proximal = Processed(Ch_proximal,T_range1:T_range2);
Processed_distal = Processed(Ch_distal,T_range1:T_range2);

%%
%Uses find peak maxima to find peaks, for both Ch prox and dist

[pks,locs_prox] = findpeaks(Processed_proximal,'MinPeakDistance',15,'MinPeakHeight',threshold);
[pks,locs_dist] = findpeaks(Processed_distal,'MinPeakDistance',15,'MinPeakHeight',threshold);

%Goes through each peak position in array (locs_prox) and searches for closest
%peak in array (locs_dist). Either positive or negative. 

i=1;
while i <= size(locs_prox,2)
    locs_difference = locs_dist-locs_prox(i);
    locs_abs = abs(locs_difference);

    %Breaks into two (negative and positive).
    locs_neg=locs_difference(locs_difference<=0);
    locs_pos=locs_difference(locs_difference>=0);
    min_neg=max(locs_neg);
    min_pos=min(locs_pos);
    
    %Adds the minimum value, by checking whether the negative one or the
    %positive one is closest to zero. Checks that none are empty (e.g. if
    %there are no spikes on second channel before/after checked spike)
    if or(isempty(min_neg),isempty(min_pos))

    elseif abs(min_neg) < min_pos
        ISI_vector_1(i) = min_neg;
    else
        ISI_vector_1(i) = min_pos;
    end

    i=i+1;
end

%%
%Now runs the same but in reverse (searches for proximity peaks from distal
%in proximal)

i=1;
while i <= size(locs_dist,2)
    locs_difference = locs_prox-locs_dist(i);
    locs_abs = abs(locs_difference);

    %Breaks into two (negative and positive).
    locs_neg=locs_difference(locs_difference<=0);
    locs_pos=locs_difference(locs_difference>=0);
    min_neg=max(locs_neg);
    min_pos=min(locs_pos);
    
    %Adds the minimum value, by checking whether the negative one or the
    %positive one is closest to zero. Checks that none are empty (e.g. if
    %there are no spikes on second channel before/after checked spike)
    if or(isempty(min_neg),isempty(min_pos))

    elseif abs(min_neg) < min_pos
        ISI_vector_2(i) = min_neg;
    else
        ISI_vector_2(i) = min_pos;
    end

    i=i+1;
end

%Concatenate both vectors. Before that, the distal vector needs to be
%flipped, as it is going backwards with respect to proximal one.

ISI_vector_2 = ISI_vector_2*-1;
ISI_vector = horzcat(ISI_vector_1,ISI_vector_2);

%%
%Plot histogram of ISI

binedges = [-58.5:3:58.5];

histogram(ISI_vector,binedges);
xlim([-60 60]);

%Change axes to ms
set(gca,'XTick',-60:30:60)
set(gca,'XTickLabel',-(60*1000)/fs:(30*1000)/fs:(60*1000)/fs);

xlabel('Delay (ms)');
ylabel('Spike count');

line([0 0],[0 10],'Color','red')
set(gcf,'position',[200 200 270 400])


