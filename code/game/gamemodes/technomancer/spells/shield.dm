/datum/technomancer/spell/shield
	name = "Shield"
	desc = "Emits a protective shield fron your hand in front of you, which will protect you from almost anything able to harm \
	you, so long as you can power it.  Stronger attacks blocked cost more energy to sustain.  \
	Note that holding two shields will make blocking more energy efficient."
	enhancement_desc = "Blocking is twice as efficient in terms of energy cost per hit."
	cost = 100
	obj_path = /obj/item/spell/shield
	ability_icon_state = "tech_shield"
	category = DEFENSIVE_SPELLS

/obj/item/spell/shield
	name = "\proper energy shield"
	icon_state = "shield"
	desc = "A very protective combat shield that'll stop almost anything from hitting you, at least from the front."
	aspect = ASPECT_FORCE
	toggled = 1
	var/damage_to_energy_multiplier = 30.0 //Determines how much energy to charge for blocking, e.g. 20 damage attack = 600 energy cost
	var/datum/effect_system/spark_spread/spark_system = null

/obj/item/spell/shield/Initialize(mapload)
	. = ..()
	set_light(3, 2, l_color = "#006AFF")
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)

/obj/item/spell/shield/Destroy()
	spark_system = null
	return ..()

/obj/item/spell/shield/equipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	// if you're reading this: this is not the right way to do shieldcalls
	// this is just a lazy implementation
	// signals have highest priority, this as a piece of armor shouldn't have that.
	RegisterSignal(user, COMSIG_ATOM_SHIELDCALL, PROC_REF(shieldcall))

/obj/item/spell/shield/unequipped(mob/user, slot, flags)
	. = ..()
	if(slot == SLOT_ID_HANDS)
		return
	UnregisterSignal(user, COMSIG_ATOM_SHIELDCALL)

/obj/item/spell/shield/proc/shieldcall(mob/user, list/shieldcall_args, fake_attack)
	var/damage = shieldcall_args[SHIELDCALL_ARG_DAMAGE]

	if(user.incapacitated())
		return 0

	var/damage_to_energy_cost = damage_to_energy_multiplier * damage

	if(issmall(user)) // Smaller shields are more efficient.
		damage_to_energy_cost *= 0.75

	if(ishuman(owner))
		var/mob/living/carbon/human/H = owner
		if(istype(H.get_other_hand(src), src.type)) // Two shields in both hands.
			damage_to_energy_cost *= 0.75

	else if(check_for_scepter())
		damage_to_energy_cost *= 0.50

	if(!pay_energy(damage_to_energy_cost))
		to_chat(owner, "<span class='danger'>Your shield fades due to lack of energy!</span>")
		qdel(src)
		return 0


	user.visible_message("<span class='danger'>\The [user]'s [src] blocks the attack!</span>")
	spark_system.start()
	playsound(user.loc, 'sound/weapons/blade1.ogg', 50, 1)
	adjust_instability(2)
