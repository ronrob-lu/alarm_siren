-- Siren Block Mod for Luanti/Minetest
-- Adds a siren block that can be manually activated by double-clicking

-- Store last punch time for double-click detection
local last_punch = {}

-- Register the siren node
minetest.register_node("alarm_siren:siren", {
    description = "Siren Block\nDouble-click to toggle on/off",
    tiles = {"siren.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {cracky = 3, oddly_breakable_by_hand = 2},
    
    -- Tooltip showing active/inactive status
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Siren Block (Inactive)")
        meta:set_int("active", 0)
    end,
    
    -- Handle double-click activation (on_punch)
    on_punch = function(pos, node, puncher, pointed_thing)
        local pname = puncher:get_player_name()
        local now = minetest.get_us_time()
        local key = pname .. ":" .. minetest.pos_to_string(pos)
        
        if last_punch[key] and (now - last_punch[key]) < 300000 then
            local meta = minetest.get_meta(pos)
            local active = meta:get_int("active")
            
            if active == 0 then
                meta:set_int("active", 1)
                meta:set_string("infotext", "Siren Block (Active)")
                minetest.sound_play("sirene", {pos = pos, gain = 0.5, max_hear_distance = 64})
                local timer = minetest.get_node_timer(pos)
                timer:start(3)
            else
                meta:set_int("active", 0)
                meta:set_string("infotext", "Siren Block (Inactive)")
                local timer = minetest.get_node_timer(pos)
                timer:stop()
            end
            
            last_punch[key] = nil
            return true
        else
            last_punch[key] = now
            minetest.after(0.5, function()
                if last_punch[key] == now then
                    last_punch[key] = nil
                end
            end)
            return false
        end
    end,
    
    -- Timer callback for recurring sound
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local active = meta:get_int("active")
        
        if active == 1 then
            minetest.sound_play("sirene", {pos = pos, gain = 0.5, max_hear_distance = 64})
            return true
        end
        return false
    end,
    
    drop = "alarm_siren:siren",
})

-- Provide a simple crafting recipe (optional, can be removed if not desired)
minetest.register_craft({
    output = "alarm_siren:siren",
    recipe = {
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
        {"default:steel_ingot", "default:copper_ingot", "default:steel_ingot"},
        {"default:steel_ingot", "default:steel_ingot", "default:steel_ingot"},
    },
})

minetest.log("action", "[MOD] Alarm Siren loaded successfully")
