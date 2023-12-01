import std/[os, re, strformat, strutils, tables]

let numbers* = {
    "one": "1",
    "two": "2",
    "three": "3",
    "four": "4",
    "five": "5",
    "six": "6",
    "seven": "7",
    "eight": "8",
    "nine": "9"
}.toTable

let pattern*: Regex = re"one|two|three|four|five|six|seven|eight|nine|[1-9]"

proc isStringDigit(s: string): bool =
    return s in ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]

proc solve*(file: string) = 
    var sum: int = 0

    for line in lines(file):
        var 
            leftDigit: string
            rightDigit: string
        
        var matches = line.findAll(pattern)
        leftDigit = if matches[0].isStringDigit(): matches[0] else: numbers[matches[0]]
        rightDigit = if matches[^1].isStringDigit(): matches[^1] else: numbers[matches[^1]]

        sum += parseInt(leftDigit & rightDigit)
    
    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)