-- Franky-Radical-Beam
local s, id = GetID()
function s.initial_effect(c)
    -- Cannot be destroyed by battle and does not take battle damage
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
    e1:SetValue(1)
    c:RegisterEffect(e1)
    local e2 = e1:Clone()
    e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
    c:RegisterEffect(e2)

    -- Inflict damage and destroy opponent's monster after battling
    local e3 = Effect.CreateEffect(c)
    e3:SetCategory(CATEGORY_DAMAGE)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e3:SetCode(EVENT_BATTLE_END)
    e3:SetCondition(s.damageCondition)
    e3:SetTarget(s.damageTarget)
    e3:SetOperation(s.damageOperation)
    c:RegisterEffect(e3)

    -- Tribute my monsters
    local e4 = Effect.CreateEffect(c)
    e4:SetDescription(500)
    e4:SetCategory(CATEGORY_DAMAGE)
    e4:SetType(EFFECT_TYPE_IGNITION)
    e4:SetRange(LOCATION_MZONE)
    e4:SetCountLimit(1, id + 1)
    e4:SetCondition(s.tributeCondition)
    e4:SetCost(s.tributeCost)
    e4:SetTarget(s.tributeTarget)
    e4:SetOperation(s.tributeOperation)
    c:RegisterEffect(e4)

    -- Tribute opponent's monsters
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(92)
    e5:SetCategory(CATEGORY_DAMAGE)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1, id + 2)
    e5:SetCondition(s.tributeOpponentCondition)
    e5:SetCost(s.tributeOpponentCost)
    e5:SetTarget(s.tributeOpponentTarget)
    e5:SetOperation(s.tributeOpponentOperation)
    c:RegisterEffect(e5)
end

function s.damageCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetAttackTarget() == e:GetHandler() and e:GetHandler():IsAttackPos()
end

function s.damageTarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local atk = Duel.GetAttacker():GetBaseAttack()
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(atk)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, atk)
end

function s.damageOperation(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
    local tc = Duel.GetAttackTarget()
    if tc:IsRelateToBattle() then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end

function s.tributeCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end

function s.tributeCost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckReleaseGroup(tp, nil, 1, nil) end
    local g = Duel.SelectReleaseGroup(tp, nil, 1, 1, nil)
    Duel.Release(g, REASON_COST)
end

function s.tributeTarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1000)
end

function s.tributeOperation(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
end

function s.tributeOpponentCondition(e, tp, eg, ep, ev, re, r, rp)
    return Duel.GetTurnPlayer() == tp
end

function s.tributeOpponentCost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.CheckReleaseGroup(1 - tp, nil, 1, nil) end
    local g = Duel.SelectReleaseGroup(1 - tp, nil, 1, 1, nil)
    Duel.Release(g, REASON_COST)
end

function s.tributeOpponentTarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    Duel.SetTargetPlayer(1 - tp)
    Duel.SetTargetParam(1000)
    Duel.SetOperationInfo(0, CATEGORY_DAMAGE, nil, 0, 1 - tp, 1000)
end

function s.tributeOpponentOperation(e, tp, eg, ep, ev, re, r, rp)
    local p, d = Duel.GetChainInfo(0, CHAININFO_TARGET_PLAYER, CHAININFO_TARGET_PARAM)
    Duel.Damage(p, d, REASON_EFFECT)
end
