import std/[os, nre, strformat, strutils]

let numberPattern = re"\d+"
let gearPattern = re"\*"

proc matchInflatedBounds*(match: RegexMatch): HSlice[int, int] =
    return (match.matchBounds.a - 1) .. (match.matchBounds.b + 1)

proc computeGearRatio(prevLine: string, currLine: string, nextLine: string): int =
    var numberMatches: seq[RegexMatch] = @[]
    for match in prevLine.findIter(numberPattern):
        numberMatches.add(match)
    for match in currLine.findIter(numberPattern):
        numberMatches.add(match)
    for match in nextLine.findIter(numberPattern):
        numberMatches.add(match)

    for gear in currLine.findIter(gearPattern):
        var validNumbers: seq[int]
        block checkNumbers:
            for match in numberMatches: 
                if gear.matchBounds.a in match.matchInflatedBounds:
                    validNumbers.add(parseInt(match.match))
                    if len(validNumbers) > 2:
                        break checkNumbers 
            if len(validNumbers) == 2:
                result += validNumbers[0] * validNumbers[1]



proc solve*(file: string) = 
    var sum: int = 0

    let f = open(file)
    defer: f.close()
    
    var
        prevLine = ""
        currLine = f.readLine() # Grab the first line
        nextLine = f.readLine() # Grab the second line
    
    while not f.endOfFile:

        sum += computeGearRatio(prevLine, currLine, nextLine)

        prevLine = currLine
        currLine = nextLine
        nextLine = f.readLine()
    
    # Kinda hacky because the second-to-last line loop never completes
    # because when nextLine is the last line, it has the EOF character 
    # so the while loop closes.
    sum += computeGearRatio(prevLine, currLine, nextLine)

    prevLine = currLine
    currLine = nextLine
    nextLine = ""
    sum += computeGearRatio(prevLine, currLine, nextLine)

    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)