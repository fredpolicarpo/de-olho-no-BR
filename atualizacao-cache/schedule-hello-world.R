test = function() {
  print("ok")
  later::later(test,2)
}

later::later(test, 2)
