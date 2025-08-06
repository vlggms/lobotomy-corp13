# Achievement Ideas from Discord

## Collection/Farming Achievements
- ✅ **IMPLEMENTED** - Obtain silk from mobs 120 times
    - `code\game\objects\items\stacks\sheets\silk.dm`, make the silkweaver track the number of times it has been used.
- ✅ **IMPLEMENTED** - Forge 50 weapons as a workshop attendant on City of Light
    - `ModularTegustation\tegu_items\workshop\forging.dm`
- ✅ **IMPLEMENTED** - Feed a plushie to Basilisoup
    - `code/modules/mob/living/simple_animal/abnormality/he/basilisoup.dm`
- Collect the golden bough in ER
    - *Needs investigation for ER files*
- ❌ **TOO COMPLEX** - Generate 100 PE from Spiderbud from a successful work
    - `code/modules/mob/living/simple_animal/abnormality/teth/spider_bud.dm`

## City of Light Specific
- ✅ **IMPLEMENTED** - Max out a workshop weapon in City of Light
    - `ModularTegustation/tegu_items/workshop/_templates.dm`
- Trip on a landmine in one of the COL starter rooms
    - *Needs investigation for landmine/trap files*

## Medical/Infection
- Cure Naked Nest infection without a cure
    - *Needs investigation for surgery*
- ✅ **IMPLEMENTED** - Cure Naked Nest infection with a cure
    - `code/modules/mob/living/simple_animal/abnormality/waw/naked_nest.dm`

## Abnormality Interactions
- ✅ **IMPLEMENTED** - Free yourself from Nobody Is' chokehold
    - `code/modules/mob/living/simple_animal/abnormality/aleph/nobody_is.dm`
- ✅ **IMPLEMENTED** - Save someone from the wolf yourself
    - `code/modules/mob/living/simple_animal/abnormality/waw/big_wolf.dm`
- ✅ **IMPLEMENTED** - Be saved by Red Hood after getting eaten by Wolf
    - `code/modules/mob/living/simple_animal/abnormality/waw/big_wolf.dm`
    - `code/modules/mob/living/simple_animal/abnormality/waw/red_riding_mercenary.dm`
- ✅ **IMPLEMENTED** - Use Fell Bullet's shotgun interaction
    - `ModularTegustation\ego_weapons\ranged\waw.dm`
- ✅ **IMPLEMENTED** - Experience the special interaction between SWA and a person with her EGO gift
    - `code\modules\mob\living\simple_animal\abnormality\waw\snow_whites_apple.dm`
- ✅ **IMPLEMENTED** - Breach Golden Apple with a Yuri plushie
    - `code/modules/mob/living/simple_animal/abnormality/he/golden_false_apple.dm`
    - `code/game/objects/items/plushes.dm`
- ✅ **IMPLEMENTED** - Hear Silent Orchestra's full performance
    - `code/modules/mob/living/simple_animal/abnormality/aleph/silent_orchestra.dm`
- ✅ **IMPLEMENTED** - Activate Hammer of Light
    - `code/modules/mob/living/simple_animal/abnormality/zayin/hammer_light.dm`
- ✅ **IMPLEMENTED** - Survive a non-instinct/attachment work on Nothing There
    - `code/modules/mob/living/simple_animal/abnormality/aleph/nothing_there.dm`
- ✅ **IMPLEMENTED** - Die to Punishing Bird without having enraged it beforehand
    - `code/modules/mob/living/simple_animal/abnormality/teth/punishing_bird.dm`
- ✅ **IMPLEMENTED** - Kill WhiteNight by confessing to one sin
    - `code/modules/mob/living/simple_animal/abnormality/aleph/white_night.dm`
- ✅ **IMPLEMENTED** - Kill WhiteNight with Hammer of Light
    - `code/modules/mob/living/simple_animal/abnormality/aleph/white_night.dm`
    - `code/modules/mob/living/simple_animal/abnormality/zayin/hammer_light.dm`
- ✅ **IMPLEMENTED** - Rescue a friend/Be rescued from Snow Queen
    - `code/modules/mob/living/simple_animal/abnormality/he/snow_queen.dm`
- ✅ **IMPLEMENTED** - Trigger Snow Queen's ice encasement due to wearing Feather of Honour
    - `code/modules/mob/living/simple_animal/abnormality/he/snow_queen.dm`

## Combat/Survival
- Re-sane 8 agents in the same round
    - *Needs investigation for how to track re-sanes*
- ❌ **TOO COMPLEX** - Have 5 abno kills as records officer
    - `ModularTegustation\ego_weapons\_ego_weapon.dm`, just check the mind of the user, and give them a counter.
- Beat midnight on B12
    - *Needs investigation for specific midnight files*
- Beat Abno Blitz (Purple Rare achievement)
    - *Needs investigation for Abno Blitz game mode*
- ✅ **IMPLEMENTED** - Get hit by hell train and survive
    - `code/modules/mob/living/simple_animal/abnormality/waw/express_train.dm`
- Survive 20 minutes in Warp corp cleanup
    - *Needs investigation for Warp corp game mode*
- Survive 10 minutes in Warp corp cleanup
    - *Needs investigation for Warp corp game mode*
- Kill 8 x-corp monsters with a single grenade
    - *Needs investigation for X-corp monster files*
- Land a naked parry on a pale pillar/pale fixer
    - *Needs investigation for where this weapon is*
- ✅ **IMPLEMENTED** - Trigger FAN five times on the same character
    - `code\modules\mob\living\simple_animal\abnormality\he\fan.dm`
- ✅ **IMPLEMENTED** - Repress Melting Love whilst having her blessing - and survive
    - `code/modules/mob/living/simple_animal/abnormality/aleph/melting_love.dm`

## Progression/Meta
- Complete 50% of all achievements, only including LC13 and City achivements
    - `code/controllers/subsystem/achievements.dm`
- Complete 100% of all achievements
    - `code/controllers/subsystem/achievements.dm`
- Achieve enough playtime to get the Veteran Player's cloak
    - `code/modules/client/preferences.dm`
- Play the maximum amount of hours as intern
    - `code/modules/jobs/job_types/intern.dm`, 100 hours

## Equipment/Items
- Have at least 2 tool abno ego weapons and 1 tool abno ego armour
    - `code/modules/mob/living/simple_animal/abnormality/_tools/`
- Get a Level 5, 10, 15 and 20 fishing hat respectively
    - `ModularTegustation\fishing\code\fishing_items\fishing_hat.dm`
- "Dumbass" - Hit yourself with boomerang weapon.
    - *Needs investigation for boomerang weapon files*
- ❌ **TOO COMPLEX** - "This is my fixer OC, donut steel." - Have all color fixer weapons on you + Twilight suit.
    - `ModularTegustation/ego_weapons/melee/non_abnormality/color_fixer.dm`, just check if the player is holding "/obj/item/ego_weapon/city/pt/slash, /obj/item/ego_weapon/black_silence_gloves, /obj/item/ego_weapon/mimicry/kali, /obj/item/ego_weapon/city/reverberation"

## Special/Easter Eggs
- ✅ **IMPLEMENTED** - Say "uwu" on the radio achievement
    - `code/modules/mob/living/say.dm`, `code\game\objects\items\devices\radio\radio.dm`
- ✅ **IMPLEMENTED** - See the Chaos Dunk (Call it "Slam Jam" - Red Rare)
    - `code\modules\holodeck\items.dm`, check the /obj/structure/holohoop object
- Make an achievement for becoming a fatass with a hint on how to get rid of it
    - *Needs investigation for weight/fatness system*
- ✅ **IMPLEMENTED** - Successfully hear and type 680 mhz codes 5 times in a row
    - `code\modules\mob\living\simple_animal\abnormality\he\KHz.dm`

## Boss Achievements
- Defeat the Heart of Greed (second highest rarity)
    - *Needs investigation for Heart of Greed boss*
- ✅ **IMPLEMENTED** - Yin and Yang: Realize either Harmony of Duality or Duality of Harmony
    - `code\modules\mob\living\simple_animal\abnormality\_tools\zayin\realizer.dm`
- Survive until extraction with Yin, Yang, ETTH & [fourth one]
    - *Needs investigation for extraction game mode*

## Realization Achievements
- ✅ **IMPLEMENTED** - Realize Carmen/Benjamin from their respective plushies
    - `code\modules\mob\living\simple_animal\abnormality\_tools\zayin\realizer.dm`
- ✅ **IMPLEMENTED** - Realize Ayin from Paradise Lost's weapon
    - `code\modules\mob\living\simple_animal\abnormality\_tools\zayin\realizer.dm`

## Stat Achievements
- ✅ **IMPLEMENTED** - Achieve a rating of equal or greater than 200 in one of the following virtues: Fortitude/Prudence/Temperance/Justice (gifts count)
    - `code/modules/mob/living/attributes.dm`
- ✅ **IMPLEMENTED** - Achieve a rating of equal or greater than 200 in all of the virtues (gifts count)
    - `code/modules/mob/living/attributes.dm`

## Round Events
- ✅ **IMPLEMENTED** - Be in a round where Bald balds everyone in the facility
    - `code/modules/mob/living/simple_animal/abnormality/zayin/bald.dm`

## Resource Management
- ✅ **IMPLEMENTED** - Refine 100 PE boxes (now player-specific)
    - `ModularTegustation\tegu_items\refinery\refinery.dm`

## Death Achievements
- ✅ **IMPLEMENTED** - Get killed by friendly breach Queen of Hatred
    - `code\modules\mob\living\simple_animal\abnormality\waw\hatred_queen.dm`
- ✅ **IMPLEMENTED** - Die to Blubbering Toad
    - `code/modules/mob/living/simple_animal/abnormality/zayin/blubbering_toad.dm`
- Get ??? by the cuckoospawn
    - *Needs investigation for Cuckoo Clock abnormality*

## Special/Illegal Actions
- ✅ **IMPLEMENTED** - Make meth (description: "How?")
    - `code/modules/reagents/chemistry/recipes.dm`
- ✅ **IMPLEMENTED** - Let Blubbering Toad out
    - `code/modules/mob/living/simple_animal/abnormality/zayin/blubbering_toad.dm`

## Core Suppression
- ✅ **IMPLEMENTED** - Make beating each core's reward an achievement
    - `code/modules/suppressions/control.dm` - Malkuth
    - `code/modules/suppressions/information.dm` - Yesod
    - `code/modules/suppressions/training.dm` - Hod
    - `code/modules/suppressions/safety.dm` - Netzach
    - `code/modules/suppressions/command.dm` - Tiphereth
    - `code/modules/suppressions/welfare.dm` - Chesed
    - `code/modules/suppressions/records.dm` - Hokma
    - `code/modules/suppressions/extraction.dm` - Binah
    - Note: Gebura suppression not yet implemented in game
- ✅ **IMPLEMENTED** - Burn a Binah plush
    - `code/game/objects/items/plushes.dm`

## Ordeal Achievements
- Make one of each ordeal monster food items
    - `code/modules/ordeals/` (various ordeal files)
- ✅ **IMPLEMENTED** - Kill WhiteNight during a pink midnight
    - `code/modules/mob/living/simple_animal/abnormality/aleph/white_night.dm`
    - `code/modules/ordeals/pink_ordeals.dm`

## Combat Challenges
- ✅ **IMPLEMENTED** - Kill Claw (already exists as WhiteMidnight achievement)
    - `ModularTegustation/tegu_mobs/the_claw.dm`
- ✅ **IMPLEMENTED** - Damage PBird
    - `code/modules/mob/living/simple_animal/abnormality/teth/punishing_bird.dm`
- ✅ **IMPLEMENTED** - Kill PBird (separate achievement)
    - `code/modules/mob/living/simple_animal/abnormality/teth/punishing_bird.dm`
- ✅ **IMPLEMENTED** - Kill Distorted form
    - `code/modules/mob/living/simple_animal/abnormality/aleph/distortedform.dm`

## City Exploration
- Get to the happy room in the city
    - *Needs investigation for city map files*

## Role-Specific
- ✅ **IMPLEMENTED** - As a clerk role, use a weapon that isn't ZAYIN or TETH
    - `ModularTegustation\ego_weapons\_ego_weapon.dm`, just check if the weapon has requirments, and if the mind is of a clerk

---
*Note: More achievement ideas to be added. Files marked with "Needs investigation" require further searching to locate the appropriate implementation files.*
