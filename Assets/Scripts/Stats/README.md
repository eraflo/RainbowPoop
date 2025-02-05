# Stats System

## Stat Modifier

A stat modifier is something that come to apply a modification on a stat.

That way, we don't lose the original stat (the base stat) and we keep track of all the modifications that affect a stat at any time.
We can also remove a specific modifier at any time easily.

3 types of modifier :
- `Flat` : apply a flat change, which mean add or substract, to the stat.
- `PercentAdd` : apply a percentage-based addition to the stat. This means that the stat is increased by a certain percentage of its base value (_+10% = multiply by 1.1_). Multiple `PercentAdd` modifiers are summed up before being applied to the base value.
- `PercentMult` : apply a percentage-based multiplication to the stat. This means that the stat is multiplied by a certain percentage. Each `PercentMult` modifier is applied sequentially.

## Player Stat

It corresponds to a stat of the player.
Each stat characterize a physical phenomena that affect the player character (_e.g. the speed, the jump force, etc._).

To access the value of a stat, you can do `stat_name.value`. This is the calculated value. 

The base value is given with `stat_name.base_value`, but try to not use it as much as possible.

A stat can be affected by a `Stat Modifier`, which apply a modification to the value of the stat. You can do `stat_name.add_modifier()` to add a new modifier on the stat.

List of player stats :
- `max_speed` : the maximum speed the player can achieve.
- `jump_force` : the amount of power used by the player to jump.
- `friction` : how much the player is affected by friction.
- `falling_speed` : the speed at which the player falls.
- `bounce_factor` : how much the player bounces upon impact.
- `stat_drain` : debuff applied on each stat
- `vision_fog` : the amount of vision impairment the player experiences.
- `stun_duration` : the duration for which the player is stunned.
