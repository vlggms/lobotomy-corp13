#define STATUS_EFFECT_TALISMANS /datum/status_effect/stacking/talismans
//#define STATUS_EFFECT_CURSED_TALISMANS /datum/status_effect/stacking/cursed_talismans
//#define STATUS_EFFECT_TALISMAN_BACKLASH /datum/status_effect/talisman_backlash

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry
    name = "So That No One Will Cry"
    desc = "An abnormality taking the form of a wooden doll, various talismans are attached to it's body."
    icon = 'ModularTegustation/Teguicons/48x64.dmi'
    icon_state = "so_that_no_cry"
    maxHealth = 800
    health = 800
    threat_level = TETH_LEVEL
    work_chances = list(
        ABNORMALITY_WORK_INSTINCT = 30,
        ABNORMALITY_WORK_INSIGHT = list(40, 50, 60, 70, 80),
        ABNORMALITY_WORK_ATTACHMENT = 0,
        ABNORMALITY_WORK_REPRESSION = 60
            )
    work_damage_amount = 6
    work_damage_type = WHITE_DAMAGE

    ego_list = list(
        /datum/ego_datum/weapon/red_sheet,
        /datum/ego_datum/armor/red_sheet
        )
    abnormality_origin = ABNORMALITY_ORIGIN_LIMBUS

/mob/living/simple_animal/hostile/abnormality/so_that_no_cry/PostWorkEffect(mob/living/carbon/human/user, work_type, pe)
    if(work_type == ABNORMALITY_WORK_INSIGHT) //Environment work, one talisman will attach to you at a time
            user.apply_status_effect(STATUS_EFFECT_TALISMANS)
    //if(work_type == ABNORMALITY_WORK_INSTINCT) //Physical work, will remove the talismans from you

/datum/status_effect/stacking/talismans
    id = "talisman"
    status_type = STATUS_EFFECT_MULTIPLE
    duration = 240        //Lasts for 4 minutes
    max_stacks = 6 //Actual maximum is 5, 6 will turn the talismans into the cursed version instantly.
    stacks = 1
    alert_type = /atom/movable/screen/alert/status_effect/talismans

/atom/movable/screen/alert/status_effect/talismans
    name = "Talisman"
    desc = "You have sacrificed a bit of yourself to the rose."
    icon = 'ModularTegustation/Teguicons/status_sprites.dmi'
    icon_state = "sacrifice"

/datum/status_effect/talismans/on_apply()
    . = ..()
    if(ishuman(owner))
        var/mob/living/carbon/human/H = owner
        H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stacks * 5)

/datum/status_effect/talismans/on_remove()
    . = ..()
    if(ishuman(owner))
        var/mob/living/carbon/human/H = owner
        H.adjust_attribute_buff(JUSTICE_ATTRIBUTE, stacks * -5)

#undef STATUS_EFFECT_TALISMAN
//#undef STATUS_EFFECT_CURSED_TALISMAN
//#undef STATUS_EFFECT_TALISMAN_BACKLASH
