1;

function Y = get_Y(X)
  x_1 = X(:, 1); x_2 = X(:, 2);
  Y = sign(x_2 .- x_1 .+ 0.25 .* sin(pi .* x_1));
end

function Phi = get_Phi(X, mu, gamma)
  Phi = zeros(size(X,1), size(mu,1));
  for i = 1 : size(X,1)
    for j = 1 : size(mu,1)
      d = X(i,:) - mu(j,:);
      dsq = d * d';
      Phi(i,j) = e ^ (-1 * gamma * dsq);
    endfor
  endfor
  Phi = [ones(size(Phi,1),1),Phi];
end

function w = RBF(X, Y, gamma)
  
end

color = [1,0,0;
         0,1,0;
         0,0,1;
         0.8,0.8,0;
         0.8,0,0.8;
         0,0.8,0.8;
         0.2,0.2,0.7;
         0.2,0.7,0.2;
         0.7,0.2,0.2];

data_count = 100;
gamma = 1.5;
C = 1e6;
K = 9;

run_count = 1;
E_in = zeros (run_count, 1);

for i = 1 : run_count
  X = unifrnd (-1, 1, data_count, 2);
  Y = get_Y(X);
  [mu, pointsInCluster, assignment] = kmeans(X, K);

  Phi = get_Phi(X, mu, gamma);
  w = pinv(Phi) * Y

  figure;
  hold on;

  for k = 1 : K
    points_in_k = X(find(assignment==k) , :);
    scatter (points_in_k(:, 1), points_in_k(:, 2), [], color(k,:));
    scatter (mu(k, 1), mu(k, 2), 25, color(k,:));
  endfor

  hold off;
endfor

fprintf ("Average Ein of %i run: %f\n", run_count, mean(E_in));

