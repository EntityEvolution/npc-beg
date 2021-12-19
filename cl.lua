local cfg <const> = {
    dict = 'amb@world_human_bum_freeway@male@base',
    anim = 'base',
    begKey = 38,
    begDistance = 3.0,
    begDuration = math.random(5, 5), -- secs
    begPolice = 2, -- The lower the less chances of alerting the police,
    begStatus = false,
    waitBetweenRob = true,
    locales = {
        recentlyRobbed = 'You have recently robbed someone!',
        begMoney = 'Begging for money'
    }
}

local CreateThread = CreateThread
local Wait = Wait

local function notify(message)
    SetNotificationTextEntry('STRING')
    AddTextComponentString(message)
    DrawNotification(0, 1)
end

local function beg(targetPed)
    if not cfg.begStatus then
        cfg.begStatus = true
        RequestAnimDict(cfg.dict)
        while not HasAnimDictLoaded(cfg.dict) do
            Wait(10)
        end

        TaskStandStill(targetPed, cfg.begDuration * 1000)
        FreezeEntityPosition(targetPed, true)
        TaskPlayAnim(PlayerPedId(), cfg.dict, cfg.anim, 1.5, 1.5, cfg.begDuration * 1000, 1, 0, 0, 0, 0)
        RemoveAnimDict(cfg.dict)
        Wait(cfg.begDuration * 1000)
        local chances = math.random(1, 10)
        if chances < cfg.begPolice then
            -- Add your event or export for alerting the police.
        else
            TriggerServerEvent('beg:randomizer')
        end
        FreezeEntityPosition(targetPed, false)
        ClearPedTasks(PlayerPedId())
        SetTimeout(60000, function() cfg.begStatus = false end)
    end
end

CreateThread(function()
    while true do
        local playerId = PlayerId()
        if IsControlJustPressed(0, cfg.begKey) then
            print('test')
            if not cfg.begStatus then
                local aiming, targetPed = GetEntityPlayerIsFreeAimingAt(playerId)
                if aiming then
                    local ped = PlayerPedId()
                    local coords = GetEntityCoords(ped, true)
                    local targetCoords = GetEntityCoords(targetPed, true)

                    if DoesEntityExist(targetPed) and IsEntityAPed(targetPed) and not IsEntityDead(targetPed) then
                        if #(coords - targetCoords) < cfg.begDistance then
                            beg(targetPed)
                            notify(cfg.locales.begMoney)
                        end
                    end
                end
            else
                notify(cfg.locales.recentlyRobbed)
            end
        end
        Wait(5)
    end
end)