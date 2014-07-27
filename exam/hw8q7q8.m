train_data = load('features.train');
test_data = load('features.test');

% 1 versus 5
Q = 2;
Cs = [0.0001, 0.001, 0.01, 0.1, 1];


x = train_data(:, [2, 3]);
y = train_data(:, 1);

X = [x(find(y==1), [1,2]); x(find(y==5), [1,2])];
Y = [ones(size(find(y==1),1), 1); ones(size(find(y==5),1), 1) .* -1];

fprintf ("Number of training data : %i\n", size(Y,1));
fprintf ("Number of testing data : %i\n", size(Y_out,1));
fprintf ("\n");
fprintf ("Q = %i\n", Q);

iter = 100;
total_Ecv = zeros (5, 1);
total_selected_C = zeros (5, 1);
for j = 1 : iter

	Ecv = zeros (5, 1);

	[garbage index] = sort(rand(length(Y),1));
	for i = 1 : size(Cs, 2)
		C = Cs(i);
		parm = sprintf('-q -s 0 -t 1 -g 1 -r 1 -h 0 -d %i -c %f -v 10', Q, C);

		Ecv(i) = 1 - (svmtrain(Y(index), X(index, [1,2]), parm) / 100);
		total_Ecv(i) += Ecv(i);
	endfor

	selected_C = min(find(Ecv == min(Ecv)));
	total_selected_C(selected_C) += 1;
endfor
fprintf ("\n");

for i = 1 : size(Cs, 2)
	fprintf ("Selected times of C = %f: %i\n", Cs(i), total_selected_C(i));
endfor
fprintf ("\n");

for i = 1 : size(Cs, 2)
	fprintf ("Ecv of C = %f: %g\n", Cs(i), total_Ecv(i) / iter);
endfor
