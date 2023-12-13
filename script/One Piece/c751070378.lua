-- Ganância da Nami
local s, id = GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_HANDES + CATEGORY_DRAW)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
    -- Gain ATK
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 1))
    e2:SetCategory(CATEGORY_ATKCHANGE)
    e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
    e2:SetType(EFFECT_TYPE_IGNITION)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCountLimit(1, {id, 1})
    e2:SetCondition(s.atkCondition)
    e2:SetCost(aux.bfgcost)
    e2:SetTarget(s.atktg)
    e2:SetOperation(s.atkop)
    c:RegisterEffect(e2)
end
s.listed_series = {0xa05}
function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local h1 = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
        if e:GetHandler():IsLocation(LOCATION_HAND) then
            h1 = h1 - 1
        end
        local h2 = Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)
        return (h1 + h2 > 0) and (Duel.IsPlayerCanDraw(tp, h1) or h1 == 0) and (Duel.IsPlayerCanDraw(1 - tp, h2) or h2 == 0)
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, PLAYER_ALL, 1)
    Duel.SetOperationInfo(0, CATEGORY_DRAW, nil, 0, PLAYER_ALL, 1)
end
function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local h1 = Duel.GetFieldGroupCount(tp, LOCATION_HAND, 0)
    local h2 = Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND)
    local g = Duel.GetFieldGroup(tp, LOCATION_HAND, LOCATION_HAND)
    Duel.SendtoGrave(g, REASON_EFFECT + REASON_DISCARD)
    Duel.BreakEffect()
    Duel.Draw(tp, h1, REASON_EFFECT)
    Duel.Draw(1 - tp, h2, REASON_EFFECT)
end
function s.atkCondition(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():IsLocation(LOCATION_GRAVE)
end
function s.atktg(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then
        return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() and chkc:IsSetCard(0xa05)
    end
    if chk == 0 then
        return Duel.IsExistingTarget(s.atkfilter, tp, LOCATION_MZONE, 0, 1, nil)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_ATKDEF)
    Duel.SelectTarget(tp, s.atkfilter, tp, LOCATION_MZONE, 0, 1, 1, nil)
end
function s.atkop(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_END, 2)
        e1:SetValue(2000)
        tc:RegisterEffect(e1)
    end
end
