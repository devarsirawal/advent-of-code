import std/[os, nre, strformat, strutils, tables]

type
    Color {.pure.} = enum
        Red = "red",
        Green = "green",
        Blue = "blue"
    Bag = Table[Color, int]

let colorPattern = re"(\d+)\s*(red|blue|green)"

proc solve*(file: string) = 
    var sum: int = 0

    for line in lines(file):
        var maxBag: Bag = {Red: 0, Green: 0, Blue: 0}.toTable()
        for bagText in line.split(":")[1].strip().split(";"):
            for match in bagText.findIter(colorPattern):
                let color = parseEnum[Color](match.captures[1])
                let cubes = parseInt(match.captures[0])
                if cubes > maxBag[color] or maxBag[color] == 0:
                    maxBag[color] = cubes

        sum += maxBag[Red] * maxBag[Green] * maxBag[Blue]

    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)