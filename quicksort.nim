
###############################################################################
proc quickSortShift(se: var seq[int], left: int, right: int) =
  if left >= right:
    return
  var level = se[left]
  var a = left + 1
  var z = right
  while a < z:
    while se[z] >= level and a < z:
      z -= 1
    while se[a] <= level and a < z:
      a += 1
    swap(se[a], se[z])

  var i = left
  while se[i] > se[i + 1] and i < right:
    swap(se[i], se[i + 1])
    i += 1
  quickSortShift(se, left, i - 1)
  quickSortShift(se, i + 1, right)
proc quickSortShift*(se: var seq[int]) =
  quickSortShift(se, low(se), high(se))

###############################################################################
proc quickSort*(se: var seq[int], left: int, right: int) =
  if left >= right:
    return
  var level = se[left] # throw up to the sky.
  var a = left
  var z = right
  while a < z:
    while se[z] >= level and a < z:
      z -= 1
    se[a] = se[z] # throw to the left
    while se[a] <= level and a < z:
      a += 1
    se[z] = se[a] # throw to the right
  se[a] = level # back to the hole.
  quickSort(se, left, a - 1)
  quickSort(se, a + 1, right)

proc quickSort*(se: var seq[int]) =
  quickSort(se, low(se), high(se))

###############################################################################
# https://gist.github.com/hanst99/8f3868f2c2b1cb12d489
### Swap xs[ix] and xs[iy]
proc swap[A](xs: var seq[A], ix: int, iy: int) =
  let tmp = xs[ix]
  xs[ix] = xs[iy]
  xs[iy] = tmp

## 'Pivotizes' the seq by rearranging the seq
## such that there is an index i with value vi
## so that if j < i then vj < vi and if
## j > i then vj >= vi
proc pivotize[A](xs: var seq[A], s: Slice[int]): int =
  if len(xs) >= 2:
    var pivotIx = s.a
    let pivot = xs[pivotIx]
    for i in s.a+1..s.b:
       # Explanation: You less than me? come here, fuck you.
       # we got an element thats smaller and to the right of the pivot
       if (xs[i] < pivot and pivotIx < i):
         discard """ swap the current element with the element right to the pivot
          we can do this because the element right to the pivot is either
          greater than the pivot (so we can shift it even further right)
          or we haven't looked at it yet (in which case, shifting it further
          to the right causes no harm). Then we swap the pivot and the element
          right next to the pivot (which is now the current element)"""
         swap(xs, i, pivotIx+1)
         swap(xs, pivotIx, pivotIx+1)
         pivotIx = pivotIx + 1
      # Our pivot can never be to the right of an element bigger than it
      # by construction, so there is no else case
    return pivotIx

## Sorts the range in xs given by the slice
proc quicksort1[A](xs: var seq[A], s: Slice[int]) =
  if s.b-s.a > 1:
    let pivot = pivotize(xs,s)
    quicksort1(xs, s.a .. pivot)
    quicksort1(xs, pivot+1 .. s.b)
## Sorts xs using the quicksort algorithm
proc quicksort1[A](xs: var seq[A]) =
  quicksort1(xs, low(xs)..high(xs))


###############################################################################

when isMainModule:
  echo "start..."
  import times
  import random
  import sequtils

  var collection = toSeq(-10_000_000..10_000_000)
  collection.shuffle()
  var collection2 = collection
  var collection3 = collection

  ##################################
  var t = cpuTime()
  quicksort1(collection)
  t = cpuTime() - t
  # Explanation: You less than me? come here, fuck you.
  echo "Suppress time: ", t

  doAssert(collection != collection2) # make sure is deepcopy.
  ##################################
  t = cpuTime()
  quickSort(collection2)
  t = cpuTime() - t
  doAssert(collection == collection2) # make sure both correct.
  echo "Filter by throw time: ", t
  ##################################

  t = cpuTime()
  quickSortShift(collection3)
  t = cpuTime() - t
  doAssert(collection == collection3)
  echo "Swap then shift time: ", t

  # output:
  # start...
  # Suppress time: 2.539
  # Filter by throw time: 2.281
  # Swap then shift time: 2.673

  # start...
  # Suppress time: 2.526
  # Filter by throw time: 2.245
  # Swap then shift time: 2.667

  # start...
  # Suppress time: 2.516
  # Filter by throw time: 2.265
  # Swap then shift time: 2.657000000000001
