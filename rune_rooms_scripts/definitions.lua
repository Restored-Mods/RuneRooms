--This file just defines the add callback functions so autocomplete works

---Adds a callback to be executed
---@param callback ModCallbacks | CustomCallback | RuneRoomsCustomCallback
---@param funct function
---@param filter any
function RuneRooms:AddCallback(callback, funct, filter)
end


---Adds a callback to be executed with a given priority
---@param callback ModCallbacks | CustomCallback | RuneRoomsCustomCallback
---@param priority CallbackPriority | integer
---@param funct function
---@param filter any
function RuneRooms:AddPriorityCallback(callback, priority, funct, filter)
end