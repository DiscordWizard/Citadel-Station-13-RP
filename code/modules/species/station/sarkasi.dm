/datum/physiology_modifier/intrinsic/species/sarkasi
	carry_strength_add = CARRY_STRENGTH_ADD_SARKASI
	carry_strength_factor = CARRY_FACTOR_MOD_SARKASI

/datum/species/sarkasi
	uid = SPECIES_ID_SARKASI
	id = SPECIES_ID_SARKASI
	name = SPECIES_SARKASI
	name_plural = "Sarkasi"
	default_bodytype = BODYTYPE_SARKASI

	blurb = "The Vigil is a relatively loose association of machine-servitors, Adherents, \
	built by an extinct culture. They are devoted to the memory of their long-dead creators, \
	whose home system and burgeoning stellar empire was scoured to bedrock by a solar flare. \
	Physically, they are large, floating squidlike machines made of a crystalline composite."
//	hidden_from_codex = FALSE
//	silent_steps      = TRUE

	//meat_type     = null
	// bone_material = null
	// skin_material = null

	//genders = list("male, female")
//	cyborg_noun = null

	icon_template   = 'icons/mob/species/adherent/template.dmi'
	icobase         = 'icons/mob/species/adherent/body.dmi'
	deform          = 'icons/mob/species/adherent/body.dmi'
	preview_icon    = 'icons/mob/species/adherent/preview.dmi'
	damage_overlays = 'icons/mob/species/adherent/damage_overlay.dmi'
	damage_mask     = 'icons/mob/species/adherent/damage_mask.dmi'
	blood_mask      = 'icons/mob/species/adherent/blood_mask.dmi'

	siemens_coefficient  = 0
	//rarity_value         = 6
	min_age              = 23
	max_age              = 500
	// antaghud_offset_y    = 14
	mob_size             = MOB_HUGE
	//strength             = STR_HIGH
	has_glowing_eyes     = FALSE

	radiation_mod		 = 1
	toxins_mod			 = 1
	brute_mod			 = 0.8
	burn_mod 			 = 0.8
	total_health 		 = 150

	hunger_factor 		 = 2

	cold_level_1 = 280
	cold_level_2 = 230
	cold_level_3 = 160

	heat_level_1 = 460
	heat_level_2 = 600
	heat_level_3 = 1400

	species_flags =  NO_SLIP | NO_MINOR_CUT
	species_spawn_flags = SPECIES_SPAWN_WHITELISTED | SPECIES_SPAWN_NO_FBP_CONSTRUCT | SPECIES_SPAWN_NO_FBP_SETUP | SPECIES_SPAWN_CHARACTER
	species_appearance_flags = HAS_EYE_COLOR | HAS_BASE_SKIN_COLOR

	intrinsic_languages = LANGUAGE_ID_UNATHI //| LANGUAGE_ID_SARKASI
	max_additional_languages = 2

	base_color  = "#0cb800"

	slowdown = 0.2

	vision_innate = /datum/vision/baseline/species_tier_1

	hud_type = /datum/hud_data/sarkasi
/*
	available_cultural_info = list(
		TAG_CULTURE = list(
			CULTURE_ADHERENT
		),
		TAG_HOMEWORLD = list(
			HOME_SYSTEM_ADHERENT,
			HOME_SYSTEM_ADHERENT_MOURNER
		),
		TAG_FACTION = list(
			FACTION_ADHERENT_PRESERVERS,
			FACTION_ADHERENT_LOYALISTS,
			FACTION_ADHERENT_SEPARATISTS
		),
		TAG_RELIGION =  list(
			RELIGION_OTHER
		)
	)
*/

	has_organ = list(
		O_HEART     = /obj/item/organ/internal/heart,
		O_LUNGS     = /obj/item/organ/internal/lungs,
		O_VOICE     = /obj/item/organ/internal/voicebox,
		O_LIVER     = /obj/item/organ/internal/liver,
		O_KIDNEYS   = /obj/item/organ/internal/kidneys,
		O_BRAIN     = /obj/item/organ/internal/brain,
		O_APPENDIX  = /obj/item/organ/internal/appendix,
		O_SPLEEN    = /obj/item/organ/internal/spleen,
		O_EYES      = /obj/item/organ/internal/eyes,
		O_STOMACH   = /obj/item/organ/internal/stomach,
		O_INTESTINE = /obj/item/organ/internal/intestine,
	)
	vision_organ = O_EYES

	move_trail = /obj/effect/debris/cleanable/blood/tracks/snake

	wikilink = "N/A"

	// This species is basically born with wings and efficient flight in mind
	abilities = list(
		/datum/ability/species/toggle_flight/auril,
	)

/datum/species/sarkasi/handle_fall_special(mob/living/carbon/human/H, turf/landing)
	if(H && H.stat == CONSCIOUS && H.nutrition > 24)
		if(istype(landing, /turf/simulated/open))
			H.visible_message("\The [H] descends from \the [landing].", "You descend carefully.")
		else
			H.visible_message("\The [H] glides down from \the [landing].", "You land on \the [landing] with a resounding thump.")
		return TRUE
	return FALSE

// /datum/species/adherent/equip_survival_gear(mob/living/carbon/human/H, extendedtank = FALSE, comprehensive = FALSE)
//	H.equip_to_slot_or_del(new /obj/item/storage/belt/utility/crystal, /datum/inventory_slot/abstract/put_in_backpack)


