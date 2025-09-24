Config = {} or Config
-- Config Framework (ESX, QB) 
Config.Version = 'ESX'

-- Config Inventory (ESX, OX, QB)
Config.Inventory = 'OX'

-- Config Security
Config.MaxDistance = 10 -- Max Distance to steal a player

-- Config Command 
Config.Command = 'steal' -- Name Command 
Config.CommandName = 'Steal Closest Player' -- Command Name in config to keybind 

-- Config Chat Command 
Config.CommandChat = true 
Config.CommandText = 'me stealing player..' -- You gonna see a msg in the chat when you steal a player

-- Config Steal Mode (HandsUp, Dead, Both)
Config.StealMode = "HandsUp" -- Steal Mode: "HandsUp" (Only HandsUp), "Dead" (Only Dead), "Both" (Both options Dead and Handsup)
Config.StealKeyMapping = 'X' -- Key to steal

-- Config Webhooks
Config.DiscordWebhooks = {
    Steal = "YOUR_GENERAL_WEBHOOK_URL",
}

-- Config Language
Config.Language = 'es'

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
    },
    ['pl'] = {
        ['cannot_steal_dead'] = 'Nie możesz kraść będąc martwym.',
        ['no_player_nearby'] = 'Brak pobliskich graczy do okradzenia.',
        ['player_hands_up'] = 'Gracz nie ma rąk w górze.',
        ['stealing'] = 'Kradzież...',
        ['start_steal'] = 'Rozpoczęcie kradzieży...',
        ['stealing_inventory'] = 'Otwieranie ekwipunku...',
    },
    ['fr'] = {
        ['cannot_steal_dead'] = 'Vous ne pouvez pas voler en étant mort.',
        ['no_player_nearby'] = 'Aucun joueur à proximité à voler.',
        ['player_hands_up'] = 'Le joueur n\'a pas les mains en l\'air.',
        ['stealing'] = 'Vol en cours...',
        ['start_steal'] = 'Démarrage du vol...',
        ['stealing_inventory'] = 'Ouverture de l\'inventaire...',
    },
    ['de'] = {
        ['cannot_steal_dead'] = 'Du kannst nicht stehlen, wenn du tot bist.',
        ['no_player_nearby'] = 'Keine Spieler in der Nähe zum Stehlen.',
        ['player_hands_up'] = 'Der Spieler hat die Hände nicht oben.',
        ['stealing'] = 'Stehlen...',
        ['start_steal'] = 'Starte den Diebstahl...',
        ['stealing_inventory'] = 'Öffne Inventar...',
    },
    ['it'] = {
        ['cannot_steal_dead'] = 'Non puoi rubare mentre sei morto.',
        ['no_player_nearby'] = 'Nessun giocatore nelle vicinanze da derubare.',
        ['player_hands_up'] = 'Il giocatore non ha le mani alzate.',
        ['stealing'] = 'Rubando...',
        ['start_steal'] = 'Inizio del furto...',
        ['stealing_inventory'] = 'Apertura inventario...',
    },
    ['pt'] = {
        ['cannot_steal_dead'] = 'Você não pode roubar enquanto estiver morto.',
        ['no_player_nearby'] = 'Nenhum jogador próximo para roubar.',
        ['player_hands_up'] = 'O jogador não está com as mãos para cima.',
        ['stealing'] = 'Roubando...',
        ['start_steal'] = 'Iniciando o roubo...',
        ['stealing_inventory'] = 'Abrindo inventário...',
    },
    ['ru'] = {
        ['cannot_steal_dead'] = 'Вы не можете красть, будучи мертвым.',
        ['no_player_nearby'] = 'Нет игроков поблизости, чтобы ограбить.',
        ['player_hands_up'] = 'У игрока не подняты руки.',
        ['stealing'] = 'Воровство...',
        ['start_steal'] = 'Начинаю кражу...',
        ['stealing_inventory'] = 'Открытие инвентаря...',
    },
    ['nl'] = {
        ['cannot_steal_dead'] = 'Je kunt niet stelen terwijl je dood bent.',
        ['no_player_nearby'] = 'Geen spelers in de buurt om te beroven.',
        ['player_hands_up'] = 'De speler heeft zijn handen niet omhoog.',
        ['stealing'] = 'Stelen...',
        ['start_steal'] = 'Begin met stelen...',
        ['stealing_inventory'] = 'Voorraad openen...',
    },
    ['zh'] = {
        ['cannot_steal_dead'] = '你死了就不能偷东西。',
        ['no_player_nearby'] = '附近没有玩家可供抢劫。',
        ['player_hands_up'] = '玩家没有举起双手。',
        ['stealing'] = '偷东西...',
        ['start_steal'] = '开始偷东西...',
        ['stealing_inventory'] = '打开库存...',
    },
}

-- Dont touch
function Config.GetTranslation(key)
    return Config.Translations[Config.Language][key] or key
end