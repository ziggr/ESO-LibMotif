LibMotif provides add-on authors with a single API call to determine if a character knows a crafting style or not.

Obsoleted as of Update 33/ESO 7.3.0/API 101032/Ascending Tide and its account-wide achievements.

Call [LibCharacterKnowledge.GetMotifKnowledgeForCharacter()](https://www.esoui.com/downloads/info3317-LibCharacterKnowledge.html) for correct character-specific knowledge. LibMotif now does this for you so your add-on will get correct character-specific results today. But for the future, replace LibMotif calls with LibCharacterKnowledge calls. LibMotif will not be maintained further.