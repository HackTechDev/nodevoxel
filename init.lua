
-- File functions
-- http://lua-users.org/wiki/FileInputOutput

-- see if the file exists
function file_exists(file)
  local f = io.open(file, "rb")
  if f then f:close() end
  return f ~= nil
end

-- get all lines from a file, returns an empty 
-- list/table if the file does not exist
function lines_from(file)
  if not file_exists(file) then return {} end
  lines = {}
  for line in io.lines(file) do 
    lines[#lines + 1] = line
  end
  return lines
end

-- Node Voxel


function generateNodeVoxel(file)
    local lines = lines_from(file)

    -- print all line numbers and their contents
    for k,v in pairs(lines) do
      if k >= 4 then -- Pass the description header
        x, y, z, cubeColor = v:match("([^,]+) ([^,]+) ([^,]+) ([^,]+)")

        minetest.register_node("nodevoxel:cube" .. cubeColor, {
            description = "Nodevoxel Cube" .. cubeColor,
            tiles = {
                "nodevoxel_cube_up.png^[colorize:#" .. cubeColor .. "50",
                "nodevoxel_cube_down.png^[colorize:#" .. cubeColor .. "50",
                "nodevoxel_cube_right.png^[colorize:#" .. cubeColor .. "50",
                "nodevoxel_cube_left.png^[colorize:#" .. cubeColor .. "50",
                "nodevoxel_cube_back.png^[colorize:#" .. cubeColor .. "50",
                "nodevoxel_cube_front.png^[colorize:#" .. cubeColor .. "50"
        },
            is_ground_content = true,

            groups = {
                cracky = 3
        },
        })

        print (k .. ' : ', x, y, z, cubeColor)
      end
    end
end

-- Object voxel list
local aObjectVoxel = {'obj01.txt'}

for key,value in pairs(aObjectVoxel) do
   print(key, value)
   generateNodeVoxel(value)
end

-- Chat commands

minetest.register_chatcommand("nodevoxel", {
    params = "<entity name> <entity param>",
    description = "Add an nodevoxel with parameters",
    func = function(user, args)

        if args == "" then
            return false, "Parameters required."
        end

        local nodevoxelAction, nodevoxelParam = args:match("^(%S+)%s(%S+)$")

        if not nodevoxelParam then
            return false, "Entity parameters required"
        end

        local player = minetest.get_player_by_name(user)
        if not player then
            return false, "Player not found"
        end

        local fmt = "Add an %s nodevoxel at: (%.2f,%.2f,%.2f)"

        local pos = player:getpos()

        -- /nodevoxel add 1
        if nodevoxelAction == "add" then
            minetest.chat_send_player(user, "Add nodevoxel  " .. nodevoxelParam)

            if nodevoxelParam == "01" then
                -- y = height

                local file = "obj" .. nodevoxelParam .. ".txt"
                local lines = lines_from(file)

                -- print all line numbers and their contents
                for k,v in pairs(lines) do
                  if k >= 4 then
                    x, y, z, cubeColor = v:match("([^,]+) ([^,]+) ([^,]+) ([^,]+)")

                    minetest.set_node({x=pos.x + x, y=pos.y + z, z=pos.z + y}, {name="nodevoxel:cube" .. cubeColor})
                    print (k .. ' : ', x, y, z, cubeColor)
                  end
                end

                return true, fmt:format(args, pos.x, pos.y, pos.z)
            end
        else
            return false, "No nodevoxel added"
        end

        return false, "No nodevoxel added"
    end
})
