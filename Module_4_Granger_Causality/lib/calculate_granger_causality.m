function [results_gcause_mat, results_gcause_fdr, results_history] = calculate_granger_causality(X, glm_time_range)
% This function computes Granger Causality (GC) for the time series contained in
%   input parameter X.
% 
% @param X -- input data that contains the time series that the user 
%           wants to perform GC computation on. 
%           It is a N*M*K matrix in which N is the number of collected time series
%           M is the length of the trial and K is the number of trials.
% 
% @param glm_time_range -- the length of the history window that will be 
%           used for prediction model fitting in GC computation. This function 
%           will generate a set of likelihood estimation models for each time 
%           series contained in X iterating through history durations from 
%           1 to glm_time_range. Then a best estimation model will be chosen 
%           from this sec of candidate models using Akaike’s information 
%           criterion (AIC) (Akaike, 1974; Burnham & Anderson, 1998).
% 
% @return results_gcause_mat -- a N*N result matrix. Result in row i
%           column j is the directional Granger Causality result from jth
%           variable to ith variable in input parameter X.
% 
% @return results_gcause_fdr -- a N*N matrix containing the significance
%           test result for every directional GC influence. The function first 
%           applies the goodness-of-fit statistics to compare the deviance 
%           between the partial estimated model with causal variable Y excluded 
%           and the full estimated full model. Then, a multiple hypothesis 
%           testing error measure, FDR (Benjamini & Hochberg, 1995; Storey, 2002) 
%           was used to control the expected proportion of false discovery rate 
%           when the number of hypothesis tests is large. 
%           Similarly, row i column j contains the test result for the GC 
%           influence from jth variable to ith variable in input parameter X. 
%           The test can result in three outputs: 1/-1/0
%               1 means that it is a significantly positive GC influence;
%               -1 means that it is a significantly positive GC influence;
%               0 means not significant.
% 
% @return results_history -- a vector of length N. This output contains the
%       chosen history window length in the rediction model fitting process 
%       for every time series variable in GC computation using AIC.
% 
% This function is part of the code packets written by Sanggyun Kim as a part of the paper: 
%   Kim, S., Putrino, D., Ghosh, S., & Brown, E. N. (2011). A Granger causality measure for point process models of ensemble neural spiking activity. PLoS computational biology, 7(3).
% 
% Tian Linger Xu (txu@iu.edu) made minor modifications to the code and
%   filled in the help documentation.

disp('Start computing granger causality...')

% Dimension of X (# Channels x # Samples x # Trials)
[CHN, SMP, TRL] = size(X);

% To fit GLM models with different history orders
window_size = 3;
for neuron = 1:CHN
    for ht = 3:3:glm_time_range                             % history, W=3ms
        %   n: index number of input (neuron) to analyze
        %  ht: model order (using AIC or BIC)
        %   w: duration of non-overlapping spike counting window
        [bhat{ht,neuron}] = glmtrial(X,neuron,ht,window_size);
    end
end

% To select a model order, calculate AIC
for neuron = 1:CHN
    for ht = 3:3:glm_time_range
        LLK(ht,neuron) = log_likelihood_trial(bhat{ht,neuron},X,ht,neuron,glm_time_range);
        aic(ht,neuron) = -2*LLK(ht,neuron) + 2*(CHN*ht/3 + 1);
    end
end

% Save results
% save(save_result_file,'bhat','aic','LLK', 'X');

% Identify Granger causality
% CausalTest;
% end

ht = nan(1, CHN);

% h = figure;
for varidx = 1:CHN
%     subplot(2, 3, varidx);
%     plot(aic(3:3:60,varidx));
    [value, index] = nanmin(aic(3:3:glm_time_range,varidx));
    ht(varidx) = index;
end

% Re-optimizing a model after excluding a trigger neuron's effect and then
% Estimating causality matrices based on the likelihood ratio
for target = 1:CHN
    LLK0(target) = LLK(3*ht(target),target);
    for trigger = 1:CHN
        % MLE after excluding trigger neuron
        [bhatc{target,trigger},devnewc{target,trigger}] = glmtrialcausal(X,target,trigger,3*ht(target),3);
        
        % Log likelihood obtained using a new GLM parameter and data, which
        % exclude trigger
        LLKC(target,trigger) = log_likelihood_trialcausal(bhatc{target,trigger},X,trigger,3*ht(target),target, glm_time_range);
               
        % Log likelihood ratio
        LLKR(target,trigger) = LLKC(target,trigger) - LLK0(target);
        
        % Sign (excitation and inhibition) of interaction from trigger to target
        % Averaged influence of the spiking history of trigger on target
        SGN(target,trigger) = sign(sum(bhat{3*ht(target),target}(ht(target)*(trigger-1)+2:ht(target)*trigger+1)));
    end
end

% Granger causality matrix, Phi
Phi = -SGN.*LLKR;
results_gcause_mat = Phi;

% ==== Significance Testing ====
% Causal connectivity matrix, Psi, w/o FDR
D = -2*LLKR;                                     % Deviance difference
alpha = 0.05;
for ichannel = 1:CHN
    temp1(ichannel,:) = D(ichannel,:) > chi2inv(1-alpha,ht(ichannel)/2);
end
Psi1 = SGN.*temp1;
results_gcause_sig = Psi1;

% Causal connectivity matrix, Psi, w/ FDR
fdrv = 0.05;
temp2 = FDR(D,fdrv,ht);
Psi2 = SGN.*temp2;
results_gcause_fdr = Psi2;

results_history = ht;