-- TODO incorporate quota from https://github.com/MT-CTF/capturetheflag/pull/803

event_handlers={}

local playerdata = modlib.minetest.playerdata(function()
	return {last_placed = modlib.minetest.get_gametime(), required_cooldown = 0}
end)

local config = modlib.mod.configuration()

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
    assert(type(callback) == "function")
    table.insert(event_handlers, callback)
    return #table
end

function unregister_on_placenode(index)
    assert(event_handlers[index])
    event_handlers[index]=nil
end

minetest.register_on_placenode(function(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    local name = placer:get_player_name()
    local data = playerdata[name]
    if modlib.minetest.get_gametime() - data.last_placed < data.required_cooldown then
        minetest.swap_node(pos, oldnode)
        return true
    end
    data.last_placed = modlib.minetest.get_gametime()
    local required_cooldown_for_player=get_max_cooldown(newnode.name)
    data.required_cooldown = required_cooldown_for_player
    hud_timers.add_timer(name, {name="Place Limit", duration=required_cooldown_for_player})
    for _, handler in pairs(event_handlers) do
        handler(pos, newnode, placer, oldnode, itemstack, pointed_thing)
    end
end)
