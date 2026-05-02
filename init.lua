-- Alarm Siren Mod for Luanti/Minetest
-- Adds an alarm siren block that can be manually activated by double-clicking

local modname = "alarm_siren"

-- Store last punch time for double-click detection
local last_punch_time = {}

-- Register the siren node
minetest.register_node("alarm_siren:siren", {
    description = "Alarm Siren\nDouble-click to toggle on/off",
    tiles = {"siren.png"},
    paramtype2 = "facedir",
    is_ground_content = false,
    groups = {cracky = 3, oddly_breakable_by_hand = 2},
    sounds = minetest.defaults.node_sound_stone_defaults(),
    
    -- Tooltip showing active/inactive status
    after_place_node = function(pos, placer, itemstack, pointed_thing)
        -- Set initial metadata (inactive)
        local meta = minetest.get_meta(pos)
        meta:set_string("infotext", "Alarm Siren (Inactive)")
        meta:set_int("active", 0)
    end,
    
    -- Handle double-click activation (on_punch)
    on_punch = function(pos, node, puncher, pointeds)
        local player_name = puncher:get_player_name()
        local current_time = minetest.get_us_time()
        
        -- Check if this is a double-click (within 300ms)
        if last_punch_time[player_name] and 
           (current_time - last_punch_time[player_name]) < 300000 then
            
            -- This is a double-click, toggle the siren
            local meta = minetest.get_meta(pos)
            local active = meta:get_int("active")
            
            if active == 0 then
                -- Activate the siren
                meta:set_int("active", 1)
                meta:set_string("infotext", "Alarm Siren (Active)")
                
                -- Play the siren sound
                minetest.sound_play("alarm_siren_sirene", {pos = pos, gain = 0.5, max_hear_distance = 64})
                
                -- Schedule recurring sound while active (every 3 seconds)
                local timer = minetest.get_node_timer(pos)
                timer:start(3)
            else
                -- Deactivate the siren
                meta:set_int("active", 0)
                meta:set_string("infotext", "Alarm Siren (Inactive)")
                
                -- Stop the timer
                local timer = minetest.get_node_timer(pos)
                timer:stop()
            end
            
            -- Reset last punch time to prevent triple-click issues
            last_punch_time[player_name] = 0
            
        else
            -- Single click, just record the time
            last_punch_time[player_name] = current_time
            
            -- Clean up old entries after 1 second
            minetest.after(1, function()
                if last_punch_time[player_name] == current_time then
                    last_punch_time[player_name] = nil
                end
            end)
        end
    end,
    
    -- Timer callback for recurring sound
    on_timer = function(pos, elapsed)
        local meta = minetest.get_meta(pos)
        local active = meta:get_int("active")
        
        if active == 1 then
            -- Play the siren sound again
            minetest.sound_play("alarm_siren_sirene", {pos = pos, gain = 0.5, max_hear_distance = 64})
            return true -- Continue timer
        else
            return false -- Stop timer
        end
    end,
    
    -- Drop the siren item when dug
    drop = "alarm_siren:siren",
})

-- Register the creative inventory item
minetest.register_craftitem("alarm_siren:siren", {
    description = "Alarm Siren\nDouble-click placed block to toggle on/off",
    inventory_image = "siren.png",
    on_place = function(itemstack, placer, pointed_thing)
        -- Use the node's on_place behavior
        return minetest.default_place_node_simple(itemstack, placer, pointed_thing)
    end,
})

-- Register the sound file
minetest.register_sound("alarm_siren_sirene", {
    name = "alarm_siren_sirene",
    filename = minetest.get_mod_path(modname) .. "/sounds/sirene.ogg",
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
