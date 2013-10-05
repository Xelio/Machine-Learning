Math.sign = function(x) {
  return x ? x < 0 ? -1 : 1 : 0;
}

window.PLA = function(weights, modifier) {
  this._weights = weights
  this._modifier = modifier
  this._iteration = 0;
}

window.PLA.prototype.train = function(inputs, expectedOutput) {
  if(expectedOutput === this.getOutput(inputs)) return false;

  this._weights[0] += expectedOutput;
  for(var i = 0; i < inputs.length; i++) {
    this._weights[i+1] += expectedOutput * inputs[i];
  }

  this._iteration += 1;
  return true;
}

window.PLA.prototype.getOutput = function(inputs) {
  if(inputs.length !== this._weights.length - 1) throw "Number of inputs is not correct"

  var output;
  output = this._weights[0];
  for(var i = 0; i < inputs.length; i++) {
    output += this._weights[i+1] * inputs[i];
  }
  
  if(typeof(this._modifier) === 'function') output = this._modifier(output);
  return output;
}

window.TestPlane = function(x_min, x_max, y_min, y_max) {
  this._x_min = x_min;
  this._x_max = x_max;
  this._y_min = y_min;
  this._y_max = y_max;
  this._line = [this.randomPoint(), this.randomPoint()];
}

window.TestPlane.prototype.getOutput = function(input) {
  var output;
  var Ax = this._line[0][0];
  var Ay = this._line[0][1];
  var Bx = this._line[1][0];
  var By = this._line[1][1];
  output = Math.sign((Bx-Ax) * (input[1]-Ay) - (By-Ay) * (input[0]-Ax));
  return output;
}

window.TestPlane.prototype.randomPoint = function() {
  var x =  this._x_min + Math.random() * (this._x_max - this._x_min);
  var y =  this._y_min + Math.random() * (this._y_max - this._y_min);
  return [x,y];
}

