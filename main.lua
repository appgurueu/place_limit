event_handlers={}

modlib.player.add_playerdata_function(function(playerdata)
    playerdata.last_placed = minetest.get_gametime()
end)
modlib.player.set_property_default("required_cooldown", 0)

modlib.log.create_channel("place_limit")

local config = modlib.conf.import("place_limit", {
    type="table",
    children={
        cooldown={
            type="table",
            children={
                default={
                    type="number",
                    range={0}
                },
                by_name= {
                    type = "table",
                    keys = { type = "string" },
                    values = { type = "number", range = { 0 } }
                },
                by_group= {
                    type = "table",
                    keys = { type = "string" },
                    values = { type = "number", range = { 0 } }
                }
            }
        }
    }
})

modlib.table.add_all(getfenv(1), config)

function get_cooldown_by_name(nodename)
    return cooldown.by_name[nodename]
end

function get_cooldown_by_group(groupname)
    return cooldown.by_group[groupname]
end

function get_max_cooldown(nodename)
    local cooldowns={}
    cooldowns[1]=get_cooldown_by_name(nodename)
    local groups=minetest.registered_nodes[nodename].groups
    for groupname, groupvalue in pairs(groups) do
        local group_cooldown=get_cooldown_by_group(groupname)
        if group_cooldown then
            table.insert(cooldowns, groupvalue*group_cooldown)
        end
    end
    if modlib.table.is_empty(cooldowns) then
        return cooldown.default
    end
    return modlib.table.max(cooldowns)
end

function register_on_placenode(callback)
    if type(callback) ~= "function" then
        modlib.log.write("place_limit", "Warning : register_on_placenode called with a non-function. Ignoring.")
        return
    end
    table.insert(event_handlers, callback)
    return #table
end

function unregister_on_placenode(index)
    if event_handlers[index] then
        event_handlers[index]=nil
        return true
    end
    modlib.log.write("place_limit", "Warning : unregister_on_placenode called with an invalid index. Ignoring.")
    return false
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    local name = placer:get_player_name()
    if minetest.get_gametime() - modlib.player.get_property(name, "last_placed") < modlib.player.get_property(name, "required_cooldown") then
        minetest.swap_node(pos, oldnode)
        return true
    end
    modlib.player.set_property(name, "last_placed", minetest.get_gametime())
    local required_cooldown_for_player=get_max_cooldown(newnode.name)
    modlib.player.set_property(name, "required_cooldown",required_cooldown_for_player)
    hud_timers.add_timer(name, {name="Place Limit", duration=required_cooldown_for_player})
    for _, handler in pairs(event_handlers) do
        handler(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    end
end)