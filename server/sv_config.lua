-- https://forge.plebmasters.de/objects
Config.CircleZones = {
    -- Rarity (1-5), 1 = guaranteed, 2 = very common, 5 = rare.
    -- Don't use 1 if you want different types of items to spawn.

    -- spacing: how far apart the objects should be.
    -- tool: should a tool be required? if so, what name.
    -- maxCount: how many objects can be in an area.
    -- blipInfo: if there should be a blip. Use examples below for help.
    -- minQty/maxQty: how much you may get from gathering from a node.
	Weed = {
        coords = vector3(2640.32, 4192.69, 42.96), radius = 40.0, spacing = 5, tool = nil, maxCount = 14,
        animInfo = {anim = 'world_human_gardener_plant', dict = nil},
        info = {{model = 'prop_weed_02', target = `prop_weed_02`, item = 'cannabis', label = 'Cannabis', minQty = 1, maxQty = 3, rarity = 1}}
    },
    Coke = {
        coords = vector3(2058.73, 5110.6, 46.3), radius = 40.0, spacing = 5, tool = nil, maxCount = 14,
        animInfo = {anim = 'world_human_gardener_plant', dict = nil},
        info = {{model = 'prop_plant_fern_02a', target = `prop_plant_fern_02a`, item = 'coca_leaf', label = 'Coca Leaf', minQty = 1, maxQty = 3, rarity = 1}}
    },
    Heroin = {
        coords = vector3(-565.44, 6243.9, 9.08), radius = 40.0, spacing = 5, tool = nil, maxCount = 14,
        animInfo = {anim = 'world_human_gardener_plant', dict = nil},
        info = {{model = 'prop_plant_fern_02b', target = `prop_plant_fern_02b`, item = 'poppy_resin', label = 'Poppy Resin', minQty = 1, maxQty = 3, rarity = 1}}
    },
    LSA = {
        coords = vector3(-2484.94, 3023.26, 32.83), radius = 30.0, spacing = 5, tool = nil, maxCount = 10,
        animInfo = {anim = 'PROP_HUMAN_BUM_BIN', dict = nil},
        info = {{model = 'prop_barrel_exp_01a', target = `prop_barrel_exp_01a`, item = 'lsa', label = 'LSA', minQty = 1, maxQty = 3, rarity = 1}}
    },

    Trees = {
        coords = vector3(1986.28, 3417.64, 42.66), radius = 50.0, spacing = 10, tool = 'hatchet', maxCount = 16,
        blipInfo = {label = 'Woodcutting', blipSprite = 540, blipColour = 2},
        animInfo = {anim = 'plyr_front_takedown', dict = 'melee@hatchet@streamed_core'},
        toolInfo = {toolModel = 'prop_w_me_hatchet', xPos = 0.08, yPos = -0.1, zPos = -0.03, xRot = -75.0, yRot = 0.0, zRot = 10.0},
        info = {
            {model = 'prop_tree_fallen_pine_01', target = `prop_tree_fallen_pine_01`, item = 'pine_log', label = 'Pine Log', minQty = 1, maxQty = 1, rarity = 2},
            {model = 'prop_tree_olive_cr2', target = `prop_tree_olive_cr2`, item = 'olive_log', label = 'Olive Log', minQty = 1, maxQty = 1, rarity = 3},
            {model = 'prop_tree_eng_oak_cr2', target = `prop_tree_eng_oak_cr2`, item = 'oak_log', label = 'Oak Log', minQty = 1, maxQty = 1, rarity = 4}        
        }
    },
    Ores = {
        coords = vector3(2948.56, 2795.15, 40.74), radius = 35.0, spacing = 5, tool = 'pickaxe', maxCount = 12,
        blipInfo = {label = 'Mine', blipSprite = 1, blipColour = 22},
        animInfo = {anim = 'ground_attack_on_spot', dict = 'melee@large_wpn@streamed_core'},
        toolInfo = {toolModel = 'prop_tool_pickaxe', xPos = 0.08, yPos = -0.1, zPos = -0.03, xRot = -75.0, yRot = 0.0, zRot = 10.0},
        info = {
            {model = 'prop_rock_4_b', target = `prop_rock_4_b`, item = 'ore_coal', label = 'Coal Ore', minQty = 1, maxQty = 1, rarity = 2},
            {model = 'prop_rock_3_f', target = `prop_rock_3_f`, item = 'ore_iron', label = 'Iron Ore', minQty = 1, maxQty = 1, rarity = 3},
            {model = 'prop_rock_3_d', target = `prop_rock_3_d`, item = 'ore_gold', label = 'Gold Ore', minQty = 1, maxQty = 1, rarity = 4},
            {model = 'csx_coastboulder_00_', target = `csx_coastboulder_00_`, item = 'ore_diamond', label = 'Diamond Ore', minQty = 1, maxQty = 1, rarity = 5}
        }
    }
}