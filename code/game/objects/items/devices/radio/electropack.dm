/obj/item/radio/electropack
	name = "electropack"
	desc = "Dance my monkeys! DANCE!!!"
	icon_state = "electropack0"
	item_icons = list(
			SLOT_ID_LEFT_HAND = 'icons/mob/items/lefthand_storage.dmi',
			SLOT_ID_RIGHT_HAND = 'icons/mob/items/righthand_storage.dmi',
			)
	item_state = "electropack"
	frequency = 1449
	slot_flags = SLOT_BACK
	w_class = WEIGHT_CLASS_HUGE

	materials_base = list(MAT_STEEL = 10000, MAT_GLASS = 2500)

	var/code = 2

/obj/item/radio/electropack/attack_hand(mob/user, list/params)
	if(src == user.item_by_slot_id(SLOT_ID_BACK))
		to_chat(user, "<span class='notice'>You need help taking this off!</span>")
		return
	..()

/obj/item/radio/electropack/attackby(obj/item/W as obj, mob/user as mob)
	..()
	if(istype(W, /obj/item/clothing/head/helmet))
		if(!b_stat)
			to_chat(user, "<span class='notice'>[src] is not ready to be attached!</span>")
			return
		if(!user.attempt_void_item_for_installation(W))
			return
		if(!user.attempt_void_item_for_installation(src))
			return
		var/obj/item/assembly/shock_kit/A = new /obj/item/assembly/shock_kit( user )
		A.icon = 'icons/obj/assemblies.dmi'
		W.forceMove(A)
		W.master = A
		A.part1 = W
		forceMove(A)
		master = A
		A.part2 = src
		user.put_in_hands(A)

/obj/item/radio/electropack/Topic(href, href_list)
	//..()
	if(usr.stat || usr.restrained())
		return
	if(((istype(usr, /mob/living/carbon/human) && ((!( SSticker ) || (SSticker && SSticker.mode != "monkey")) && usr.contents.Find(src))) || (usr.contents.Find(master) || (in_range(src, usr) && istype(loc, /turf)))))
		usr.set_machine(src)
		if(href_list["freq"])
			var/new_frequency = sanitize_frequency(frequency + text2num(href_list["freq"]))
			set_frequency(new_frequency)
		else
			if(href_list["code"])
				code += text2num(href_list["code"])
				code = round(code)
				code = min(100, code)
				code = max(1, code)
			else
				if(href_list["power"])
					on = !( on )
					icon_state = "electropack[on]"
		if(!( master ))
			if(istype(loc, /mob))
				attack_self(loc)
			else
				for(var/mob/M in viewers(1, src))
					if(M.client)
						attack_self(M)
		else
			if(istype(master.loc, /mob))
				attack_self(master.loc)
			else
				for(var/mob/M in viewers(1, master))
					if(M.client)
						attack_self(M)
	else
		usr << browse(null, "window=radio")
		return
	return

/obj/item/radio/electropack/receive_signal(datum/signal/signal)
	if(!signal || signal.encryption != code)
		return

	if(ismob(loc) && on)
		var/mob/M = loc
		var/turf/T = M.loc
		if(istype(T, /turf))
			if(!M.moved_recently && M.last_move_dir)
				M.moved_recently = 1
				step(M, M.last_move_dir)
				sleep(50)
				if(M)
					M.moved_recently = 0
		to_chat(M, "<span class='danger'>You feel a sharp shock!</span>")
		var/datum/effect_system/spark_spread/s = new /datum/effect_system/spark_spread
		s.set_up(3, 1, M)
		s.start()

		M.afflict_paralyze(20 * 10)

	if(master && wires & 1)
		master.receive_signal()
	return

/obj/item/radio/electropack/attack_self(mob/user)

	if(!istype(user, /mob/living/carbon/human))
		return
	user.set_machine(src)
	var/dat = {"<TT>
<A href='?src=\ref[src];power=1'>Turn [on ? "Off" : "On"]</A><BR>
<B>Frequency/Code</B> for electropack:<BR>
Frequency:
<A href='byond://?src=\ref[src];freq=-10'>-</A>
<A href='byond://?src=\ref[src];freq=-2'>-</A> [format_frequency(frequency)]
<A href='byond://?src=\ref[src];freq=2'>+</A>
<A href='byond://?src=\ref[src];freq=10'>+</A><BR>

Code:
<A href='byond://?src=\ref[src];code=-5'>-</A>
<A href='byond://?src=\ref[src];code=-1'>-</A> [code]
<A href='byond://?src=\ref[src];code=1'>+</A>
<A href='byond://?src=\ref[src];code=5'>+</A><BR>
</TT>"}
	user << browse(dat, "window=radio")
	onclose(user, "radio")
	return
