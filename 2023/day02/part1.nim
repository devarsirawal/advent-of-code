import std/[os, nre, strformat, strutils, tables]

type
    Color {.pure.} = enum
        Red = "red",
        Green = "green",
        Blue = "blue"
    Bag = Table[Color, int]

const trueBag: Bag = {Red: 12, Green: 13, Blue: 14}.toTable()

proc isValidBag(this: Bag): bool =
    return this[Red] <= trueBag[Red] and this[Green] <= trueBag[Green] and this[Blue] <= trueBag[Blue]

let gameIdPattern = re"Game (\d+):"
let colorPattern = re"(\d+)\s*(red|blue|green)"

proc solve*(file: string) = 
    var sum: int = 0

    for line in lines(file):
        let gameId = parseInt(line.match(gameIdPattern).get.captures[0])
        var isValidGame = true;
        for bagText in line.split(":")[1].strip().split(";"):
            var bag: Bag = {Red: 0, Green: 0, Blue: 0}.toTable()
            for match in bagText.findIter(colorPattern):
                let color = parseEnum[Color](match.captures[1])
                let cubes = parseInt(match.captures[0])
                bag[color] = cubes
            if not isValidBag(bag):
                isValidGame = false; 
                break;
        if isValidGame:
            sum += gameId

    echo fmt"The sum is: {sum}"

if isMainModule:
    var params: seq[string] = commandLineParams()
    var file = if len(params) != 0: params[0] else: "input.txt"

    solve(file)