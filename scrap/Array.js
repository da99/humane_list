
var i = 0
var start = new Date().getTime();
while (i < 100000000) {
  var a = ["1"];
  a.pop();
  ++i;
  // if (i % 1000000 == 0)
    // console.log(i);
}
var elapsed = new Date().getTime() - start;
console.log(elapsed);
