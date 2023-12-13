-- Kizaru Marine-Ford A.T.K
local s, id = GetID()

function s.initial_effect(c)
    -- Fusion material
    c:EnableReviveLimit()
    Fusion.AddProcMixN(c, true, true, aux.FilterBoolFunctionEx(Card.IsSetCard, 0xa05), 3)
    Fusion.AddContactProc(c, s.contactfil, s.contactop, nil, nil, nil, false)

    -- Special Summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_CONTINUOUS)
    e1:SetCode(EVENT_TO_GRAVE)
    e1:SetOperation(s.spr)
    c:RegisterEffect(e1)

    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_F)
    e2:SetRange(LOCATION_GRAVE)
    e2:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e2:SetCondition(s.spcon)
    e2:SetTarget(s.sptg)
    e2:SetOperation(s.spop)
    e2:SetLabelObject(e1)
    c:RegisterEffect(e2)

    -- Destroy cards
    local e3 = Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(id, 1))
    e3:SetCategory(CATEGORY_DESTROY)
    e3:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e3:SetCode(EVENT_SPSUMMON_SUCCESS)
    e3:SetCondition(s.descon)
    e3:SetTarget(s.destg)
    e3:SetOperation(s.desop)
    c:RegisterEffect(e3)

    -- Special Summon from Graveyard and destroy Spells/Traps
    local e4 = Effect.CreateEffect(c)
    e4:SetCategory(CATEGORY_SPECIAL_SUMMON + CATEGORY_DESTROY)
    e4:SetType(EFFECT_TYPE_FIELD + EFFECT_TYPE_TRIGGER_O)
    e4:SetCode(EVENT_PHASE + PHASE_STANDBY)
    e4:SetRange(LOCATION_GRAVE)
    e4:SetCondition(s.spcon2)
    e4:SetTarget(s.sptg2)
    e4:SetOperation(s.spop2)
    e4:SetLabelObject(e1)
    c:RegisterEffect(e4)

    -- Tribute and destroy monster effect
    local e5 = Effect.CreateEffect(c)
    e5:SetDescription(502)
    e5:SetCategory(CATEGORY_DESTROY)
    e5:SetType(EFFECT_TYPE_IGNITION)
    e5:SetRange(LOCATION_MZONE)
    e5:SetCountLimit(1, {id, 2})
    e5:SetCost(s.descost3)
    e5:SetTarget(s.destg3)
    e5:SetOperation(s.desop3)
    c:RegisterEffect(e5)

    -- Decrease opponent's monster ATK effect
    local e6 = Effect.CreateEffect(c)
    e6:SetDescription(551)
    e6:SetCategory(CATEGORY_ATKCHANGE)
    e6:SetType(EFFECT_TYPE_IGNITION)
    e6:SetRange(LOCATION_MZONE)
    e6:SetCountLimit(1, {id, 3})
    e6:SetTarget(s.target)
    e6:SetOperation(s.activate)
    c:RegisterEffect(e6)
end

function s.contactfil(tp)
    local g = Duel.GetMatchingGroup(Card.IsAbleToDeckOrExtraAsCost, tp, LOCATION_MZONE, 0, nil)
    return g:Filter(s.filter, nil, g)
end

function s.filter(c, g)
    return not g:IsExists(Card.IsAttribute, 1, c, c:GetAttribute())
end

function s.contactop(g, tp)
    Duel.ConfirmCards(1 - tp, g)
    Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_COST + REASON_MATERIAL)
end

function s.spr(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if (r & (REASON_DESTROY | REASON_EFFECT)) ~= (REASON_DESTROY | REASON_EFFECT) then return end
    if Duel.GetTurnPlayer() == tp and Duel.GetCurrentPhase() == PHASE_STANDBY then
        e:SetLabel(Duel.GetTurnCount())
        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN, 0, 2)
    else
        e:SetLabel(0)
        c:RegisterFlagEffect(id, RESET_EVENT + RESETS_STANDARD + RESET_PHASE + PHASE_STANDBY + RESET_SELF_TURN, 0, 1)
    end
end

function s.spcon(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return e:GetLabelObject():GetLabel() ~= Duel.GetTurnCount() and tp == Duel.GetTurnPlayer() and c:GetFlagEffect(id) > 0
end

function s.sptg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local c = e:GetHandler()
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
    c:ResetFlagEffect(id)
end

function s.spop(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c, 1, tp, tp, false, false, POS_FACEUP)
    end
end

function s.descon(e, tp, eg, ep, ev, re, r, rp)
    return e:GetHandler():GetSummonType() == SUMMON_TYPE_SPECIAL + 1
end

function s.desfilter(c)
    return c:IsType(TYPE_SPELL + TYPE_TRAP)
end

function s.destg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, #g, 0, 0)
end

function s.desop(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetMatchingGroup(s.desfilter, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
    Duel.Destroy(g, REASON_EFFECT)
end

function s.descost2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(), REASON_COST)
end

function s.destg2(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.desop2(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsMonster() then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end

function s.spcon2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    return e:GetLabelObject():GetLabel() == Duel.GetTurnCount() and tp == Duel.GetTurnPlayer() and c:GetFlagEffect(id) > 0
end

function s.sptg2(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local c = e:GetHandler()
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, c, 1, 0, 0)
end

function s.spop2(e, tp, eg, ep, ev, re, r, rp)
    local c = e:GetHandler()
    if c:IsRelateToEffect(e) then
        Duel.SpecialSummon(c, 0, tp, tp, false, false, POS_FACEUP)
        local g = Duel.GetMatchingGroup(aux.TRUE, tp, LOCATION_ONFIELD, LOCATION_ONFIELD, nil)
        Duel.Destroy(g, REASON_EFFECT)
    end
end

function s.descost3(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return e:GetHandler():IsReleasable() end
    Duel.Release(e:GetHandler(), REASON_COST)
end

function s.destg3(e, tp, eg, ep, ev, re, r, rp, chk, chkc)
    if chkc then return chkc:IsLocation(LOCATION_MZONE) end
    if chk == 0 then return Duel.IsExistingTarget(aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, e:GetHandler()) end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_DESTROY)
    local g = Duel.SelectTarget(tp, aux.TRUE, tp, LOCATION_MZONE, LOCATION_MZONE, 1, 1, nil)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, g, 1, 0, 0)
end

function s.desop3(e, tp, eg, ep, ev, re, r, rp)
    local tc = Duel.GetFirstTarget()
    if tc:IsRelateToEffect(e) and tc:IsMonster() then
        Duel.Destroy(tc, REASON_EFFECT)
    end
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_MZONE, 1, nil) end
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.SelectMatchingCard(tp, s.filter, tp, 0, LOCATION_MZONE, 1, 1, nil)
    local tc = g:GetFirst()
    if tc then
        Duel.HintSelection(g)
        local e1 = Effect.CreateEffect(e:GetHandler())
        e1:SetType(EFFECT_TYPE_SINGLE)
        e1:SetCode(EFFECT_UPDATE_ATTACK)
        e1:SetValue(tc:GetLevel() * -100)
        e1:SetReset(RESET_EVENT + RESETS_STANDARD)
        tc:RegisterEffect(e1)
    end
end

function s.filter(c)
    return c:IsFaceup() and c:GetLevel() > 0
end
