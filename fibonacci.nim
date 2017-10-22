import times
import tables
# 0 1 2 3 4 5 6
# 0 1 1 2 3 5 8


proc fibonacciNaive*(n: int): int =
  if n == 0: 0
  elif n == 1: 1
  else: fibonacciNaive(n-1) + fibonacciNaive(n-2)

proc fibonacciStore*(n: int): int =
  var store = {0: 0, 1: 1}.toTable
  for i in 2..n:
    store[i] = store[i-1] + store[i-2]

  result = store[n]

proc fibonacciStoreTwo*(n: int): int =
  var
    left = 0
    right = 1
  if n != 0:
    for i in 1..n:
      swap(left, right)
      right = left+right

  result = left

proc fibonacci*(n: int): int =
  return fibonacciStoreTwo(n)


when isMainModule:
  doAssert(fibonacciNaive(1) == 1)
  doAssert(fibonacciNaive(2) == 1)
  doAssert(fibonacciNaive(6) == 8)

  doAssert(fibonacciStore(1) == 1)
  doAssert(fibonacciStore(2) == 1)
  doAssert(fibonacciStore(6) == 8)

  doAssert(fibonacciStoreTwo(1) == 1)
  doAssert(fibonacciStoreTwo(2) == 1)
  doAssert(fibonacciStoreTwo(6) == 8)


  import strutils
  let n = 45

  # store only 2 vars:
  var t = cpuTime()
  echo "Store 2 vars fib($1) start..."%($n)
  echo fibonacciStoreTwo(n)
  echo "Time taken: ", cpuTime() - t

  # store 1..n vars:
  t = cpuTime()
  echo "Store all fib($1) start..."%($n)
  echo fibonacciStore(n)
  echo "Time taken: ", cpuTime() - t

  # naive way:
  t = cpuTime()
  echo "Naive fib($1) start..."%($n)
  echo fibonacciNaive(n)
  echo "Time taken: ", cpuTime() - t

