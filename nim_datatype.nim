
# set. incl(set, element)
var s: set[char] = {'a'..'z', '0'..'9'}
# array
var a: array[0..2, string] = ["foo", "bar", "baz"]
echo repr(a)
# sequence. mutable as string.
var sequence: seq[int] = @[1, 2, 3, 4, 5, 6]
echo $sequence


# Slices:
var slice = "asdf 1234"
slice[0..3] = "qwetyuiop"
echo slice

# Tuples:
var tup: tuple[a: int, b: string] = (a: 1, b: "asdf") #(1, "asdf")


# openArray. only in parameters in func decl. you can pass arg in of type seq or array.
# varargs[string]: like openArray. but takes more types.

## ################################################
import tables

var aaa = {"hi": 1, "there": 2}.toTable
echo aaa
var is_happy = if true: "quite" else: "not much"