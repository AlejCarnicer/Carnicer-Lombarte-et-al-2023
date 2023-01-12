function [Coefficient_vector_motor, Coefficient_vector_sensory] = Correlation_coefficient (Trace_distal, Trace_proximal, T_range1, T_range2);
%Function to check correlation coefficient between two traces
%Trace_proximal and Trace_distal, between the time ranges T_range1 and 2
%(note these are in datapoints, so multiply time by fs=30000 to get these
%(or check plot trace). 
%Outputs the correlation coefficients vectors fwd and bkwd. These
%represent efferent (motor) and afferent (sensory) respectively.
%Currently uses only positive component of trace provided (max, in lines
%17-18). Suggested to combine this with min, or seek other options to use a
%larger portion of dataset in future.


Trace1 = Trace_proximal;
Trace2 = Trace_distal;

T_range1 = T_range1;
T_range2 = T_range2;

CorrTrace1 = Trace1(T_range1:T_range2);
CorrTrace2 = Trace2(T_range1:T_range2);

%CorrTrace1 = max(CorrTrace1,0);
%CorrTrace2 = max(CorrTrace2,0);

Correl_Coefficient = corrcoef(CorrTrace1,CorrTrace2);

Coefficient_vector_fwd(1) = Correl_Coefficient(1,2);
Coefficient_vector_bkwd(1) = Correl_Coefficient(1,2);

n = 120;

d = 0.002; %distance between longitudinal electrodes, in m
fs = 30000; %sampling frequency
Data_delayDP = [0:1:(n-1)]; %conversion of data point delay to velocity
Data_delayMS = (Data_delayDP*1000)/fs;
Speed_conv = rdivide((0.002*fs),Data_delayDP);
%Speed_conv(1)=100;

xx=0;
while xx < n;
    T_range1_delay = T_range1-xx;
    T_range2_delay = T_range2-xx;
    CorrTrace_delay2 = Trace2(T_range1_delay:T_range2_delay);
    Correl_Coefficient = corrcoef(CorrTrace1,CorrTrace_delay2);
    Coefficient_vector_fwd(1+xx) = Correl_Coefficient(1,2);
    xx=xx+1;
end

plot(Data_delayMS,Coefficient_vector_fwd);
hold on

xx=0;
while xx < n;
    T_range1_delay = T_range1+xx;
    T_range2_delay = T_range2+xx;
    CorrTrace_delay2 = Trace2(T_range1_delay:T_range2_delay);
    Correl_Coefficient = corrcoef(CorrTrace1,CorrTrace_delay2);
    Coefficient_vector_bkwd(1+xx) = Correl_Coefficient(1,2);
    xx=xx+1;
end


plot(-Data_delayMS,Coefficient_vector_bkwd);

xlabel('Signal delay (ms)')
ylabel('Correlation coefficient')
ylim([-0.2 0.2])
xlim([-2 2])
legend('Motor','Sensory','Location','northeast')
line([0 0], [-100,100],'Color','k')
set(gcf,'position',[200 200 270 600])


figure 
semilogx(Speed_conv,Coefficient_vector_fwd);
hold on
semilogx(Speed_conv,Coefficient_vector_bkwd);


xlabel('Conduction velocity (m/s)')
ylabel('Correlation coefficient')
xlim([1 70])
legend('Motor','Sensory','Location','southeast')
set(gcf,'position',[500 200 270 600])

Coefficient_vector_motor = Coefficient_vector_fwd;
Coefficient_vector_sensory = Coefficient_vector_bkwd;