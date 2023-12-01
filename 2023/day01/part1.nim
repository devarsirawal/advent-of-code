import std/[algorithm, os, strformat, strutils]

proc solve*(file: string) = 
    var
        sum: int = 0

    for line in lines(file):
        var 
            leftDigit: char
            rightDigit: char
        for c in line:
            if c.isDigit():
                leftDigit = c
                break
        for c in reversed(line):
            if c.isDigit():
                rightDigit = c
                break

        sum += parseInt(leftDigit & rightDigit)
    
    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)