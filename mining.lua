-- Parameterized constants
local ROW_DEPTH = 5
local ROW_COUNT = 3

-- Initialize direction variable
local direction = 1 -- 1 for right, -1 for left

-- Function to move the turtle forward with digging
local function forwardWithDig()
    turtle.dig()
    while not turtle.forward() do
        turtle.dig()
    end
end

-- Function to turn to the next row
local function turnToNextRow()
    turtle.turnRight()
    turtle.dig()
    forwardWithDig()
    turtle.digUp()
    turtle.digDown()
    turtle.turnRight()
end

-- Function to empty the inventory into a chest if available
local function emptyInventory()
    local isBlock = turtle.detect()
    if isBlock then
        local success, block = turtle.inspect()
        if success and block.name == "minecraft:chest" then
            for i = 1, 16 do
                turtle.select(i)
                turtle.drop()
            end
        else
            print("Cannot empty inventory, no chest")
        end
    else
        print("Cannot empty inventory, no block in front")
    end
end

-- Function to move to a specific row
local function moveToRow(row)
    turtle.turnRight()
    for i = 1, row do
        forwardWithDig()
    end
    turtle.turnLeft()
end

-- Main loop
for row = 1, ROW_COUNT do
    for _ = 1, ROW_DEPTH do
        forwardWithDig()
        turtle.digUp()
        turtle.digDown()
    end

    moveToRow(row)
    emptyInventory()
    turnToNextRow()
end
