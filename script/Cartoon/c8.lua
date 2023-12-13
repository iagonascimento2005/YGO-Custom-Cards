-- Astrid
local s,id=GetID()
function s.initial_effect(c)

    -- refletir dano
    local e1=Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_REFLECT_BATTLE_DAMAGE)
    e1:SetValue(1)
    c:RegisterEffect(e1)

    -- Imune a Dano
    local e2=Effect.CreateEffect(c)
        e2:SetType(EFFECT_TYPE_SINGLE)
        e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
        e2:SetValue(1)
        c:RegisterEffect(e2)
    
    -- Não pode ser destruido em batalha
    local e3=Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e3:SetValue(1)
    c:RegisterEffect(e3)

    --control
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE)
	e4:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_CHANGE_CONTROL)
	c:RegisterEffect(e4)
end
