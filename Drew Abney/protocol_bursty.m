%This protocol estimates burstiness and memory (using 'acf.m') from
%onset events collected by head-mounted cameras on two infants
%in the first year of life. 
%Contact: Drew Abney (dhabney@indiana.edu)

%1. Estimate burstiness and memory for hand events
%2. Estimate burstiness and memory for face events
%3. Estimate burstiness and memory for periodic-ish signal
%4. Estimate burstiness and memory for random signal
%5. Plot IEI distributions and Burstiness/Memory space


%1. Estimate burstiness and memory for hand events
ts_hand=csvread('p_hand.csv');

%Index onsets in spike train 
ix_hand=find(ts_hand');

%Compute IEI distribution of onsets  
iei_hand=diff(ix_hand);

%Adjust IEI as per sample rate (1/5 Hz)
iei_hand=iei_hand*5;

%Estimate Burstiness (as per Goh & Barabasi)
burstiness_hand=(std(iei_hand)-mean(iei_hand))/(std(iei_hand)+mean(iei_hand));

%Estimate Memory (lag-1 ACF)
memory_hand=acf(iei_hand',1);



%2. Estimate burstiness and memory for face events
ts_face=csvread('p_face.csv');

%Index onsets in spike train 
ix_face=find(ts_face');

%Compute IEI distribution of onsets  
iei_face=diff(ix_face);

%Adjust IEI as per sample rate (1/5 Hz)
iei_face=iei_face*5;

%Estimate Burstiness (as per Goh & Barabasi)
burstiness_face=(std(iei_face)-mean(iei_face))/(std(iei_face)+mean(iei_face));

%Estimate Memory (lag-1 ACF)
memory_face=acf(iei_face',1);



%3. Simulate periodic-ish signal 
a = 95;b = 105; r = (b-a).*rand(100,1) + a;
iei_periodic=round(r);

%Estimate Burstiness (as per Goh & Barabasi)
burstiness_periodic=(std(iei_periodic)-mean(iei_periodic))/(std(iei_periodic)+mean(iei_periodic));

%Estimate Memory (lag-1 ACF)
memory_periodic=acf(iei_periodic,1);



%4. Simulate random (poisson process) signal 
mu = 1;  
iei_random = exprnd(mu,100,1);
   
%Estimate Burstiness (as per Goh & Barabasi)
burstiness_random=(std(iei_random)-mean(iei_random))/(std(iei_random)+mean(iei_random));

%Estimate Memory (lag-1 ACF)
memory_random=acf(iei_random,1);



%5. Plot IEI distributions and Burstiness/Memory space

subplot(1,3,1)
hist(iei_hand,50)
title('IEI Distribution for Hand Events')
xlabel('IEI (seconds)')
ylabel('Count')
xlim([0 3000])
ylim([0 100])

subplot(1,3,2)
hist(iei_face,50)
title('IEI Distribution for Face Events')
xlabel('IEI (seconds)')
ylabel('Count')
xlim([0 3000])
ylim([0 100])

subplot(1,3,3)
scatter(memory_hand,burstiness_hand, 'b')
hold on 
scatter(memory_face,burstiness_face,'r')
scatter(memory_periodic,burstiness_periodic,'c')
scatter(memory_random,burstiness_random,'k')

title('Burstiness/Memory Space')
xlabel('Memory')
ylabel('Burstiness')
xlim([-1 1])
ylim([-1 1])
legend('Hand Events','Face Events','Periodic', 'Random')

%6. Great job!
