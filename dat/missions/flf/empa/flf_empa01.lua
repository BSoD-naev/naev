--[[

   FLF-Empire Negotiations
   Copyright (C) 2014, 2015 Julian Marchant <onpon4@riseup.net>

   This program is free software: you can redistribute it and/or modify
   it under the terms of the GNU General Public License as published by
   the Free Software Foundation, either version 3 of the License, or
   (at your option) any later version.

   This program is distributed in the hope that it will be useful,
   but WITHOUT ANY WARRANTY; without even the implied warranty of
   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
   GNU General Public License for more details.

   You should have received a copy of the GNU General Public License
   along with this program.  If not, see <http://www.gnu.org/licenses/>.

--]]

-- localization stuff
lang = naev.lang()
if lang == "notreal" then
else -- default English
   title = {}
   text = {}

   title[1] = "A Better Way"
   text[1] = [[The woman looks up to you and smiles. She gestures for you to take a seat, which you do.
    "Greetings, %s", she says. "You're probably wondering who I am. My name is Cheryl, and I'm one of the higher-ranking officials of the FLF." You try to hide your disbelief in what she says, but judging from Cheryl's chuckle, she seems to see right through you. "Yes, I know. You probably imagined that I would be middle-aged and wearing a fancy uniform, didn't you?" You begin to respond to this statement, but she stops you, and her expression suddenly becomes serious.]]

   text[2] = [["Our records show that you have been of serious help to the Empire. It seems you were one of the ones responsible for the destruction of the Collective, in particular. Is this correct?" You pause for a second, wondering why Cheryl would be asking such a question.
    Finally, you answer by agreeing that what she says is true, but assuring her that they didn't send you here. She laughs. "Don't be silly. I don't think you're a spy. We are not exactly friends with the Empire; the Empire and House Dvaered are allies, after all, at least on paper. But we are not enemies with them, either."]]

   text[4] = [["In fact, the Empire has become rather annoyed with the Dvaered lately. I think you may have witnessed some of this when you conducted a prisoner exchange for the Empire some time ago. If you will recall, the prisoner exchange was going perfectly smoothly until a squadron of Dvaered ships decided to attack us. In fact, many of our Empire prisoners died in the chaos, and I have been told that the Empire higher-ups were furious.
    "And that's actually what I wanted to talk to you about. Our records show, as well, that you have somehow managed to maintain a very good reputation with the Empire even while opposing the Dvaered with us. That takes some serious dedication, and I commend you for this! It also means you are the perfect person to bring the FLF and the Empire together. Would you be interested?"]]

   npc_name = "A young woman"
   npc_desc = "This woman appears to be by herself, which is somewhat unusual for an FLF member. She regularly glances in your direction."
end


function create ()
   -- Note: this mission does not make any system claims.
   myssys = system.get( "Raelid" )
   misplanet = planet.get( "Marius Station" )

   misn.setNPC( npc_name, "neutral/miner2" )
   misn.setDesc( npc_desc )
end


function accept ()
   tk.msg( title[1], text[1]:format( player.name() ) )
   tk.msg( title[1], text[2] )
   tk.msg( title[1], text[3] )
   if tk.yesno( title[1], text[3] ) then
   else
   end
end