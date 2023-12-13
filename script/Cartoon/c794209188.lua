-- Meteor Rain
local s, id = GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetCategory(CATEGORY_DESTROY)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetTarget(s.target)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.filter(c)
    return c:IsType(TYPE_SPELL+TYPE_TRAP)
end

function s.target(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.IsExistingMatchingCard(s.filter, tp, 0, LOCATION_ONFIELD, 1, e:GetHandler()) or Duel.IsExistingMatchingCard(aux.TRUE, tp, 0, LOCATION_MZONE, 1, nil)
    end
    local sg1 = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_ONFIELD, e:GetHandler())
    local sg2 = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    sg1:Merge(sg2)
    Duel.SetOperationInfo(0, CATEGORY_DESTROY, sg1, #sg1, 0, 0)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local sg1 = Duel.GetMatchingGroup(s.filter, tp, 0, LOCATION_ONFIELD, e:GetHandler())
    local sg2 = Duel.GetMatchingGroup(aux.TRUE, tp, 0, LOCATION_MZONE, nil)
    sg1:Merge(sg2)
    Duel.Destroy(sg1, REASON_EFFECT)
end
