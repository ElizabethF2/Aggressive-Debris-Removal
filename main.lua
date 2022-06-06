function init()
  MAX_ITEMS = GetInt("savegame.mod.max_items")
	if MAX_ITEMS == 0 then MAX_ITEMS = 1000 end
  RADIUS = GetInt("savegame.mod.radius")
  if RADIUS == 0 then RADIUS = 999999999 end
end

function tick()
  -- Calculate the bounding box around the player
  local pos = GetPlayerPos()
  local min = VecAdd(pos, Vec(-RADIUS, -RADIUS, -RADIUS))
	local max = VecAdd(pos, Vec(RADIUS, RADIUS, RADIUS))

  -- Get the bodies within the bounding box and check if they're over the limit
  local bodies = QueryAabbBodies(min, max)
  local remaining = table.getn(bodies) - MAX_ITEMS
  if remaining > 0 then
    -- Remove objects the player can't see until the total is within the limit
    -- XXX Objects are iterated in reverse since the engine places newly created debris at the end of the list
    --     This mod will need to be updated if this behavior changes
    local i
    for i = table.getn(bodies), 1, -1 do
      local body = bodies[i]
      if not IsBodyVisible(body, RADIUS) then
        Delete(bodies[i])
        bodies[i] = nil
        remaining = remaining - 1
        if remaining == 0 then
          break
        end
      end
    end

    -- If there are still too many bodies, remove objects the player can see until the limit is met
    i = table.getn(bodies)
    while remaining > 0 do
      local body = bodies[i]
      if body ~= nil then
        Delete(bodies[i])
        remaining = remaining - 1
      end
      i = i - 1
    end
  end
end
