-- 🔥 LANDI SCRIPTS – INSTALL FILE
-- ============================================
-- 📦 OX INVENTORY ITEMS + 🗄️ OPTIONAL SQL SETUP
-- ============================================


-- ============================================
-- 📦 OX INVENTORY ITEMS
-- ============================================

-- ➤ Add these inside:
-- ox_inventory/data/items.lua

-- MATERIALS

['iron'] = {
    label = 'Iron',
    weight = 100,
    stack = true,
    close = true
},

['copper'] = {
    label = 'Copper',
    weight = 100,
    stack = true,
    close = true
},

-- GUN PARTS

['gun_body'] = {
    label = 'Gun Body',
    weight = 500,
    stack = true,
    close = true
},

['gun_trigger'] = {
    label = 'Gun Trigger',
    weight = 200,
    stack = true,
    close = true
},

['gun_barrel'] = {
    label = 'Gun Barrel',
    weight = 400,
    stack = true,
    close = true
},


-- ============================================
-- 🔫 WEAPON ITEMS (OX INVENTORY)
-- ============================================

-- ➤ Only needed if you use item-based weapons

['weapon_pistol'] = {
    label = 'Pistol',
    weight = 1000,
    stack = false
},

['weapon_smg'] = {
    label = 'SMG',
    weight = 1500,
    stack = false
},

['weapon_assaultrifle'] = {
    label = 'AK-47',
    weight = 2500,
    stack = false
},


-- ============================================
-- 🗄️ SQL SETUP (OPTIONAL – XP SYSTEM)
-- ============================================

-- ➤ Use this if you want to save XP in database

-- CREATE TABLE IF NOT EXISTS landi_crafting (
--     identifier VARCHAR(60) PRIMARY KEY,
--     xp INT DEFAULT 0
-- );


-- ============================================
-- ⚙️ TEST COMMANDS
-- ============================================

-- Give yourself items in-game:

-- /giveitem iron 50
-- /giveitem copper 50
-- /giveitem gun_body 5
-- /giveitem gun_trigger 5
-- /giveitem gun_barrel 5


-- ============================================
-- 🔄 FINAL STEP
-- ============================================

-- restart ox_inventory
-- restart landi_scripts