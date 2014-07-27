1;

function E = err(weights, X, y)
  N = size(X, 1);
  hyp = sign(X * weights);
  err = sum(hyp != y);
  E = err / N;
end

function X = transform(oldX)
  [m, n] = size(oldX);
  x_1 = oldX(:, 1); x_2 = oldX(:, 2);
  X = [ones(m, 1), x_1, x_2, x_1.*x_2, x_1.^2, x_2.^2];
end




train_data = load('features.train');
test_data = load('features.test');
label_a = 1;
label_b = 5;

lambdas = [0.01,1];

x_in = train_data(:, [2, 3]);
X_in = transform(x_in);
y_in = train_data(:, 1);

X_in = transform([x_in(find(y_in==label_a), [1,2]); x_in(find(y_in==label_b), [1,2])]);
Y_in = [ones(size(find(y_in==label_a),1), 1); ones(size(find(y_in==label_b),1), 1) .* -1];

x_out = test_data(:, [2, 3]);
X_out = transform(x_out);
y_out = test_data(:, 1);

X_out = transform([x_out(find(y_out==label_a), [1,2]); x_out(find(y_out==label_b), [1,2])]);
Y_out = [ones(size(find(y_out==label_a),1), 1); ones(size(find(y_out==label_b),1), 1) .* -1];

E_in = zeros (size(lambdas, 2), 1);
E_out = zeros (size(lambdas, 2), 1);


for i = 1 : size(lambdas, 2)
	lambda = lambdas(i);
	weights = linearRegression(X_in, Y_in, lambda);
	E_in(i) = err(weights, X_in, Y_in);
	E_out(i) = err(weights, X_out, Y_out);
endfor
fprintf ("\n");

for i = 1 : size(lambdas, 2)
	fprintf ("Ein of lamda %g: %f\n", lambdas(i), E_in(i));
	fprintf ("Eout of lamda %g: %f\n", lambdas(i), E_out(i));
	fprintf ("\n");
endfor

