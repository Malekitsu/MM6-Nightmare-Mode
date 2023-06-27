# MM6-MAW-Monster-Arts-and-Wonders
The MM6 Rework Mod

Creators: Tnevolin, Rawsugar, Malekith, Eksekk, Raekuul.

Names are not ordered by importance: everyone had a key role and put a lot of effort into this.

Note to users

# Patch 2.1 Changelog
## Mod Files merging
- Many Files have been compressed into one file, if you had a previous version make sure to delete older mod files
  
## Quests and Events
- Added chain quest that leads you to new game +
- Fixed many events for improved functionality and performance

## User Interface
- Right clicking Statistics (like Might, AC etc...) will now show extra informations calculated based on current value
- Tooltips will now have colors to improve readability
- Items are categorized as follows:
  - White: No enchants
  - Green: 1 enchant
  - Blue: 2 enchants
  - Purple: 3 enchants
  - Orange: Ancient items
  - Red: Primordial items
  - Brownish: Artifacts
  
## Hats and Crowns
- Hats and crowns now have an extra enchantment that increases spell damage or healing (or both if lucky)
- 
## Status effects
- Poison will no longer reduce statistics but will slowly drain HP and will expire after around 20 seconds
- Further poison application will increase duration (has a capped duration)

## Crowd Control (CC) Rework
Keep in mind that the following skill effects are increased by enchants and artifacts(except Finger of Death):
- Charm and Turn to Stone now hit 1-2-3 enemies based on skill level (novice-expert-master)
- Charm now works in turn mode
- Mass Fear now roots enemies in fear in turn mode
- Paralyze now has an additional 4-5-6% chance per skill level to work (e.g., if you had a 20% chance to hit, at light 10 expert, it becomes 20 + 50% = 30% chance)
- Most CC durations will be reduced based on monster level^0.7
  - Example: If you level Light and use Paralyze with a duration of 3 minutes (6 seconds in real time), at rank 15 against a level 30 monster, it will last: `3 * 15 / 30^0.7 = 4.16` minutes duration (8 seconds in real time).
- Finger of Death will now have reduced effects on unique monsters and bosses, but chances exceeding 100% will not be wasted and will contribute to the success percentage.
- Slow now works as a damaging spell
-Tooltips will be automatically be updated ingame with calculation
# PATCH 2.0

## Stats Rework
- Breakpoints occur every 5 points, granting 1 effect.
- The vanilla effect remains unchanged, but you now receive additional bonuses based on specific stat thresholds:
  - Every 5 points in Strength grants 1% melee and bow damage.
  - Every 5 points in Intelligence/Perception grants 1% spell damage and 1% spell critical damage (only the highest bonus will be used).
  - Every 5 points in Accuracy grants 2% melee and bow critical damage.
  - Every 5 points in Endurance grants 1% maximum HP.
  - Every 5 points in Speed grants 0.5% dodge chance.
  - Every 5 points in Luck grants 0.5% critical chance.
- AC (Armor Class) reduces the physical damage you take.

## Enchants Rework
- Items can now have up to 3 enchants simultaneously.
- The likelihood of obtaining 3 affixes increases with higher loot levels.
- Crowns will have a 4th enchant, increasing spell damage and/or healing.
- HP/SP (Health Points/Spell Points) will have double the value on items.
- Weapon elemental damage enchants are significantly stronger, dealing up to 4 times the damage and will work also on spells.
- A single enchant can now provide dual immunities from the following pairs:
  - Disease and Curse Immunity
  - Insanity and Fear Immunity
  - Paralysis and SP Drain Immunity
  - Poison and Weakness Immunity
  - Sleep and Unconscious Immunity
  - Stone and Premature Ageing Immunity
  - Death and Eradication Immunity (+5 Levels)
- Poison will now deal damage over time, depending on poison level and player base HP instead of decreasing stats.

## Item & Loot Rework
- Weapons and shields become more powerful as their tier increases.
- Loot level is influenced by the party's level, with low-level parties finding up to tier 4 items and high-level parties finding at least tier 3 items.
- Keep in mind that chest loot is loaded upon entering the map, so entering a map when low level might downgrade some loot; it's NOT recommended to enter high-level maps if you plan to clear them within reset time.
- There's a chance to obtain "Ancient" items, which have 3 enchants and can have up to 40 stats.
- There's a very small chance to find a "Primordial" item, which has perfect rolls.

## Mastery
- Many new classes have been added to the game, with more to come.
- All classes now have a new skill called Mastery, which provides unique bonuses based on the class.
- Original classes also have their own Mastery skills:
  - Knight: Each rank in Mastery grants 1% damage and toughness.
  - Archer/Paladin: Each rank in Mastery grants approximately 3% damage at the cost of skill points. The bonus is larger when spellcasting and weaponskills are ranked more equally.
  - Sorcerer/Cleric/Druid: Each rank in Mastery provides approximately 3% reduced damage from physical attacks and 2% increased damage at the cost of mana.
  
The Mastery skills enhance the abilities and effectiveness of each class, allowing players to further specialize and customize their gameplay experience.


## End Game Quest and New Game+
- A new end chain quest has been added with epic events that ultimately unlock the New Game+ mode.
- New Game+ features stronger monsters, items, and quest resets.

## Body Building (BB) Change
- Body building will give proportionally more HP to lower base HP classes.

## Mail/Plate Damage Reduction Removal
- Due to the changes in AC, the physical damage reduction provided by mail and plate armor has been removed and AC gained increased; up to 5 for mail and up to 7 for plates.
- Plate will now provide up to 2 resistance per skill level.

## Spell Resistance Formula Rework
- The spell resistance formula for players has been changed, making resistance stats more useful and reliable even at higher levels.
- This change ensures that resistances provide effective protection against spells and magical attacks, enhancing the survivability of players against magical threats.

## Monster Scaling Boost
To compensate for the immense power provided by items, monsters have received a significant scaling boost, particularly at high levels. This means that battles against monsters will be much more dangerous and challenging.

- Poor itemization choices will make your life harder as you face tougher opponents.
- However, with good itemization and dedicated farming, the benefits will be noticeably rewarding.
- It is now crucial to strategize and optimize your gear to overcome the heightened difficulty of monster encounters.
## End of patch 2.0 notes
# Nightmare Mode features

## **Nightmare Mode**

This mod will feature:

4 new dungeons, Even Harder monsters, Epic boss fights, Epic loot.

Identify Item and Repair are learned in Goblinwatch and Abandoned temple. Good luck finding them.


## **Goal**
In **MAW** we strive to rebalance the game, to make all aspects useful, challenging and fun. The goal has been to stay as true to the original game as possible while still achieving this.

**Monsters** have been made stronger, their hitpoints and damage increased, so that monster damage keeps pace with the players defensive skills and items.

Missile attack now home in on target, you can only dodge ranged attacks by running in and out of range or dodging behind an object/wall.

Monster speed has been increased to match or exceed player speed. 

**Arts**, or skills, have been changed to be more relevant. Weapon skills have been changed to increase damage at a pace similar to spells (balanced for ca half shrap metal damage). Some skills have become shared either between all characters (such as identify) or between variations of the skill (like main hand weapons)

**Wonders** of magic, or spells, have been changed to make them all useful, and monster resistance have been modified with the same goal in mind. A few spells that were subpar in vanilla have been buffed significantly to be viable options.

Many spells have been modified to reduce downtime, or make them easier to use.

### **What you need to know/Early game advice**
The mod has been balanced to be medium difficulty for veteran players. There is an easy mode that can be enabled (see customized modes below). Especially early on it might be a challenge even for veteran players due to the jump in difficulty. Here’s some advice to help you familiarize yourself with the dynamics of the mod.

- As described above; monsters are stronger, weapons more useful and spells more balanced. Forget what you know about some spell or weapon being useless : it has probably been changed.
- Defensive skills are important even early in the game. Bodybuilding has been changed so that it doesn’t fall off late game. Early on it will greatly increase your hitpoints, consider prioritizing it.
- The arrow spells that cost 1 at expert and 0 at master now deal damage per rank and are very useful in early game for casters as a substitute of bow.
- It's a good idea to do the letter quest early on. Be aware that you can sneak up the hill at castle ironfist from the lower village. running up the road will agro monsters.
- Because monsters move faster than you and you can't dodge their attacks, pulling monsters is now key to victory, and carelessly alerting too many monsters will get you killed very fast.
- Try to fight monsters that aren’t too much higher level than you, monster and player strength increases exponentially with level

That’s really all you need to know to get started, just install and enjoy the fun 🙂

But if you’re curious to know more about the mod and the specific changes, here’s the list:
## **Classes**

**Knight:**

Knights get 1, 1.5, 2 (depending on promotion)  bonus damage with main hand and offhand (shield included) per level of skill.

Knights also get 2 bonus damage per skill point on Bow once Champion.

**Paladin:**

Paladin can now use light magic.

Paladin hp per level increased to 4-5-6, base mana increased to 8 and mana per level increased to 2-3-3 and gets a bonus of 50% mana regeneration (check meditation skill for more info).

Paladin gets 0, 0.5, 1 (depending on promotion) bonus damage with main hand and offhand (shield included) per level of skill.

**Archer:**

Archer is now a formidable bow user, and will have the following bonuses: 

Base: + 2 Attack per skill point.

1st Promotion: + 1 Damage per skill point.

2nd Promotion: +2 Damage and 1% Attack Speed per skill point.

Archers also have bonus critical damage with Daggers (175% with 1 dagger, 300% with 2 daggers) making it a really good dagger user.

Archer can now use dark magic.

Archer hp per level increased to 3-4-5, base mana increased to 8 and mana per level increased to 2-3-4.

Archer gets 0-0.5-1 (depending on promotion) bonus damage with main hand and offhand per level of skill.

**Druids:**

Druids can no longer use shields.

Many starting abilities have been changed.
## **Skills**
Most skills have been reworked to provide meaningful and rewarding choices.

Attack speed calculations have been changed, now 10 speed provides a 10% increased attack speed. See recovery.

Dual wield now sums damage, attack speed and attack from both weapons, instead of taking some stats from main weapon and others from off weapon.


**Staff:**

Staff has a chance of 10+2% per level of skill to Shrink or Feeblemind.

Novice: Adds 1 Attack bonus and 2 Armor Class per point of skill

Expert: Skill adds 1 extra Attack Bonus and increases party’s resistances to everything by 1

Master: Resistance bonus doubled

**Sword**

Can now be dual wielded at any mastery, but will not grant class bonus damage when equipped in main hand. Base Bonus Speed: 10

Novice: Skill added to Attack Bonus

Expert: Skill adds 2 Attack Bonus and 2% Attack speed

Master: Skill added to damage bonus

**Dagger**

Dagger can be dual wielded at any mastery but will not grant class bonus damage when main hand. 

Critical damage now increases the total damage, not only the weapon damage. Equipping 1 dagger will multiply damage by 140% on crits, dual wielding dagger will cause the total damage to be multiplied by 250% on crits, allowing huge crits.
Critical chance is 5+1% per skill level (10+1% for archers)
` `Base Bonus speed: 40

Novice: Skill added to Attack Bonus

Expert: Skill added to Attack Bonus(Double bonus)

Master: Skill added to Attack Speed

**Axe**

Axe is one of the best weapon to deal as much damage as possible

Holding Axes with 2 hands grants 1, 2, 3 bonus damage/skill level depending on the skill mastery

Base Bonus Speed: 20

Novice: Skill added to Attack Bonus

Expert: Skill adds 2 Attack bonus, 1 Damage bonus and increases 2% Attack speed

Master: Damage bonus doubled

**Spear**

Spear is recommended early game and it's really solid throughout all the game, having a higher chance to hit and less chance to get hit. Base Speed: 10

Holding spears with 2 hands grants 1, 2, 3 bonus damage/skill level depending on the skill mastery

Novice: Skill added to Attack Bonus

Expert: Skill adds 2 Attack bonus, 1 Damage bonus and 2 Armor Class

Master: Skill adds 3 Attack bonus, 2 Damage bonus and 4 Armor Class

**Bow****

Novice: Skill adds 3 Attack Bonus and 1 Bonus Damage

Expert: Bonus Damage Doubled

Master: Bow fires two arrows on every attack

**Mace**

Mace has a 5+0.25% chance per skill level to paralyze.

Novice: Skill added to Attack Bonus

Expert: Skill added to Attack Damage, Attack Bonus doubled

Master: Attack Damage per Skill doubled

**Shield**

Shield skill now reduces ranged damage to all party by 1% per skill level, bonus is tripled on Knights. (Effect is multiplicative, so the actual formula is damage\*0.99^skill)

Novice: Skill added to Armor Class

Expert: Skill added to Armor Class (double effect)

Master: Skill added to Armor Class (triple effect)

**Leather**

Leather is now really good to resist magic damage

Novice: Increases 1 Class Armor and 2 to all Resistances per point of skill

Expert: Increases 2 Class Armor and 4 to all Resistances per point of skill, Recovery penalty reduced

Master: Increases 3 Class Armor and 6 to all Resistances per point of skill, Recovery penalty eliminated

**Mail**

Mail now has reduces physical damage by 1% per skill level in addition to reduce some magic damage

Novice: Increases 2 Class Armor and 2 to all Resistances per point of skill

Expert: Increases 3 Class Armor and 3 to all Resistances per point of skill, Recovery penalty reduced

Master: Increases 5 Class Armor and 4 to all Resistances per point of skill, Recovery penalty eliminated

**Plate**

NEW COVER MECHANIC: Wearers of Plate armor place themselves on the front lines, absorbing attacks otherwise destined for their allies, granting a COVER chance.

Novice: Increases 3 Class Armor per point of skill, grants 10% chance to Cover allies

Expert: Recovery penalty reduced, Cover chance doubled, each point of skill reduces meele damage taken by 2%

Master: Recovery penalty eliminated, Cover chance tripled

**Bodybuilding**

Bodybuilding now also increases also 1% of maximum health, making it strong in all stages of the game

**Meditation**

Meditation now also grants mana regeneration.

The formula is: 

Mana^0.5 \* MeditationLevel^2/400 capped to 30 mana/5 minutes (10 seconds in real time), meaning that regeneration depends on both total mana and meditation skill. Paladins with 2nd promotion gets an extra 50% regeneration.

**Learning**

Grants 9% bonus exp baseline, and grants following bonuses:

Novice: +3% exp/skill

Expert: +4% exp/skill

Master: +5% exp/skill

Bonus exp cap is at 60% making any skill point past lvl 12 being wasted.
### **Skill linking**

Now many weapon and armor skills are shared to allow a more dynamic gameplay and to let players test many different setups.

Shared Skills are divided in 3 types:

Main Hand, Off Hand, Armor.

**Main Hand:**

Staff, Axe, Spear, Mace

**Offhand:**

Sword, Dagger

**Armors:**

Leather, Chain, Plate

There are also some miscellaneous skills that are shared within the whole party.

Those are: Identify, Merchant, Repair, Perception, Disarm, Diplomacy.
### **Recovery**
**Recovery caps**

Melee recovery cap is reduced to 10. It’s very unlikely you will reach it.

Ranged recovery cap hasn't been changed, but it isn’t reachable anymore.

**Computation mechanics**

Intuitive player assumption is that bigger stat value is better, the bonus is positive, penalty is negative. MM recovery mechanics uses an inverse scale which makes it a little difficult to grasp at first. This also creates an inherent flaw when attack rate grows faster with skill progression and then suddenly stops at an easily reachable cap. From then on it is a complete waste to invest into recovery any more. All speed increasing weapons suddenly become ineffective to develop any further.

This mod internally introduces a notion of attack rate which is a reciprocal to recovery time. All recovery time bonuses now increase the attack rate and it is computed the same way as any other positive game stats. Meaning adding 100 attack rate bonus on top of initial 100 attack rate value makes player attack twice as fast which corresponds to 50 recovery. With this approach reaching recovery time cap is still possible but much harder. See computation example below.

Keep in mind that even though computation mechanics changed the attack rate value is still converted to recovery for the purpose of UI display and in-game text/help and combat computations.

Computation example

**Vanilla**

Dagger    =  60 base recovery

500 speed =  30 recovery bonus

haste     =  25 recovery bonus

result		=   5 recovery which is actually capped at 30

**This mod**

Total recovery bonus from above example: 40 (dagger) + 30 (speed) + 25 (haste) = 95

Resulting attack rate:                   100 + 95 = 195

Converting back to recovery:             100 \* (100 / 195) = 51, cap is not reached


To cap Melee Speed you would need 1000 speed: 100 \* (100 / 1000) = 10
## **Spells**
General changes;

- Low cost spells have been significantly buffed, to be relevant throughout the game
- Medium-low cost spells (4-10) have altered casting costs at master, making them viable late game
- Very high cost spells (cost 30-65) have been buffed somewhat
- Max resistance has been reduced to 120 and immunity removed from the game, this makes it possible to specialize in a single school while still making damage much lower vs high resistance. It also makes spells like finger of death viable.
- Magic resistance is still very common but magic damage spells (mind magic, mass distortion) have been balanced to deal +50% damage
- All stat boost spells affect the whole party at novice level.
- Spells that incapacitate monsters have been buffed significantly, reducing either cost or casting time
- Spells that have been buffed significantly are arrow spells/mind blast, ice blast, sun ray
- Day of protection has been significantly nerfed making Dark magic an option among others.


|Spell name|Vanilla damage|New damage/effect|Comment|
| :-: | :-: | :-: | :-: |
|flame arrow|1d8|6+1d2 pr rank|Arrow spells were unusable doing less damage than bows at cost. Now they are usable for most of the game|
|static charge|1d5+1|5/12/20+1 pr rank|Arrow spells were unusable doing less damage than bows at cost. Now they are usable for most of the game|
|magic arrow|1d6+2|6+1 pr rank|Arrow spells were unusable doing less damage than bows at cost. Now they are usable for most of the game|
|cold beam|1d5+1|1d3 pr rank|Arrow spells were unusable doing less damage than bows at cost. Now they are usable for most of the game|
|Spirit arrow|1d6|1d5 pr rank|Arrow spells were unusable doing less damage than bows at cost. Now they are usable for most of the game. +50% damage for being magic|
|Mind Blast|5+1d2 pr rank|6+1d6 pr rank|Manacost reduced to 2 at expert and 1 at master. This balances Mind blast with the elemental arrow spells including a +50% for being magic damage|
|Sparks|2+1 pr rank|3+1d3 pr rank|at master cost is increased to 13, while strong in early game sparks lacked the punch for lategame viability.|
|Harm|8+1d2 pr rank|8+1d2 pr rank|damage type changed to physical. Damage is low compared to most spells since body is a healing school but physical makes it much stronger|
|Deadly Swarm|5+1d3 pr rank|2+1d4 pr rank|damage changed to 8+1d4/rank, at master cost is increased to 6 and casttime halved, to keep it relevant lategame. Earth magic has been balanced so that low cost spells have high DPM but low DPS due to the cost. This is balanced by mass distortion being arguably the strongest spell in the game.|
|Fire Bolt|1d4 pr rank|8+1d4 pr rank|damage changed to 8+1d5/rank, at master cost is increased to 8 and can be cast thrice as fast, to keep it relevant lategame|
|Poison Spray|2+1d2 pr rank|1d5 pr rank|at master cost is increased to 13, while strong in early game sparks lacked the punch for lategame viability.|
|Blades|1d5 pr rank|12+1d8 pr rank|very high damage pr mana|
|Fireball|1d6 pr rank|1d6 pr rank|at master damage becomes 12+1d9 pr rank, while cost is doubled|
|Ice Bolt|1d7 pr rank|12+1d8 pr rank|at master cost becomes 11 and the spell can be cast twice as fast makes the spell more relevant lategame|
|Lightning Bolt|1d8 pr rank|12+1d9 pr rank|at master cost becomes 14 and the spell can be cast 1½ times as fast, makes the spell more relevant lategame|
|Ring of Fire|6+1 pr rank|10+1d3 pr rank|modified to account for monster hitpoint being doubled|
|Rock Blast|1d8 pr rank|1d8 pr rank|unchanged|
|Fire Blast|4+1d3 pr rank|2+1d5 pr rank|makes the spell more relevant lategame|
|Acid Burst|9+1d9 pr rank|20+1d12 pr rank|damage adjusted|
|Implosion|10+1d10 pr rank|18+1d13 pr rank|damage adjusted|
|Meteor Shower|8+1 pr rank|1d3 pr rank (x8-16)|increased damage at higher ranks; accounts for monster hp being doubled and rewards high rank more|
|Flying Fist|30+1d5 pr rank|30+1d15 pr rank|damage type changed to physical, keeps damage low since body is a heling school but physical makes it much stronger|
|Death Blossom|20+1 pr rank|1d10 pr rank|along with better targeting the massive damage boost makes this spell usable|
|Inferno|8+1 pr rank|1d4 pr rank|increased damage at higher ranks; accounts for monster hp being doubled and rewards high rank more|
|Psychic Shock|12+1d12 pr rank|47+1d30 pr rank|Due to being magic damage psychic shock gets +50% damage|
|Ice Blast|12+1d2 pr rank|6+1d9 pr rank|High damage boost, while it sometimes miss small targets entirely, at this damage it just needs to hit twice which it will often against large targets or groups|
|Starburst|20+1 pr rank|1d6 pr rank|increased damage at higher ranks; accounts for monster hp being doubled and rewards high rank more|
|Toxic Cloud|25+1d10 pr rank|20+1d20 pr rank|damage adjusted|
|Incinerate|15+1d15 pr rank|32+1d21 pr rank|damage adjusted|
|Destroy Undead|16+1d16 pr rank|50+1d40 pr rank|damage adjusted|
|Shrap Metal|6+1d6 pr rank|6+1d6 pr rank|unchanged|
|Prismatic Light|25+1 pr rank|25+1d7 pr rank|damage adjusted|
|Sun Ray|20+1d20 pr rank|60+1d40 pr rank|damage adjusted|
|Moon Ray|1d4 pr rank|1d4 pr rank|unchanged|
|Dragon Breath|1d25 pr rank|1d30 pr rank|damage adjusted|
|Armageddon|50+1 pr rank|1d5 pr rank|150|
|mass distortion||cast time doubled|effect is unchanged, however with double monster hitpoint and max resist at 120, even casting it half as fast its still one of the strongest spells in the game|
|dark containment|||cost reduced to 100|
|||||
|charm||Casts 10 times as fast|Even at max 120 resist spell is too often resisted to be worthwhile. Casting it very fast makes it a strong spell with high chance of taking effect|
|mass fear||Casts 2 to 3 times as fast|Even at max 120 resist spell is too often resisted to be worthwhile. Casting it very fast makes it a strong spell with high chance of taking effect|
|turn to stone||casts 4 times as fast|Even at max 120 resist spell is too often resisted to be worthwhile. Casting it very fast makes it a strong spell with high chance of taking effect|
|shrinking ray||cost reduced from 60 to 16|Essentially a kill spell, but one that requires spending a lot of time killing the target. To make it worthwhile cost is greatly reduced|
|paralyze||cost reduced from 60 to 25|Essentially a kill spell, but one that requires spending a lot of time killing the target. To make it worthwhile cost is greatly reduced|
|Finger of death|||spell is unchanged, however with double monster hitpoint and max resist at 120, it is much stronger|
|<p>Several debuff heal spells have been given a heal hit point effect, aside from at the rank just when you get expert or master they are somewhat worse than dedicated heal spells.</p><p>Mind has been given some fairly powerful heal spells and while Spirit is still stronger for healing, and Body stronger still, Mind is a good option for an offhealer.</p>|
|Healing Touch|5/7/9|5/10/15+2/3/5 pr rank|cost 3/6/12|
|Remove curse|N/A|5/30/70|cost 3/6/12, since spirit can be master even at rank 4, spirit becomes a decent healing school for few skillpoints thanks to this spell|
|Shared Life||cost reduced to 12, casts 3 times as fast,|due to high cast speed is now the second best heal spell in the game with good value for skillpoints|
|Resurrection||150+15 pr rank|Cost increased to 200, recovery time reduced from 1000 to 300 (around 4 times Cure Wounds)|
|Remove fear|N/A|2/10/50|Cost 2/4/6|
|Cure Insanity|N/A|15/25/35+4/5/6 pr rank|Cost 20/30/40|
|First aid|5/7/10|5/15/100+0/0/12 pr rank|Cost 2/3/100, at master it takes twice as long to recover from casting|
|Cure wounds|5+2|10/15/25+3/4/5 pr rank|Cost 5/8/16, stays relevant longer|
|Cure poison|N/A|15/30/65||
|Cure disease|N/A|25/45/90||
|power cure|10+2 pr rank|10+3 pr rank|Buffed to better keep up with high monster damage|
|||||
|Day of protection|4 pr rank|2 pr rank|Still a very strong spell, but no longer enough to make Dark a necessity|

## Monsters

- Monster hitpoints have been doubled
- Monsters deal double damage early on, and keep pace with increased player hitpoint and defenses, ending up at around 7 times vanilla damage, so you will need to balance both the offensive and defensive part of your build.
- Most monster, melee in particular, have increased speed
- Most ranged attacks now have homing, making dodging shots difficult. You can only dodge ranged attacks by running in and out of range or dodging behind an object/wall. (see below)
- With monsters automatically hitting and outrunning player, carefully pulling monsters becomes essential to survival.
- Monster resistance capped to 120, removing magic immunity.
- Some melee monster will now occasionally do a ranged spell.
- Many annoying skills have been removed or chance heavily reduced (dispel for example)
- Monsters will now walk toward you linearly, instead of going zig-zag.
- Monsters now have accurate tooltips showing all you might desire.
- Engaging enemies will now increase the pull range of around 20%, making 1 by 1 pull harder, unless you use walls to separate packs.

Some monsters/dungeons have been relocated when players consistently entered the area at too high or low level, or when the gap in monster level in the same area was too high for a consistent challenge. As few as possible of such changes have been implemented:

- Silver helm outpost in mist is now a level ~9 dungeon
- Thieves and monks have reduced level, making Shadow Guild Hideout and Free Haven Sewers, as well as the temples in Booty Bay level ~13 dungeons.
- The path to Castle Stone has been made lower level (butit’s wise to be level 20+ before attempting it)
- Monks have replaced the clergy of baa in Temple of Baa, and the clergy of Baa have been made level ~50, making the superior and the supreme temple of baa late game dungeons.
- Swordsmen have been made much higher level making Silver Helm Stronghold much harder (level ~38 but doable with difficulty from 30 or so), as well as Lair of the Wolf

## Miscellaneous

### Quest xp
Most noncombat quests give reduced XP, while delivering the memory crystals will reward you more. This serves the dual purpose of making running around for free XP early on much less interesting - although still an option, and to make sure the characters gain levels at roughly the same pace as the monsters they face.
### Economy
Higher level spellbooks are now really expensive

Increased cost of some of the strongest followers.

Inn and Temples cost now depends on missing health and level.
### Balance
MAW has been designed to be somewhat challenging gameplay for the experienced player, however, until you find your footing it may be too hard. Furthermore then last dungeon(s) have been balanced to present a reasonable challenge to even a very strong party, leveled to 100 or more. You might not want to kill all those dragons and titans needed to rise to quite so high level, however. At the same time the existence of “of X spellschool” items (of Dark etc) and the wells that increase level are impossible to balance around since we don’t know when or even if the player will use them. For that reason the game has been balanced as if these things didn’t exist but we haven’t removed them from the game. Their use is optional. The game has been designed to be challenging but possible to clear without them, but if you wish to finish early or faster they are still around for you to use. Think of them as mildly abusive cheatcodes that help you speed things along if you need them.
### Attributes
Attributes will now be relevant during all the game and from 25 on, every 5 attribute points grants +1 effect, up to 300 attribute points (+60 effect). Check here for an accurate description of effects. (credits to grayface) https://grayface.github.io/mm/mechanics/ .

Pilgrimage can now be done at any time of the year. Even if years pass you can take all years' bonus.

New Sorpigal Portal to dragonsands moved into the Oasis, instead of the shrine of god obelisk.

#### Hirelings
We've changed the probability of different professions appearing based on nice analysis here.

Some useless professions should not appear at all. Some professioncosts are adjusted.



|Hireling|Cost|
| :-: | :-: |
|ArmsMaster|1500|
|WeaponsMaster|3000|
|Squire|3000|
|Burglar|500|
|Factor|100|
|Banker|200|
|Instructor|1500|
|Teacher|800|
|Apprentice|1500|
|SpellMaster|2500|
|Mystic|4000|

### Bringing needed hirelings to party
This is a convenience fix. I am tired of reloading game hundreds of times just to find the needed hireling. Time waste. I have implemented a keyboard shortcut that brings available outside walking peasants to the party and set their professions. I've added just two now but can do more if people need more shortcuts.

•	Works outside only and brings outside peasants only if they are available.

•	Hiring peasant NPC removes them from the map so you may run out of them on a particular map.

shortcut	 hirelings	comment

Alt+1	Weapons Master, Squire	physical offense and defense

Alt+2	Spell Master, Mystic	magical offense and buffs

Alt+3	Enchanter	magical defense

Alt+4	Instructor, Teacher	experience

Alt+5	Banker, Factor	money collected

Alt+6	Merchant, Trader	trading selling/buying

Alt+7	Pathfinder, Tracker	travel speed = food reduction in transit

Alt+8	WindMaster, WaterMaster	reaching to places

## Party composition



|Class|hitpoint pr level|mana pr level|Melee weapon|ranged|healer|secondary skill|
| :-: | :-: | :-: | :-: | :-: | :-: | :-: |
|knight|4/6/8|N/A|excellent|bow (ca 75%f damage)||shield|
|paladin|3/4/6|2/3/3+|good|mind/light (\*)|extra hp, less mana|spirit|
|archer|3/4/5|2/3/4+|good (and Dark/cold/fire)|bow+elemental+dark||elemental (dark)|
|cleric|2/3/4|3/4/5|bad (Dark)|mind/dark/light|lots of mana, shield, chain|spirit, light (dark)|
|sorcerer|2/3/4|3/4/5|bad (Dark)|elemental/dark/light||elemental, light (dark)|
|druid|2/3/4|3/4/5+|bad|elemental/mind|extra mana, no shield|spirit+elemental|

Characters fall roughly within 3 roles; melee, ranged, healer. the party can be combined by any number of melee or ranged, but its highly advisable to always include a healer.

Similarly a water caster with master/12 is a key component of a strong party

secondary roles might be tank and offhealer, even debuffer. Offhealer is very helpful, the others are more optional

Every class can be a ranged character although knights have low damage with bow even at master rank, but their bonus to shield makes them a great asset in ranged fights however

Melee usually means either weapons or dark magic, a few elemental spells (ice blast, fire blast, ring of fire) reward fighting at close range, but non archer casters are fairly brittle in close combat

Roughly, paladins/archers have 20% less hp than knights, and 20% less damage in melee at the same skill rank. They have access to spells, while knight have a bonus to shield

Similarly, paladin/archer have 15% more hp than casters, and 25% less mana. Its possible to make a archer/paladin spellcaster with low or no ranks in weapons but especially early  on you will run low on mana fairly fast.

"Secondary" skills are skills that even with low skill investment can be hugely beneficial for the party. Prime among these are spirit (raise dead, healing touch, shared life - strong even at expert/4), and Water (town portal which even at expert/4 can save party)

Earth has stone to flesh, mind cure paralysis, body, earth and spirit can heal a host of minor status effects, air gives fly, jump shield and since it can be trained to master at rank 4 can give a lot of resistance with the right followers

dark follows somewhat within this group because if the party doesn't have a lot of elemental casters Day of Protection can offer huge benefit even at relatively low rank like master/12

### Some sample parties

#### KAPD/Knight, Archer, Paladin, Druid

This combination of classes best showcases the changes made to the various skills.  Knights have the option to become either an offensive powerhouse (by focusing on weapons) or a defensive bulwark (by focusing on Shield and Armor), Archers (and the improved bows) and Paladins (and their bonus regeneration from Meditation) now get Dark and Light magic respectively, and even though Druids no longer can wear shields they still can take an important defensive role by mastering Staves instead (which increases the party's resistances to Fire/Cold/Electric/Poison/Magic). 

#### PACS/Paladin, Archer, Cleric, Sorcerer

The Quick Start party is still fully viable. However, note that while both paladin and archer can deal good damage in melee, especially if the archer uses dual daggers, PACS is best played as a ranged party with cleric or paladin off-healer using either mind or spirit magic at master rank or higher (spirit can be mastered at rank 4). Paladin makes an excellent healer but also has a strong ranged attack using mind magic. Cleric can also function as main healer,  and for ranged attack can use mind magic or dark. Light magic has some interesting options for either class as well. Archer can either use primarily his bow or one of the magic schools for his ranged attack. Bow goes well with dark magic to provide a strong free ranged attack and using shrap metal in melee, but any combination can be used.

#### SSCC/Sorcerer, Sorcerer, Cleric, Cleric

The old standard party of the power player. Triple dark caster is still a very strong option, though not the powerhouse it was in vanilla. Dark lacks early spells, and much of the free early XP in vanilla has been removed from the game, so you are going to need at least some of the characters to rank another skill to make early game efficient. A secondary school ranked to 12/master won't mean much for your dark magic skill in later levels. Once you get to high rank in Dark, however, it’s a strong school. Finger of Death is a very strong spell, especially when the whole party is casting them, and shrapmetal is still the strongest damage spell in the game. However, with the high monster damage in MAW you will find a Dark caster party much more fast paced and challenging due to their smaller health pools.

#### PPAA/Pladin, Paladin, Archer, Archer

A very versatile party. The double paladin is enough to provide the needed tanking and archers and paladins deal great damage in melee. Paladins have about 20% less hitpoint and deal about 20% less damage than knights, but make up for this with access to healing and raise dead. Due to how ranks are costed it's possible to get a decent damage as well as healing by ranking both, but there’s also the option of having one of them rank offense (melee weapon) with either mind or spirit ranked to master but no further. Both classes also have the ability to deal strong ranged damage. Hybrid classes have about 25% less mana than the casters,  but make up for this by an extra 20% hitpoint, so an archer with high rank in an elemental school will deal the same damage as a sorcerer or druid, although they will need more downtime to regain mana.

#### Any combination is possible though

Ranged, melee, combined arms, specialized in dark or fire AOE, Crowd-Control. The options are endless. It’s a good idea to think about the pace of mana consumption; a single dark user will be difficult to use alongside characters that don’t use mana because Dark needs almost constant replenishing of mana, but otherwise, other than the need for healers pretty much any combination can work and will have its own strengths and weaknesses.
## Customized modes

MAW extends mm6.ini with a [Skill Emphasis] section, which contains the following settings:

`MoreLinkedSkills=false`    
Links more skills for less aggressive min/maxing.  
Notably, this links related schools of magic with each other.

`ImprovedQuestItems=true`    
Modifies the descriptions of many permanent items to show who they get delivered to.    
This also disambiguates keys whose names overlap with each other in vanilla (mostly this affects the Castle Ironfist Temple of Baa).     

`MonsterExperienceMultiplier=1`    
Multiplies the EXP that monsters give on death.  Stacks with Learning.  This can be set to 0 to disable monster EXP entirely.

`RandomizeMapClusters=false`    
This randomizes what monsters are assigned to maps in Mapstats.txt    
The randomization is done at program start, not on New Game start - this means that the monsters will change if you save and quit between map respawns.    
Certain types of monsters (recruitable peasants, reactors, demon queens) are not available in the randomization.    
This does not affect the normal spawning of peasants in towns where they 'should' be available.

`ResistancesDisplayMode=default`    
Changes how resistances are displayed in the monster infobox.    
`default` shows the chance for that damage type to be resisted.    
`effect` shows the average percentage of damage that would be dealt.    
`disabled` shows the raw resistance numbers.

`ShowDiceInSpellDescription=false`    
Changes spell descriptions to use Dice Notation (1d8+3) instead of the more verbose default (3 damage plus 1-8 per point of skill).    
This feature is not yet considered complete.

`EasierMonsters=false`    
Easier Monsters reduces monster damage by approximately 33%.    
Additionally, flying monsters are changed to have a melee attack as their main attack if they weren't already.  This has the effect of causing flying monsters to actively close in on the party.

`GlobalMapResetDays=default`    
Number of days between map resets, for maps where a custom reset timer has not been defined.    
A setting of 0 means the map will reset every time it is reloaded, whether by map transition or by loading a saved game.    
`Default` - Maps without a custom reset timer will reset based on what is defined in Mapstats.txt    
`Never` - Maps without a custom reset timer will never reset.

`AdaptiveMonsterMode=default`    
Modifies monsters further.  This mode is unfinished and not in a state we are happy with, use at your own risk.
`default` - disabled.    
`disabled` - disabled.    
`party` - monsters are adjusted relative to the party's average experience total, then adjusted per-monster based on tier.  Please note that this is specifically *not* the party's current average level.  This mode guarantees that 'Boss' monsters such as the Spider Queen are ten levels higher than the party.    
`map` - monsters' levels for the map are averaged, then adjusted per-monster based on tier.    

##
## Some Graphs
The Following Graphs take in consideration that investing in 2 separate skills requires more skill points, so for example 20 skill in Sword+Axe is equal to 28 skill points in 2hAxe. 



![alt text](https://github.com/Malekitsu/MM6-Nightmare-Mode/blob/main/Graphs/KnightAverageBuff.png?raw=true)

This Graph shows How much damage will do a Knight with an average Item/Buffs/Stats relative to Skill Level.
Meaning that if you have a lot of strength items, a spirit healer with heroism or a really good weapon, the damage will look more like this:

![alt text](https://github.com/Malekitsu/MM6-Nightmare-Mode/blob/main/Graphs/KnightHighBuff.png?raw=true)
You can see that investing just in Dagger skill isn’t enough to make it shine: you will need a lot of external support.
You could also hire followers, giving and extra boost to Build who use Dual Wield with 2 different weapon types:

![alt text](https://github.com/Malekitsu/MM6-Nightmare-Mode/blob/main/Graphs/Knight%2B5.png?raw=true)


Down here there are the same graphs but for Archer/Paladin, who have less bonus class damage:

![alt text](https://github.com/Malekitsu/MM6-Nightmare-Mode/blob/main/Graphs/PalaArcAverageBuff.png?raw=true)

![alt text](https://github.com/Malekitsu/MM6-Nightmare-Mode/blob/main/Graphs/PalaArcHighBuff.png?raw=true)
