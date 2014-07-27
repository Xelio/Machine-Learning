1;

% Calculates the Eout for weight vector w
function diff = diffprob (d, spc, f, w, count)
  X = unifrnd (spc(1), spc(2), count, d);
  X = [ ones(count, 1), X ];

  y  = arrayfun (@(x, y) sign (f (x) - y), X(:,2), X(:,3));
  hy = misclassified (X, y, w);

  diff = length (hy) / length (X);
end

% Number of times the algorithm will run in order to calculate the
% average number of steps taken
iters = 1000;

% X/Y range where the examples will be plotted
spc = [-1, 1];

% Number of dimensions (excluding the synthetic dimension x0, which
% will be added later)
d = 2;

% Number of examples. Change this according to the question
N = 100;

pr_pla = zeros (iters,1);
pr_svm = zeros (iters,1);
total_sv = zeros (iters,1);

for n = 1:iters
  % N random examples
  X = unifrnd (spc(1), spc(2), N, d);

  y = [1];
  while(abs(sum(y)) == size(y, 1))
    % Two random points used in target function f
    fp1 = unifrnd (spc(1), spc(2), 2, 1);
    fp2 = unifrnd (spc(1), spc(2), 2, 1);

    f = @(x) target (fp1, fp2, x);

    % Uses the target function to set the desired labels
    y = arrayfun (@(x, y) sign (f (x) - y), X(:,1), X(:,2));
  endwhile

  % Introduce the synthetic dimension x0
  X = [ones(N,1), X];

  % Maximum number of iterations
  maxiter = 10000;

  % Initial weight vector
  w_pla = zeros (size (X,2), 1);

  % Weight vector w after training
  w_pla = pla (X, y, w_pla, maxiter, 0);

  % Updates the difference probability between f and w
  pr_pla(n) = diffprob (d, spc, f, w_pla, 10000);

  % Train the svm
  model = svmtrain(y,X, '-t 0 -c 1.0E6 -q');
  total_sv(n) = model.totalSV;
  w_svm = model.SVs' * model.sv_coef;
  w_svm(1) = w_svm(1) - model.rho;
  pr_svm(n) = diffprob (d, spc, f, w_svm, 10000);
end

pr_diff = pr_svm - pr_pla;
pr_svm_better = sum(pr_diff < 0) / iters;

fprintf ("Average of the difference between f(x) and g(x) by PLA: %f\n", mean (pr_pla));
fprintf ("Average of the difference between f(x) and g(x) by SVM: %f\n", mean (pr_svm));
fprintf ("Percentage of SVM better than PLA: %f\n", pr_svm_better);
fprintf ("Average number of sv: %f\n", mean (total_sv));
