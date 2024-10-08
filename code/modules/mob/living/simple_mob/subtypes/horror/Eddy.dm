/datum/category_item/catalogue/fauna/horror/Eddy
	name = "&@THE*&CHILDR#!!INE"
	desc = "%WARNING% PROCESSING FAILURE! RETURN SCANNER TO A CENTRAL \
	ADMINISTRATOR FOR IMMEDIATE MAINTENANCE! %ERROR%"
	value = CATALOGUER_REWARD_TRIVIAL

/mob/living/simple_mob/horror/Eddy
	name = "???"
	desc = "A dark green, sluglike creature, covered in glowing green ooze, and carrying what look to be eggs on its back."

	icon_state = "Eddy"
	icon_living = "Eddy"
	icon_dead = "e_head"
	icon_rest = "Eddy"
	icon = 'icons/mob/horror_show/GHPS.dmi'
	icon_gib = "generic_gib"
	catalogue_data = list(/datum/category_item/catalogue/fauna/horror/Eddy)

	attack_sound = 'sound/h_sounds/negative.ogg'

	maxHealth = 175
	health = 175

	legacy_melee_damage_lower = 25
	legacy_melee_damage_upper = 35
	grab_resist = 100

	response_help = "pets the"
	response_disarm = "bops the"
	response_harm = "hits the"
	attacktext = list("amashes")
	friendly = list("nuzzles", "boops", "bumps against", "leans on")


	say_list_type = /datum/say_list/Eddy
	ai_holder_type = /datum/ai_holder/polaris/simple_mob/horror

	bone_amount = 1
	hide_amount = 1
	exotic_amount = 5

/mob/living/simple_mob/horror/Eddy/Initialize(mapload)
	. = ..()
	AddComponent(/datum/component/horror_aura/weak)

/mob/living/simple_mob/horror/Eddy/death()
	playsound(src, 'sound/h_sounds/headcrab.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Eddy/on_bullet_act(obj/projectile/proj, impact_flags, list/bullet_act_args)
	. = ..()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)

/mob/living/simple_mob/horror/Eddy/attack_hand(mob/user, datum/event_args/actor/clickchain/e_args)
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/mob/living/simple_mob/horror/Eddy/throw_impacted(atom/movable/AM, datum/thrownthing/TT)
	. = ..()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)

/mob/living/simple_mob/horror/Eddy/attackby()
	playsound(src, 'sound/h_sounds/holla.ogg', 50, 1)
	..()

/datum/say_list/Eddy
	speak = list("Uuurrgh?","Aauuugghh...", "AAARRRGH!")
	emote_hear = list("shrieks horrifically", "groans in pain", "cries", "whines")
	emote_see = list("blinks its many eyes", "shakes violently in place", "stares aggressively")
	say_maybe_target = list("Uuurrgghhh?")
	say_got_target = list("AAAHHHHH!")
