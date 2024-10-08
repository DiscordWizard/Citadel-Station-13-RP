/obj/projectile/spell_projectile
	name = "spell"
	icon = 'icons/obj/projectiles.dmi'

	nodamage = 1 //Most of the time, anyways

	var/spell/targeted/projectile/carried

	range = WORLD_ICON_SIZE * 10 //set by the duration of the spell

	var/proj_trail = 0 //if it leaves a trail
	var/proj_trail_lifespan = 0 //deciseconds
	var/proj_trail_icon = 'icons/obj/wizard.dmi'
	var/proj_trail_icon_state = "trail"
	var/list/trails = new()

/obj/projectile/spell_projectile/Destroy()
	for(var/trail in trails)
		qdel(trail)
	carried = null
	return ..()

/obj/projectile/spell_projectile/legacy_ex_act()
	return

/obj/projectile/spell_projectile/Moved(atom/old_loc, movement_dir, forced, list/old_locs, momentum_change)
	. = ..()
	if(proj_trail && old_loc) //pretty trails
		var/obj/effect/overlay/trail = new /obj/effect/overlay(old_loc)
		trails += trail
		trail.icon = proj_trail_icon
		trail.icon_state = proj_trail_icon_state
		trail.density = 0
		spawn(proj_trail_lifespan)
			trails -= trail
			qdel(trail)

/obj/projectile/spell_projectile/proc/prox_cast(var/list/targets)
	if(loc)
		carried.prox_cast(targets, src)
		qdel(src)
	return

/obj/projectile/spell_projectile/Bump(var/atom/A)
	if(loc && carried)
		prox_cast(carried.choose_prox_targets(user = carried.holder, spell_holder = src))
	return 1

/obj/projectile/spell_projectile/on_impact(atom/target, impact_flags, def_zone, efficiency)
	. = ..()
	if(. & PROJECTILE_IMPACT_FLAGS_UNCONDITIONAL_ABORT)
		return
	if(loc && carried)
		prox_cast(carried.choose_prox_targets(user = carried.holder, spell_holder = src))

/obj/projectile/spell_projectile/seeking
	name = "seeking spell"
