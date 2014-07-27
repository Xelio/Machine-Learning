1;

function Y = get_Y(X)
  x_1 = X(:, 1); x_2 = X(:, 2);
  Y = sign(x_2 .- x_1 .+ 0.25 .* sin(pi .* x_1));
end

data_count = 100;
gamma = 1.5;
C = 1e6;

run_count = 10;
E_in = zeros (run_count, 1);

for i = 1 : run_count
  X = unifrnd (-1, 1, data_count, 2);
  Y = get_Y(X);

  param = sprintf('-q -s 0 -t 2 -h 0 -g %f -c %f', gamma, C);
  model = svmtrain(Y, X, param);
  model.totalSV
  Y_pre = svmpredict(Y, X, model, '-q');
  E_in(i) = sum(Y_pre != Y) / size(Y, 1);
endfor

fprintf ("Average Ein of %i run: %f\n", run_count, mean(E_in));




% c = eye(3)((Y .+1) ./2 .+1, :);
% scatter (X(:, 1), X(:, 2), [], c);
