# Module 2: Tapping into the temporal structure of developmental data using burstiness analysis

With the MATLAB demo script, you can perform the burstiness analysis on spike trains of events. 

Start MATLAB and select the folder where the provided material (M-functions and data file) is located. That is, make MATLAB’s current folder equal to the folder to which you downloaded this (e.g. ‘C:\...\My Documents’). After this you can call these functions on the command line.

You can easily run the demo script by typing in 'demo_burstiness' into the command line.

Below, we go through the important lines of code in the demo script. 


1. Load in spike train for hand events (line 14)
```
ts_hand=csvread('p_head.csv')
```

2. Find (i.e., index) where in the 'ts_hand' the events occur
```
ix_hand=find(ts_hand')
```

3. Compute interevent interval distribution (IEI) of event onsets
```
iei_hand=diff(ix_hand);
```

4. Adjust IEI as per sample rate (1/5 Hz)

```
iei_hand=iei_hand*5;
```


5. Estimate the burstiness metric from the IEI distribution
```
burstiness_hand=(std(iei_hand)-mean(iei_hand))/(std(iei_hand)+mean(iei_hand));
```

6. Subsequent lines of code run the analysis for the face events in addition to simulating periodic and random (Poisson process generating from an exponential distribution) IEI distributions. 