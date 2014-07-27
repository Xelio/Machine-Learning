x = [1,0;
	0,1;
	0,-1;
	-1,0;
	0,2;
	0,-2;
	-2,0];

y = [-1;
	-1;
	-1;
	1;
	1;
	1;
	1];


fprintf ("polynomial\n");
model = svmtrain(y, x, '-q -s 0 -t 1 -g 1 -r 1 -d 2 -h 0 -c 1e6');
fprintf ("Number of support vector: %i\n", model.totalSV);

% draw result
draw_count = 10000;
d = 2;
X_draw = unifrnd (-3, 3, draw_count, d);
Y_draw = unifrnd (-3, 3, draw_count, 1);
Y_draw = svmpredict(Y_draw, X_draw, model, '-q');

c = eye(3)((Y_draw .+1) ./2 .+1, :);

scatter (X_draw(:, 1), X_draw(:, 2), [], c);
