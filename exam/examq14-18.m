1;

function Y = get_Y(X)
  x_1 = X(:, 1); x_2 = X(:, 2);
  Y = sign(x_2 .- x_1 .+ 0.25 .* sin(pi .* x_1));
end

function Phi = get_Phi(X, mu, gamma)
  Phi = [];
  
  for i = 1 : size(X,1)
    diffs = bsxfun(@minus, mu, X(i,:));
    sqrdDists = sum(diffs .^ 2, 2);
    Phi = [Phi; 1, exp(-gamma .* sqrdDists')];
  endfor
end

function [w, mu] = RBF(X, Y, gamma, K)
  [mu, pointsInCluster, assignment] = kmeans(X, K);
  Phi = get_Phi(X, mu, gamma);
  w = pinv(Phi) * Y;
end

function Y_out = RBF_predict(X, w, b, gamma, mu)
  K = size(mu, 1);
  Y_out = zeros(size(X, 1), 1);
  for i = 1 : size(X, 1)
    diffs = bsxfun(@minus, mu, X(i,:));
    sqrdDists = sum(diffs .^ 2, 2);
    Y_out(i) = sign(b + w' * exp(-gamma .* sqrdDists));
  endfor
end

data_count = 100;
test_data_count = 1000;
gamma = 2;
C = 1e6;
K = 9;

run_count = 1000;
E_in_kern = zeros (run_count, 1);
E_in_regl = zeros (run_count, 1);
E_out_kern = zeros (run_count, 1);
E_out_regl = zeros (run_count, 1);
kern_beat_regl = zeros (run_count, 1);

for i = 1 : run_count
  X = unifrnd (-1, 1, data_count, 2);
  Y = get_Y(X);

  X_test = unifrnd (-1, 1, test_data_count, 2);
  Y_test = get_Y(X_test);
  
  [w, mu] = RBF(X, Y, gamma, K);
  b = w(1);
  w(1) = [];
  Y_in = RBF_predict(X, w, b, gamma, mu);
  Y_out = RBF_predict(X_test, w, b, gamma, mu);

  E_in_regl(i) = sum(Y_in != Y) / size(Y, 1);
  E_out_regl(i) = sum(Y_out != Y_test) / size(Y_test, 1);



  %param = sprintf('-q -s 0 -t 2 -h 0 -g %f -c %f', gamma, C);
  %model = svmtrain(Y, X, param);
  %Y_in = svmpredict(Y, X, model, '-q');
  %Y_out = svmpredict(Y_test, X_test, model, '-q');

  %E_in_kern(i) = sum(Y_in != Y) / size(Y, 1);
  %E_out_kern(i) = sum(Y_out != Y_test) / size(Y_test, 1);
  
  %kern_beat_regl(i) = E_out_kern(i) < E_out_regl(i);
endfor

fprintf ("K: %i, gamma: %g\n", K, gamma);
%fprintf ("Average Ein of kernel form of %i run: %g\n", run_count, mean(E_in_kern));
fprintf ("Average Ein of regular form of %i run: %g\n", run_count, mean(E_in_regl));

%fprintf ("Average Eout of kernel form of %i run: %g\n", run_count, mean(E_out_kern));
fprintf ("Average Eout of regular form of %i run: %g\n", run_count, mean(E_out_regl));

%fprintf ("Fraction kernel form beat regular form of %i run: %g\n", run_count, sum(kern_beat_regl)/run_count);

fprintf ("Fraction of Ein = 0 of regular form of %i run: %g\n", run_count, sum(E_in_regl == 0)/run_count);

