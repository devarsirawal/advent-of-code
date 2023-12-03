import std/[os, nre, strformat, strutils]

let numberPattern = re"\d+"
let symbolPattern = re"[^A-Za-z0-9.]"

proc matchInflatedBounds*(match: RegexMatch): HSlice[int, int] =
    return (match.matchBounds.a - 1) .. (match.matchBounds.b + 1)

proc computePartNumbersSum(prevLine: string, currLine: string, nextLine: string): int =
    var symbols: seq[int] = @[]
    for match in prevLine.findIter(symbolPattern):
        symbols.add(match.matchBounds.a)
    for match in currLine.findIter(symbolPattern):
        symbols.add(match.matchBounds.a)
    for match in nextLine.findIter(symbolPattern):
        symbols.add(match.matchBounds.a)

    for match in currLine.findIter(numberPattern):
        block checkSymbols:
            for s in symbols: 
                if s in match.matchInflatedBounds:
                    result += parseInt(match.match)
                    break checkSymbols


proc solve*(file: string) = 
    var sum: int = 0

    let f = open(file)
    defer: f.close()
    
    var
        prevLine = ""
        currLine = f.readLine() # Grab the first line
        nextLine = f.readLine() # Grab the second line

    while not f.endOfFile:

        sum += computePartNumbersSum(prevLine, currLine, nextLine)
        
        prevLine = currLine
        currLine = nextLine
        nextLine = f.readLine()
    
    # Kinda hacky because the second-to-last line loop never completes
    # because when nextLine is the last line, it has the EOF character 
    # so the while loop closes.
    sum += computePartNumbersSum(prevLine, currLine, nextLine)

    prevLine = currLine
    currLine = nextLine
    nextLine = ""
    sum += computePartNumbersSum(prevLine, currLine, nextLine)

    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)