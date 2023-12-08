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

-- Function to place a torch
local function placeTorch()
    turtle.place("minecraft:torch")
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
-- index the torch spacing
torch_index = 0
-- starting with the first row, carrying on with every row
for row = 1, ROW_COUNT do
    for _ = 1, ROW_DEPTH do
        forwardWithDig()
        torch_index = torch_index + 1
        turtle.digUp()
        turtle.digDown()

        -- place torch every 12 blocks, when we're at the last row
        if torch_index == 11 and row == ROW_COUNT then
            turtle.turnRight()
            placeTorch()
            turtle.turnLeft()
            torch_index = 0
        end
    end
    -- go to next row
    moveToRow(row)
    emptyInventory()
    turnToNextRow()
end
