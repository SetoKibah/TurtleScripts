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
    forwardWithDig()
    turtle.turnRight()
end

-- Function to return to origin point
local function returnToOrigin(currentRow, rowDepth)
    -- Assuming we are facing the correct direction
    turtle.turnLeft()
    for i = 1, currentRow do
        for j = 1, rowDepth do
            turtle.back()
        end
        if i < currentRow then
            turtle.turnRight()
            turtle.back()
            turtle.turnRight()
        end
    end
    turtle.turnLeft()
end

-- Function to return to last row position
local function resumeRowPosition(currentRow)
    -- Assuming we are facing the correct direction
    turtle.turnRight()
    for i = 1, currentRow do
        turtle.forward()
    end
    turtle.turnLeft() 
end

-- Function to empty the inventory into a chest if available
local function emptyInventory()
    -- assuming we turn around
    turtle.turnLeft()
    turtle.turnLeft()
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
    -- resuming original orientation
    turtle.turnLeft()
    turtle.turnLeft()
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

-- Function to check and refuel the turtle
local function checkAndRefuel()
    local present_fuel = turtle.getFuelLevel()
    if present_fuel < 600 then
        local ok, error = turtle.refuel(10)
        if ok then
            local new_level = turtle.getFuelLevel()
            print(("Refuelled %d, current level is %d"):format(new_level - present_fuel, new_level))
        end
        if error then
            print(("Error %d"):format(error))
        end
    end
end

-- Main loop
torch_index = 0 -- tracks position in the row between torches

-- Start the process, assuming we are facing the intended dig direction
for row = 1, ROW_COUNT do -- iterate through the grid layout
    for _ = 1, ROW_DEPTH do
        -- Dig the tiles forward, above, and below. Results in a "shelf" at the end
        forwardWithDig()
        torch_index = torch_index + 1
        turtle.digUp()
        turtle.digDown()

        -- place torch every 12 blocks
        if torch_index == 12 then
            turtle.turnRight()
            placeTorch()
            turtle.turnLeft()
            torch_index = 0
        end
        
        -- check fuel level and refuel if needed
        checkAndRefuel()
    end

    returnToOrigin(row, ROW_DEPTH) -- return to the chest at origin
    emptyInventory() -- turn around, clear the inventory, return to normal
    moveToRow(row) -- return to the original row
    turnToNextRow() -- clear obstacles and prep the next row
end
