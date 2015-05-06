# Calculate the square root to a given precision
# Using Newtons Method - https://en.wikipedia.org/wiki/Newton%27s_method
def squareroot(number, precision = 5):
  root = number/2.0
  for i in range(20):
    nroot = (1/2.0)*(root + (number / root))
    #print i, nroot
    if (root - nroot < 1.0/10**precision):
      break
    root = nroot
  return round(nroot, precision)
