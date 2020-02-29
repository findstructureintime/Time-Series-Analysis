function demo_CRQA

% demo_CRQA loads the example data and runs the entire libabry of CRQA functions.
% 
% 

load('example_data.mat')

PlotTS(PP1,PP2)

rec = CatCRMatrix(PP1,PP2);

PlotCRP(rec)

output = CRQA_out(rec)
