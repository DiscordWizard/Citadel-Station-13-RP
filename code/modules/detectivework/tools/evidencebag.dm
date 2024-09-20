//CONTAINS: Evidence bags and fingerprint cards

/obj/item/evidencebag
	name = "evidence bag"
	desc = "An empty evidence bag."
	icon = 'icons/obj/storage.dmi'
	icon_state = "evidenceobj"
	item_state = null
	w_class = WEIGHT_CLASS_SMALL
	var/obj/item/stored_item = null

/obj/item/evidencebag/OnMouseDropLegacy(var/obj/item/I as obj)
	if (!ishuman(usr))
		return
	if(!istype(I) || I.anchored)
		return  ..()

	var/mob/living/carbon/human/user = usr

	if(!user.is_holding(src))
		return //bag must be in your hands to use

	if (isturf(I.loc))
		if (!user.Adjacent(I))
			return
	else
		//If it isn't on the floor. Do some checks to see if it's in our hands or a box. Otherwise give up.
		if(istype(I.loc,/obj/item/storage))	//in a container.
			var/sdepth = I.depth_inside_atom(user)
			if (sdepth > STORAGE_REACH_DEPTH)
				return	//too deeply nested to access

			var/obj/item/storage/U = I.loc
			user.client.screen -= I
			U.contents.Remove(I)
		else if(user.is_holding(I))
			user.drop_item_to_ground(I)
		else
			return

	if(istype(I, /obj/item/evidencebag))
		to_chat(user, "<span class='notice'>You find putting an evidence bag in another evidence bag to be slightly absurd.</span>")
		return

	if(I.w_class > 3)
		to_chat(user, "<span class='notice'>[I] won't fit in [src].</span>")
		return

	if(contents.len)
		to_chat(user, "<span class='notice'>[src] already has something inside it.</span>")
		return

	user.visible_message("[user] puts [I] into [src]", "You put [I] inside [src].",\
	"You hear a rustle as someone puts something into a plastic bag.")

	icon_state = "evidence"

	var/xx = I.pixel_x	//save the offset of the item
	var/yy = I.pixel_y
	I.pixel_x = 0		//then remove it so it'll stay within the evidence bag
	I.pixel_y = 0
	var/image/img = image("icon"=I, "layer"=FLOAT_LAYER)	//take a snapshot. (necessary to stop the underlays appearing under our inventory-HUD slots ~Carn
	I.pixel_x = xx		//and then return it
	I.pixel_y = yy
	var/list/overlays_to_add = list()
	overlays_to_add += img
	overlays_to_add += "evidence"	//should look nicer for transparent stuff. not really that important, but hey.
	add_overlay(overlays_to_add)

	desc = "An evidence bag containing [I]."
	I.loc = src
	stored_item = I
	set_weight_class(I.w_class)

/obj/item/evidencebag/attack_self(mob/user, datum/event_args/actor/actor)
	. = ..()
	if(.)
		return
	if(contents.len)
		var/obj/item/I = contents[1]
		user.visible_message("[user] takes [I] out of [src]", "You take [I] out of [src].",\
		"You hear someone rustle around in a plastic bag, and remove something.")
		cut_overlays()

		user.put_in_hands(I)
		stored_item = null

		set_weight_class(initial(w_class))
		icon_state = "evidenceobj"
		desc = "An empty evidence bag."
	else
		to_chat(user, "[src] is empty.")
		icon_state = "evidenceobj"
	return

/obj/item/evidencebag/examine(mob/user, dist)
	. = ..()
	if(stored_item)
		. += stored_item.examine(user)
