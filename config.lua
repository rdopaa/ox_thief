Config = {} or Config
-- Config Version (ESX, OX, QB)
Config.Version == 'OX'

-- Config Command 
Config.Command = 'steal' -- Name Command 
Config.CommandName = 'Steal Closest Player' -- Command Name in config to keybind 

-- Config Chat Command 
Config.CommandChat = true 
Config.CommandText = 'me stealing player..' -- You gonna see a msg in the chat when you steal a player

-- Config Steal Mode (HandsUp, Dead, Both)
Config.StealMode = "HandsUp" -- Steal Mode: "HandsUp" (Only HandsUp), "Dead" (Only Dead), "Both" (Both options Dead and Handsup)
Config.StealKeyMapping = 'X' -- Key to steal

-- Config Language
Config.Language = 'es' -- Se puede cambiar dinámicamente si lo deseas

Config.Translations = {
    ['es'] = {
        ['cannot_steal_dead'] = 'No puedes robar estando muerto.',
        ['no_player_nearby'] = 'No hay jugadores cercanos para robar.',
        ['player_hands_up'] = 'El jugador no tiene las manos levantadas',
        ['stealing'] = 'Robando...',
        ['start_steal'] = 'Robar',
        ['stealing_inventory'] = 'Abriendo inventario...',
    },
    ['en'] = {
        ['cannot_steal_dead'] = 'You cannot steal while dead.',
        ['no_player_nearby'] = 'No nearby players to rob.',
        ['player_hands_up'] = 'The player does not have their hands up.',
        ['stealing'] = 'Stealing...',
        ['start_steal'] = 'Starting the steal...',
        ['stealing_inventory'] = 'Opening inventory...',
    }
}

-- Dont touch
function Config.GetTranslation(key)
    return Config.Translations[Config.Language][key] or key 
end