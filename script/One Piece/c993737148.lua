-- Vega A.T.K
local s, id = GetID()
function s.initial_effect(c)
    -- Cannot negate its Special Summon
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_SINGLE)
    e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
    e1:SetCode(EFFECT_CANNOT_DISABLE_SPSUMMON)
    c:RegisterEffect(e1)
    -- Shuffle all other monsters that are banished, on the field, and in the GYs into the Deck, and Special Summon 1 fusion monster from the extra deck
    local e2 = Effect.CreateEffect(c)
    e2:SetDescription(aux.Stringid(id, 0))
    e2:SetCategory(CATEGORY_TODECK + CATEGORY_SPECIAL_SUMMON)
    e2:SetType(EFFECT_TYPE_SINGLE + EFFECT_TYPE_TRIGGER_F)
    e2:SetCode(EVENT_SPSUMMON_SUCCESS)
    e2:SetTarget(s.tdtg)
    e2:SetOperation(s.tdop)
    c:RegisterEffect(e2)
end
function s.tdfilter(c)
    return c:IsMonster() and (c:IsFaceup() or not c:IsLocation(LOCATION_REMOVED))
end
function s.filter(c,e,tp)
    return c:IsType(TYPE_FUSION) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function s.tdtg(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then return true end
    local LOCATION_MZONE_GRAVE_REMOVED = LOCATION_MZONE | LOCATION_GRAVE | LOCATION_REMOVED
    local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_MZONE_GRAVE_REMOVED, LOCATION_MZONE_GRAVE_REMOVED, e:GetHandler())
    Duel.SetOperationInfo(0, CATEGORY_TODECK, g, #g, tp, 0)
    Duel.SetOperationInfo(0, CATEGORY_SPECIAL_SUMMON, nil, 0, tp, LOCATION_EXTRA)
    Duel.SetChainLimit(aux.FALSE)
end
function s.tdop(e, tp, eg, ep, ev, re, r, rp)
    local LOCATION_MZONE_GRAVE_REMOVED = LOCATION_MZONE | LOCATION_GRAVE | LOCATION_REMOVED
    local g = Duel.GetMatchingGroup(s.tdfilter, tp, LOCATION_MZONE_GRAVE_REMOVED, LOCATION_MZONE_GRAVE_REMOVED, e:GetHandler())
    if #g > 0 then
        Duel.SendtoDeck(g, nil, SEQ_DECKSHUFFLE, REASON_EFFECT)
    end
    Duel.Hint(HINT_SELECTMSG, tp, HINTMSG_SPSUMMON)
    local fusiong = Duel.SelectMatchingCard(tp, s.filter, tp, LOCATION_EXTRA, 0, 1, 1, nil, e, tp)
    local fusion = fusiong:GetFirst()
    if fusion and Duel.SpecialSummon(fusion, 0, tp, tp, false, false, POS_FACEUP) ~= 0 then
    end
end
