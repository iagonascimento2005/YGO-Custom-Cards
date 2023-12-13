-- Marina
local s, id = GetID()

function s.initial_effect(c)
    -- Synchro summon
    Synchro.AddProcedure(c, aux.FilterBoolFunction(Card.IsSetCard, 0xa06), 1, 1, Synchro.NonTuner(nil), 1, 99)

    -- Discard effect
    local e1 = Effect.CreateEffect(c)
    e1:SetDescription(aux.Stringid(id, 0))
    e1:SetCategory(CATEGORY_HANDES)
    e1:SetType(EFFECT_TYPE_IGNITION)
    e1:SetRange(LOCATION_MZONE)
    e1:SetCost(s.discCost)
    e1:SetTarget(s.discTarget)
    e1:SetOperation(s.discOperation)
    c:RegisterEffect(e1)

    --destroyed
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DEFCHANGE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_BATTLE_DESTROYED)
	e2:SetOperation(s.desop)
	c:RegisterEffect(e2)
end

-- Cost: Tribute 1 "0xa06" monster on the field
function s.discCost(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk==0 then return Duel.CheckReleaseGroupCost(tp,Card.IsSetCard,1,false,nil,nil,0xa06) end
    local g=Duel.SelectReleaseGroupCost(tp,Card.IsSetCard,1,1,false,nil,nil,0xa06)
    Duel.Release(g,REASON_COST)
end


-- Target: Randomly discard 1 card from the opponent's hand
function s.discTarget(e, tp, eg, ep, ev, re, r, rp, chk)
    if chk == 0 then
        return Duel.GetFieldGroupCount(tp, 0, LOCATION_HAND) > 0
    end
    Duel.SetOperationInfo(0, CATEGORY_HANDES, nil, 0, 1 - tp, 1)
end

-- Operation: Randomly discard 1 card from the opponent's hand
function s.discOperation(e, tp, eg, ep, ev, re, r, rp)
    local g = Duel.GetFieldGroup(1 - tp, LOCATION_HAND, 0)
    if #g > 0 then
        local randomCard = g:RandomSelect(1 - tp, 1):GetFirst()
        Duel.SendtoGrave(randomCard, REASON_EFFECT + REASON_DISCARD)
    end
end

function s.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetAttacker()
	if c==tc then tc=Duel.GetAttackTarget() end
	if not tc:IsRelateToBattle() then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	e1:SetValue(-2000)
	tc:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_UPDATE_DEFENSE)
	tc:RegisterEffect(e2)
end
