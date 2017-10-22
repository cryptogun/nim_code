
import times
proc factorial(n: uint): uint64 =
  result = 1
  for i in 1..n:
    result *= i
  return result

when isMainModule:
  var t = cpuTime()
  var ans = factorial(18)
  t = cpuTime() - t
  echo t, " ", ans
