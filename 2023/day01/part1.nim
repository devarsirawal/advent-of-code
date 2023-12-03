import std/[os, strformat, strutils]

proc solve*(file: string) = 
    var sum: int = 0

    for line in lines(file):
        var digits: seq[int]
        for c in line:
            case c
            of '0'..'9':
                digits.add(ord(c) - ord('0'))
            else: discard

        sum += digits[0] * 10 + digits[^1]
    
    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)