train_data = load('features.train');
test_data = load('features.test');
learning_label = 1;

%learning_labels = [0,2,4,6,8];
learning_labels = [1,3,5,7,9];

X = train_data(:, [2, 3]);
y = train_data(:, 1);
fprintf ("Number of training data : %i\n", size(Y,1));
fprintf ("\n");

SVs = zeros (size(learning_labels, 2), 1);
Ein = zeros (size(learning_labels, 2), 1);

for i = 1 : size(learning_labels, 2)
	learning_label = learning_labels(i);
	% transform the label
	Y = (y == learning_label) .* 2 .- 1;
	fprintf ("Number of label %i: %i\n", learning_label, sum(Y == 1));

	model = svmtrain(Y, X, '-q -s 0 -t 1 -g 1 -r 1 -h 0 -d 2 -c 0.01');

    SVs(i) = model.totalSV;
	predict = svmpredict(Y, X, model, '-q');
	E_in(i) = size(find(Y != predict),1)/size(Y,1);
endfor
fprintf ("\n");

for i = 1 : size(learning_labels, 2)
	fprintf ("Number of SV of label %i : %i\n", learning_labels(i), SVs(i));
endfor
fprintf ("\n");

for i = 1 : size(learning_labels, 2)
	fprintf ("Ein of label %i: %f\n", learning_labels(i), E_in(i));
endfor
