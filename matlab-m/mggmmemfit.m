% Marek Grzes
% University of Waterloo, 2011
% ---

function [ obj ] = mggmmemfit(X, num_clusters, debug_mode, show_graph, noisy_init)
%MGGMMEMFIT Learing Gaussian Mixtures using the EM algorithm.
%   This function is implemented according to Ch. Bishop's book Pattern
%   recognition and machine learning. Section 9.2 very well describes
%   learning GMM with the EM algorithm. Pseudo-code from page 438 is used
%   in this implementaiton.
%   Fits a Gaussian mixture distribution with K components to the data in X.
%   X is an N-by-D matrix. Rows of X correspond to observations; columns
%   correspond to variables.
%   @param debug_mode 0 - no debugging information printed; 1 - print debug
%   values
%   @param show_graph 0 - no ploting of the current model; 1 - plot current
%   model after each iteration
%   @param noisy_init 0 - initialistion from kmeans; 1 - initialisation
%   from kmeans but randomly disturbed in order to have worse initial model
%   @return gm object is returned (gmdistribution.fit returns an object of the
%   same class).

% (*) This is how GMM/EM can be done using Matlab functions
matlab_obj = 0;
if (debug_mode == 1)
    options = statset('Display','final');
    matlab_obj = gmdistribution.fit(X, num_clusters,'Options',options);
end

% (*) From here my code

[num_observations, num_dimensions ] = size(X);
%minx = min(min(X));
%maxx = max(max(X));

% (*) mu, Sigma, and PComponents are things we will be computing in the
% maximisation step of the EM algoritm, we are going to select them for the
% expected posterior probabilities p(j|x) using likelihood maximisation.

% rows are mixture components and columns featues (as in data)
% (*) init mu randomly
%mu = minx + (maxx - minx) * rand(num_clusters, num_dimensions);
% (*) init mu from kmeans
kmeansopts = statset('Display','off');
[kmeanscids, mu] = kmeans(X, num_clusters, 'Distance','city', ... 
                 'Replicates',5, 'Options',kmeansopts);

% add some noise for the demonstration
if (noisy_init == 1)
    for k=1:num_clusters
        mult=1;
        if ( rand(1) < 0.5 )
            mult = -1;
        end
        for d=1:num_dimensions
            mu(k,d) = mu(k,d) + mult * 3 * rand(1);
        end
    end
end

% component number is the last dimention so Sigma(:,:,k) is the kth
% covariance matrix.
Sigma = zeros(num_dimensions, num_dimensions, num_clusters);
for i=1:num_dimensions
    for j=1:num_dimensions
        for k=1:num_clusters
            if (i==j)
                % I just make it a diagonam matrix, because it has to be
                % positive semidefinite. When computing variance, I compute
                % variance for the cluster kth only where clusters are
                % defined according to kmeanscids found by kmeans above.
                Sigma(i,j,k) = var(X(kmeanscids==k,i));
                if ( noisy_init == 1)
                    % add some noise for demonstration
                    Sigma(i,j,k) = Sigma(i,j,k) + 4 * rand(1);
                end
            end
        end
    end
end

% prior probability of each component: p(j)~uniform
PComponents = ones(1,num_clusters) * 1/num_clusters;

% (*) so here, we have initial values of mu, Sigma and PComponents
if (debug_mode == 1)
    disp('initial mu');
    disp(mu);
    disp('initial sigma');
    disp(Sigma);
    disp('inital prior probs of clusters');
    disp(PComponents);
end

%% --------- THE EM ALGORITHM ---------

% (1) compute initial value of the log likelihood
old_log_likelihood = 0;
for n=1:num_observations
    log_cluster_lp = zeros(1, num_clusters);
    for k=1:num_clusters
        log_cluster_lp(k) = log( mvnpdf(X(n,:), mu(k,:), Sigma(:,:,k)) );
        log_cluster_lp(k) = log_cluster_lp(k) + log( PComponents(1, k) );
    end
    % internal sum of log likelihood (adding probabibilites)
    log_sum_cluster_lp = logsumexp(log_cluster_lp,2);
    % external sum of log likelihood (adding logarithms)
    old_log_likelihood = old_log_likelihood + log_sum_cluster_lp;
end
if (debug_mode == 1)
    disp('initial log likelihood is:');
    disp(old_log_likelihood);
end

curr_iter = 1;
while ( true )

if (show_graph == 1)
    plot_current_model(X, mu, Sigma, PComponents);
end

% (2) E-step: compute responsibilities using the current parameter values,
% by responsibilities we mean posterior probability that given observation
% x^n was genertated by cluster j, which is p(j|x^n). We compute this from
% the Bayes theorem by multiplying prior probability of the cluster p(j) by
% the likelihood p(x^n|j) of given x^n.
log_lp = zeros(num_observations, num_clusters); % for storing log(p(x|j)*p(j))
log_posterior_j_on_x = zeros(num_observations, num_clusters);
% firstly compute all log(p(x|j)p(j))
for n=1:num_observations
    for k=1:num_clusters
        log_lp(n,k) = log( mvnpdf(X(n,:), mu(k,:), Sigma(:,:,k)) );
        log_lp(n,k) = log_lp(n,k) + log( PComponents(1, k) );
    end
end
% logsumexp returns log(sum(exp(a),dim)) while avoiding numerical underflow:
% dim=2 will sum over columns (here for each obervation we are summing out
% clusters).
log_sum_lp = logsumexp(log_lp,2);
% now compute log posterior probabilities for each pair (n,k)
for n=1:num_observations
    for k=1:num_clusters
        log_posterior_j_on_x(n, k) = log_lp(n,k) - log_sum_lp(n);       
    end
end

%disp('estimated resposibilities');
%disp(posterior_j_on_x);

% (3) M-step: re-estimate the parameters using the current responsibilites,
% that is, compute mu, Sigma, and PComponents using maximul likelihood
% estimation equations.

% (3.1) compute Nk for all data points, sum over rows here in order to get
% log(Nk) for each cluster (NOTE THE SECOND PARAMETER IS 1 NOW).
log_Nk = logsumexp(log_posterior_j_on_x, 1);

% (3.2) re-estimate mu
for k=1:num_clusters
    for d=1:num_dimensions
        sum = 0;
        for n=1:num_observations
           sum = sum + exp( log_posterior_j_on_x(n,k) - log_Nk(k) ) * X(n,d); 
        end
        mu(k,d) = sum;
    end
end
if (debug_mode == 1)
    disp('mu');
    disp(mu);
end

% (3.3) re-estimate Sigma
for k=1:num_clusters
    sum = 0;
    for n=1:num_observations
        % when computing covariance vertical vector * horizontal verctor
        % (see covariance.m in examples).
        sum = sum + exp(log_posterior_j_on_x(n,k) - log_Nk(k)) * (X(n,:)-mu(k,:))'*(X(n,:)-mu(k,:)); 
    end
    Sigma(:,:,k) = sum;
end
if (debug_mode == 1)
    disp('Sigma');
    disp(Sigma);
end

% (3.4) re-estimate PComponents
for k=1:num_clusters
    PComponents(k) = exp(log_Nk(k)) / num_observations;
end
if (debug_mode == 1)
    disp('PComponents');
    disp(PComponents);
end;

% (4) Evaluate new log likelihood
new_log_likelihood = 0;
for n=1:num_observations
    log_cluster_lp = zeros(1, num_clusters);
    for k=1:num_clusters
        log_cluster_lp(k) = log( mvnpdf(X(n,:), mu(k,:), Sigma(:,:,k)) );
        log_cluster_lp(k) = log_cluster_lp(k) + log( PComponents(1, k) );
    end
    % internal sum of log likelihood (adding probabibilites)
    log_sum_cluster_lp = logsumexp(log_cluster_lp,2);
    % external sum of log likelihood (adding logarithms)
    new_log_likelihood = new_log_likelihood + log_sum_cluster_lp;
end
likelihooddiff = new_log_likelihood - old_log_likelihood;

if (debug_mode == 1)
    disp('new log likelihood is:');
    disp(new_log_likelihood);
    disp('likelihood difference');
    disp(likelihooddiff);
    disp('iteration');
    disp(curr_iter);
end

% (5) check the termination condition: multiplication by abs(newll) is in
% matlab code in toolbox/stats/stats/gmdistribution/private/gmcluster.m
if ( (likelihooddiff >= 0 && likelihooddiff < 1e-6 * abs(new_log_likelihood) ) || curr_iter > 100)
    disp('algorithm ends after iterations');
    disp(curr_iter);
    break;
else
    curr_iter = curr_iter + 1;
end
if ( likelihooddiff < 0 )
    disp('Log likelihood is becoming smaller so we have to stop here - SOMETHING IS WRONG');
    disp(likelihooddiff);
    break;
end

old_log_likelihood = new_log_likelihood;
end % end of while loop

%% --------- THE EM ALGORITHM ---------

% (*) dysplay my model and matlab model
if (debug_mode == 1)
    disp('my gmm:');
    disp(mu);
    disp(Sigma);
    disp(PComponents);
    disp('matlab gmm:');
    matlab_obj.mu
    matlab_obj.Sigma
    matlab_obj.PComponents
end

% (*) prepare result for returning from this function:
%obj = gmdistribution(matlab_obj.mu, matlab_obj.Sigma, matlab_obj.PComponents);
obj = gmdistribution(mu, Sigma, PComponents);

if (debug_mode == 1)
    disp('END of program execution');
end

end

% (*) this is an example of how to plot the normal probability density
% function, this is for single dimension only.
%x = -15:0.1:25;
%mu = 3;
%sigma = 4;
%pdfNormal = normpdf(x, mu, sigma);
%plot(x, pdfNormal);

% (*) this example is how to get pdf of numtidimensional Gaussian
%mu = [1 -1]; Sigma = [.9 .4; .4 .3];
%[X1,X2] = meshgrid(linspace(-1,3,25)', linspace(-3,1,25)');
%X = [X1(:) X2(:)];
%p = mvnpdf(X, mu, Sigma);
%surf(X1,X2,reshape(p,25,25));

function plot_current_model(X, mu, sigma, pcomponents)
    disp('you have to click inside the graph in oder to move to the next step');
    scatter(X(:,1),X(:,2),10,'ko')
    gm = gmdistribution(mu, sigma, pcomponents);
    hold on
    ezcontour(@(x,y)pdf(gm,[x y]),[-8 8],[-8 8]);
    waitforbuttonpress
    hold off
end