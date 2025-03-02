-- basic_mining.lua

-- Function to mine the block ahead and the block above
function mineAndMove()
    turtle.dig()          -- Mine the block ahead
    turtle.digUp()        -- Mine the block above
    turtle.forward()      -- Move forward
end

-- Function to mine a 2x2 area in front and place a torch every 6 blocks
function mineAndMoveAdvanced(step)
    -- Mine the 2x2 area in front
    turtle.dig()          -- Mine the block ahead
    turtle.digUp()        -- Mine the block above
    turtle.forward()      -- Move forward
    turtle.dig()          -- Mine the block ahead
    turtle.digUp()        -- Mine the block above
    turtle.forward()      -- Move forward

    -- Place a torch on the left wall every 6 blocks
    if step % 6 == 0 then
        turtle.turnLeft()
        turtle.dig()      -- Ensure the block is clear
        turtle.place()    -- Place the torch
        turtle.turnRight()
    end
end

-- Repeat the mining process 66 times (132 / 2)
for i = 1, 66 do
    mineAndMoveAdvanced(i)
end

-- Return to the original location
for i = 1, 66 do
    turtle.back()
    turtle.back()
end

-- Drop off materials in the chest behind the turtle
turtle.turnRight()
turtle.turnRight()
for i = 1, 16 do
    turtle.select(i)
    turtle.drop()
end
turtle.turnRight()
turtle.turnRight()