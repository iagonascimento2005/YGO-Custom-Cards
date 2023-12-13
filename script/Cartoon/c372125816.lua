-- Fair Play
local s, id = GetID()
function s.initial_effect(c)
    -- Activate
    local e1 = Effect.CreateEffect(c)
    e1:SetType(EFFECT_TYPE_ACTIVATE)
    e1:SetCode(EVENT_FREE_CHAIN)
    e1:SetOperation(s.activate)
    c:RegisterEffect(e1)
end

function s.activate(e, tp, eg, ep, ev, re, r, rp)
    local lp = (Duel.GetLP(tp) + Duel.GetLP(1 - tp)) / 2
    Duel.SetLP(tp, lp)
    Duel.SetLP(1 - tp, lp)
end
