local Spell = { }
Spell.LearnTime = 600
Spell.Description = [[
	Explodes in a strong burst
	of fire.
]]
Spell.Category = HpwRewrite.CategoryNames.Fight
Spell.FlyEffect = "hpw_confringo_main"
Spell.ImpactEffect = "hpw_confringo_impact"
Spell.ApplyDelay = 0.5
Spell.AccuracyDecreaseVal = 0.26

Spell.ForceAnim = { ACT_VM_PRIMARYATTACK_1, ACT_VM_PRIMARYATTACK_2 }
Spell.SpriteColor = Color(255, 180, 10)

Spell.NodeOffset = Vector(321, -288, 0)

function Spell:OnSpellSpawned(wand, spell)
	if not spell.Snd then
		spell.Snd = CreateSound(spell, "ambient/fire/firebig.wav")
		spell.Snd:Play()
		spell.Snd:ChangePitch(220)
	end

	sound.Play("ambient/wind/wind_snippet2.wav", spell:GetPos(), 75, 255)
	wand:PlayCastSound()
end

function Spell:OnRemove(spell)
	if spell.Snd then spell.Snd:Stop() end
end

function Spell:OnFire(wand)
	return true
end

function Spell:AfterCollide(spell, data)
	local ent = data.HitEntity
	if not HpwRewrite:CanAttackEntity(self.Owner, ent) then return end

	local rag = HpwRewrite:ThrowEntity(ent, spell:GetFlyDirection(), nil, 2, self.Owner)

	if IsValid(rag) then
		rag:Ignite(1)
	else
		ent:Ignite(1)
	end

	for k, v in ipairs(ents.FindInSphere(data.HitPos, 100)) do
		if
			v ~= rag and
			v ~= ent and
			HpwRewrite:CanAttackEntity(self.Owner, v)
		then
			v:Ignite(1)
		end
	end

	util.BlastDamage(spell, IsValid(self.Owner) and self.Owner or spell, data.HitPos, 150, 14)

	sound.Play("ambient/fire/mtov_flame2.wav", spell:GetPos(), 100, 90)
end

HpwRewrite:AddSpell("Confringo", Spell)