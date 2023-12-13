-- M.O.B 
local s, id = GetID()

function s.initial_effect(c)
    -- Equip
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_O)
    e1:SetCode(EVENT_ATTACK_ANNOUNCE)
    e1:SetCountLimit(1)
    e1:SetTarget(s.eqtg)
    e1:SetOperation(s.eqop)
    c:RegisterEffect(e1)

    -- Increase ATK
    local e2 = Effect.CreateEffect(c)
    e2:SetType(EFFECT_TYPE_SINGLE)
    e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e2:SetRange(LOCATION_MZONE)
    e2:SetCode(EFFECT_UPDATE_ATTACK)
    e2:SetCondition(s.atkcon)
    e2:SetValue(s.atkval)
    c:RegisterEffect(e2)

    -- Increase DEF
    local e3 = Effect.CreateEffect(c)
    e3:SetType(EFFECT_TYPE_SINGLE)
    e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
    e3:SetRange(LOCATION_MZONE)
    e3:SetCode(EFFECT_UPDATE_DEFENSE)
    e3:SetCondition(s.defcon)
    e3:SetValue(s.defval)
    c:RegisterEffect(e3)
end

function s.eqfilter(c, tp)
    return c:CheckUniqueOnField(tp) and c:IsMonster() and not c:IsForbidden()
end

function s.eqtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        local g = Duel.GetMatchingGroup(s.eqfilter, tp, 0, LOCATION_EXTRA, nil, tp)
        return #g > 0 and Duel.GetLocationCount(tp, LOCATION_SZONE) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_EQUIP, nil, 1, tp, LOCATION_EXTRA)
end

function s.eqop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        local g = Duel.GetMatchingGroup(s.eqfilter, tp, 0, LOCATION_EXTRA, nil, tp)
        if #g == 0 then return end
        Duel.ConfirmCards(tp, Duel.GetFieldGroup(tp, 0, LOCATION_EXTRA))
        Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_EQUIP)
        local sg = g:Select(tp, 1, #g, nil)
        for tc in aux.Next(sg) do
            if Duel.Equip(tp, tc, c, true) then
                local e1 = Effect.CreateEffect(c)
                e1:SetType(EFFECT_TYPE_SINGLE)
                e1:SetCode(EFFECT_EQUIP_LIMIT)
                e1:SetReset(RESET_EVENT + RESETS_STANDARD)
                e1:SetValue(s.eqlimit)
                e1:SetLabelObject(c)
                tc:RegisterEffect(e1)
                tc:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD, 0, 1)
                Duel.ShuffleExtra(1 - tp)
            end
        end
    end
end

function s.eqlimit(e, c)
    return c == e:GetLabelObject()
end

function s.efilter(c)
    return c:GetFlagEffect(id) ~= 0
end

function s.atkcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetEquipGroup():IsExists(s.efilter, 1, nil)
end

function s.atkval(e, c)
    return e:GetHandler():GetEquipGroup():Filter(s.efilter, nil):GetSum(Card.GetAttack)
end

function s.defcon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetEquipGroup():IsExists(s.efilter, 1, nil)
end

function s.defval(e, c)
    return e:GetHandler():GetEquipGroup():Filter(s.efilter, nil):GetSum(Card.GetDefense)
end