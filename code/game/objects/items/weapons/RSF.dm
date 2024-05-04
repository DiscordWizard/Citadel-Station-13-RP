/*
CONTAINS:
RSF

*/

/obj/item/rsf
	name = "\improper Rapid-Service-Fabricator"
	desc = "A device used to rapidly deploy service items."
	description_info = "Control Clicking on the device will allow you to choose the glass it dispenses when in the proper mode."
	icon = 'icons/obj/tools.dmi'
	icon_state = "rsf"
	opacity = 0
	density = 0
	anchored = 0.0
	var/stored_matter = 30
	var/mode = 1
	var/obj/item/reagent_containers/glasstype = /obj/item/reagent_containers/food/drinks/metaglass

	var/list/container_types = list(
		"metamorphic glass" = /obj/item/reagent_containers/food/drinks/metaglass,
		"half-pint glass" = /obj/item/reagent_containers/food/drinks/glass2/square,
		"rocks glass" = /obj/item/reagent_containers/food/drinks/glass2/rocks,
		"milkshake glass" = /obj/item/reagent_containers/food/drinks/glass2/shake,
		"cocktail glass" = /obj/item/reagent_containers/food/drinks/glass2/cocktail,
		"shot glass" = /obj/item/reagent_containers/food/drinks/glass2/shot,
		"pint glass" = /obj/item/reagent_containers/food/drinks/glass2/pint,
		"mug" = /obj/item/reagent_containers/food/drinks/glass2/mug,
		"wine glass" = /obj/item/reagent_containers/food/drinks/glass2/wine,
		"condiment bottle" = /obj/item/reagent_containers/food/condiment
		)

	w_class = WEIGHT_CLASS_NORMAL

/obj/item/rsf/examine(mob/user, dist)
	. = ..()
	. += "<span class='notice'>It currently holds [stored_matter]/30 fabrication-units.</span>"

/obj/item/rsf/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if (istype(W, /obj/item/rcd_ammo))

		if ((stored_matter + 10) > 30)
			to_chat(user, "<span class='warning'>The RSF can't hold any more matter.</span>")
			return

		qdel(W)

		stored_matter += 10
		playsound(src.loc, 'sound/machines/click.ogg', 10, 1)
		to_chat(user,"<span class='notice'>The RSF now holds [stored_matter]/30 fabrication-units.</span>")
		return

/obj/item/rsf/CtrlClick(mob/living/user)
	if(!Adjacent(user) || !istype(user))
		to_chat(user,"<span class='notice'>You are too far away.</span>")
		return
	var/glass_choice = input(user, "Please choose which type of glass you would like to produce.") as null|anything in container_types

	if(glass_choice)
		glasstype = container_types[glass_choice]
	else
		glasstype = /obj/item/reagent_containers/food/drinks/metaglass

/obj/item/rsf/attack_self(mob/user)
	. = ..()
	if(.)
		return
	playsound(src.loc, 'sound/effects/pop.ogg', 50, 0)
	if (mode == 1)
		mode = 2
		to_chat(user, "Changed dispensing mode to 'Pint Glass'") //make it a little nicer
		return
	if (mode == 2)
		mode = 3
		to_chat(user, "Changed dispensing mode to 'Shot Glass'")
		return
	if (mode == 3)
		mode = 4
		to_chat(user, "Changed dispensing mode to 'Wine Glass'")
		return
	if (mode == 4)
		mode = 5
		to_chat(user, "Changed dispensing mode to 'Paper'")
		return
	if (mode == 5)
		mode = 6
		to_chat(user, "Changed dispensing mode to 'Pen'")
		return
	if (mode == 6)
		mode = 7
		to_chat(user, "Changed dispensing mode to 'Dice Pack'")
		return
	if (mode == 7)
		mode = 8
		to_chat(user, "Changed dispensing mode to 'Plushie' - WARNING: Requires Significant Charge")
		return
	if (mode == 8)
		mode = 1
		to_chat(user,"<span class='notice'>Changed dispensing mode to 'Cigarette'</span>")
		return

/obj/item/rsf/afterattack(atom/target, mob/user, clickchain_flags, list/params)

	if(!(clickchain_flags & CLICKCHAIN_HAS_PROXIMITY)) return

	if(istype(user,/mob/living/silicon/robot))
		var/mob/living/silicon/robot/R = user
		if(R.stat || !R.cell || R.cell.charge <= 0)
			return
	else
		if(stored_matter <= 0)
			return

	if(!istype(target, /obj/structure/table) && !istype(target, /turf/simulated/floor))
		return

	playsound(src, 'sound/machines/click.ogg', 10, 1)
	var/used_energy = 0
	var/obj/product
	var/turf/target_turf = get_turf(target)

	switch(mode)
		if(1)
			product = new /obj/item/clothing/mask/smokable/cigarette(target_turf)
			used_energy = 10
		if(2)
			product = new glasstype(target_turf)
			used_energy = 50
		if(3)
			product = new /obj/item/reagent_containers/food/drinks/glass2/shot(target_turf)
			used_energy = 25
		if(4)
			product = new /obj/item/reagent_containers/food/drinks/glass2/wine(target_turf)
			used_energy = 25
		if(5)
			product = new /obj/item/paper(target_turf)
			used_energy = 10
		if(6)
			product = new /obj/item/pen(target_turf)
			used_energy = 50
		if(7)
			product = new /obj/item/storage/pill_bottle/dice(target_turf)
			used_energy = 200
		if(8)
			product = new /obj/random/plushie(target_turf) //dear god if this gets spammed i will commit die
			used_energy = 1000

	to_chat(user,"<span class='notice'>Dispensing [product ? product : "product"]...</span>")

	if(isrobot(user))
		var/mob/living/silicon/robot/R = user
		if(R.cell)
			R.cell.use(used_energy)
	else
		stored_matter--
		to_chat(user,"<span class='notice'>The RSF now holds [stored_matter]/30 fabrication-units.</span>")
