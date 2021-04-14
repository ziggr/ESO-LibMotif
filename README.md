LibMotif provides add-on authors with a single API call to determine if a character knows a crafting style or not.

Extracted from <a href="https://www.esoui.com/downloads/info1605-WritWorthy.html">WritWorthy</a>.

Available on [github](https://github.com/ziggr/ESO-LibMotif)

#### `LibMotif.IsKnown()`

```
local motif_known = LibMotif.IsKnown(motif_id, item_page_num)

motif_id
	one of [1..117] such as 3 for "Orc" or 48 for "Redoran"
	See LibMotif_Data.DATA for a table of all 117 values.

item_page
	one of [1..14] such as 1 for "axes" or 9 for "legs".
	Correspond to the 14 purple motif pages.

	Unused for simple styles such as 3 Orc or crown-exclusives
	such as 58 Grim Harlequin
```

#### `LibMotif.DATA`

```lua
-- Motif ID ==> Achievement ID
--
-- is_simple = true
--
-- 		For the few motifs that lack 14 individual purple pages,
-- 		is_simple is true. Use IsSmithingStyleKnown(motif_id).
--
-- achievement_id = 1423
--
-- 		For motifs with 14 individual purple pages, achievement_id tells
-- 		the achievement_id to pass to
-- 		GetAchievementCriterion(achievement_id, page_index)
--      where n is a number 1-14.

LibMotif.DATA = {
    [  1] = { is_simple       =  true } -- Breton
,   [  2] = { is_simple       =  true } -- Redguard
,   [  3] = { is_simple       =  true } -- Orc
,   [  4] = { is_simple       =  true } -- Dark Elf
,   [  5] = { is_simple       =  true } -- Nord
,   [  6] = { is_simple       =  true } -- Argonian
,   [  7] = { is_simple       =  true } -- High Elf
,   [  8] = { is_simple       =  true } -- Wood Elf
,   [  9] = { is_simple       =  true } -- Khajiit
,   [ 10] = nil                         -- Unique
,   [ 11] = { achievement_id  =  1423 } -- Thieves Guild
,   [ 12] = { achievement_id  =  1661 } -- Dark Brotherhood
,   [ 13] = { achievement_id  =  1412 } -- Malacath
,   [ 14] = { achievement_id  =  1144 } -- Dwemer
,   [ 15] = { is_simple       =  true } -- Ancient Elf
,   [ 16] = { achievement_id  =  1660 } -- Order of the Hour
,   [ 17] = { is_simple       =  true } -- Barbaric
,   [ 18] = nil                         -- Bandit
,   [ 19] = { is_simple       =  true } -- Primal
,   [ 20] = { is_simple       =  true } -- Daedric
,   [ 21] = { achievement_id  =  1411 } -- Trinimac
,   [ 22] = { achievement_id  =  1341 } -- Ancient Orc
,   [ 23] = { achievement_id  =  1416 } -- Daggerfall Covenant
,   [ 24] = { achievement_id  =  1414 } -- Ebonheart Pact
,   [ 25] = { achievement_id  =  1415 } -- Aldmeri Dominion

...

```

#### LibMotif.MOTIF_PAGE

```lua
-- What to pass as page_index for
-- GetAchievementCriterion(achievement_id, page_index)
LibMotif.MOTIF_PAGE = {
    AXES       =  1
,   BELTS      =  2
,   BOOTS      =  3
,   BOWS       =  4
,   CHESTS     =  5
,   DAGGERS    =  6
,   GLOVES     =  7
,   HELMETS    =  8
,   LEGS       =  9
,   MACES      = 10
,   SHIELDS    = 11
,   SHOULDERS  = 12
,   STAVES     = 13
,   SWORDS     = 14
}
```

