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
  %X = [ones(m, 1), x_1, x_2];
end




train_data = load('features.train');
test_data = load('features.test');

learning_labels = [0,1,2,3,4,5,6,7,8,9];
lambda = 1;

x_in = train_data(:, [2, 3]);
X_in = transform(x_in);
y_in = train_data(:, 1);


x_out = test_data(:, [2, 3]);
X_out = transform(x_out);
y_out = test_data(:, 1);


fprintf ("Number of training data : %i\n", size(y_in,1));
fprintf ("\n");

E_in = zeros (size(learning_labels, 2), 1);
E_out = zeros (size(learning_labels, 2), 1);


for i = 1 : size(learning_labels, 2)
	learning_label = learning_labels(i);
	% transform the label
	Y_in = (y_in == learning_label) .* 2 .- 1;
	Y_out = (y_out == learning_label) .* 2 .- 1;
	fprintf ("Number of label %i: %i\n", learning_label, sum(Y_in == 1));

	weights = linearRegression(X_in, Y_in, lambda);
	E_in(i) = err(weights, X_in, Y_in);
	E_out(i) = err(weights, X_out, Y_out);
endfor
fprintf ("\n");

for i = 1 : size(learning_labels, 2)
	fprintf ("Ein of label %i: %f\n", learning_labels(i), E_in(i));
endfor
fprintf ("\n");

for i = 1 : size(learning_labels, 2)
	fprintf ("Eout of label %i: %f\n", learning_labels(i), E_out(i));
endfor
