train_data = load('features.train');
test_data = load('features.test');

% 1 versus 5
Cs = [0.01,1,100,1e4,1e6];
% Cs = [0.001,0.01,1,10,100,1e4,1e6];


x = train_data(:, [2, 3]);
y = train_data(:, 1);

X = [x(find(y==1), [1,2]); x(find(y==5), [1,2])];
Y = [ones(size(find(y==1),1), 1); ones(size(find(y==5),1), 1) .* -1];

x_out = test_data(:, [2, 3]);
y_out = test_data(:, 1);

X_out = [x_out(find(y_out==1), [1,2]); x_out(find(y_out==5), [1,2])];
Y_out = [ones(size(find(y_out==1),1), 1); ones(size(find(y_out==5),1), 1) .* -1];

fprintf ("Number of training data : %i\n", size(Y,1));
fprintf ("Number of testing data : %i\n", size(Y_out,1));
fprintf ("\n");

SVs = zeros (size(Cs, 2), 1);
Ein = zeros (size(Cs, 2), 1);
Eout = zeros (size(Cs, 2), 1);

for i = 1 : size(Cs, 2)
	C = Cs(i);
    parm = sprintf('-q -s 0 -t 2 -g 1 -h 0 -c %f', C);

    model = svmtrain(Y, X, parm);

    SVs(i) = model.totalSV;

	in_predict = svmpredict(Y, X, model, '-q');
	E_in(i) = size(find(Y != in_predict),1)/size(Y,1);

	out_predict = svmpredict(Y_out, X_out, model, '-q');
	E_out(i) = size(find(Y_out != out_predict),1)/size(Y_out,1);
endfor
fprintf ("\n");

for i = 1 : size(Cs, 2)
	fprintf ("Number of SV of C = %f : %i\n", Cs(i), SVs(i));
endfor
fprintf ("\n");

for i = 1 : size(Cs, 2)
	fprintf ("Ein of C = %g: %g\n", Cs(i), E_in(i));
endfor
fprintf ("\n");

for i = 1 : size(Cs, 2)
	fprintf ("Eout of C = %g: %g\n", Cs(i), E_out(i));
endfor
