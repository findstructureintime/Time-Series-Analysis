%This protocol utilizes two .m files 'allanplotter2.m'
%and 'allanfactor.m' to estimate AF functions for hand and face
%onset events collected by head-mounted cameras on two infants
%in the first year of life. 
%Contact: Drew Abney (dhabney@indiana.edu)

%1. Estimate AF function for hand events
%2. Estimate AF function for face events
%3. Plot AF functions

%1. Estimate AF function for hand events
ts_af_hand=csvread('p_hand.csv');

%Input data (spike train, sample rate (s))
[a_hand b_hand]=allanplotter2(ts_af_hand,5)

%Estimate linear fit 
p=polyfit(log(b_hand), log(a_hand), 1);
slope_hand=p(1)

%Estimate quadratic fit
p2=polyfit(log(b_hand), log(a_hand), 2);
quadratic_hand=p2(1);


%2. Estimate AF function for face events
ts_af_face=csvread('p_face.csv');

%Input data (spike train, sample rate (s))
[a_face b_face]=allanplotter2(ts_af_face,5)
  
%Estimate linear fit 
p_face=polyfit(log(b_face), log(a_face), 1);
slope_face=p_face(1)

%Estimate quadratic fit
p2_face=polyfit(log(b_face), log(a_face), 2);
quadratic_face=p2_face(1);


%3. Plot AF functions (in loglog) 
subplot(2,2,1)
plot(ts_af_hand,'b')
title('Spike Train for Hand Events','fontsize',18)

subplot(2,2,3)
plot(ts_af_face,'r')
title('Spike Train for Face Events','fontsize',18)

subplot(2,2,[2,4])
loglog(b_hand,a_hand,'b','LineWidth',2);
hold on
loglog(b_face,a_face,'r','LineWidth',2);
title('AF Functions for Hand and Face Events','fontsize',18)
xlabel('Window Size T(sec)','fontsize',18)
ylabel('Allan Factor A(T)','fontsize',18)
legend('Hand Events','Face Events')

%4. Great job!





