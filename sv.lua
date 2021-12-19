local cfg <const> = {
    minMoney = 50,
    maxMoney = 1000,
    recentlyRobbed = false
}

RegisterNetEvent('beg:randomizer', function()
    local playerId <const> = source
    if playerId > 0 then
        if cfg.recentlyRobbed then
            DropPlayer(playerId, 'Sussy baka')
        end
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer then
            cfg.recentlyRobbed = true
            xPlayer.addMoney(math.random(cfg.minMoney, cfg.maxMoney))
            SetTimeout(60000, function() cfg.recentlyRobbed = false end)
        end

    end
end)