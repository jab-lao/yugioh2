extends Node

# [[null, null, null, null, null], ''],
var ygo_bosses = [
	[
		# Level 1
		[[null, 'winged dragon', 'beaver warrior', null, 'kuriboh'], 'yugi'],
		
		[[null, 'celtic guardian', null, 'beaver warrior', null], 'yugi'],
		
		[[null, 'feral imp', 'battle steer', null, null], 'solomon'],
		
		[['giant soldier of stone', 'mystical elf', null, null, null], 'solomon'],
		
		[['flame swordsman', null, 'baby dragon', 'time wizard', null], 'joey'],
		
		[[null, 'swamp battleguard', null, 'baby dragon', null], 'joey'],
		
		[[null, 'uraby', 'two-headed king rex', 'gilasaurus', null], 'rex'],
		
		[['uraby', null, null, null, 'two-headed king rex'], 'rex'],
		
		[['larvae moth', 'killer needle', 'basic insect', null, null], 'weevil'],
		
		[[null, 'larvae moth', 'hercules beetle', 'killer needle', null], 'weevil'],
		
		[[null, null, "harpie's pet dragon", 'harpie lady', null], 'mai'],
		
		[['amazoness trainee', null, 'amazoness chain master', null, null], 'mai'],
		
		[[null, 'fiend kraken', 'kairyu-shin', 'great white', null], 'mako'],
		
		[[null, '7 colored fish', null, 'fiend kraken', null], 'mako'],
		
		[[null, 'pendulum machine', null, 'giga-tech wolf', null], 'banditkeith'],
		
		[[null, 'pendulum machine', 'slot machine', null, null], 'banditkeith'],
		
		[[null, 'happy lover', 'magician of faith', 'happy lover', null], 'tea'],
		
		[[null, 'magician of faith', 'gemini elf', null, null], 'tea'],
		
		[[null, 'super roboyarou', 'y-dragon head', 'cyber commander', null], 'tristan'],
		
		[['lava battleguard', 'cyber commander', null, null, null], 'tristan'],
		
		[[null, 'duke of demise', null, 'necro mannequin', 'man-eater bug'], 'bakura'],
		
		[[null, null, null, 'doomcaliber knight', 'man-eater bug'], 'bakura'],
		
		[[null, 'hitotsu-me giant', 'battle ox', null, null], 'kaiba'],
		
		[['saggi the dark clown', 'rude kaiser', null, null, null], 'kaiba'],
		
		[[null, null, 'jirai gumo', 'dungeon worm', null], 'paradox'],
		
		[[null, 'monster tamer', null, null, 'labyrinth tank'], 'paradox'],
		
		[['molten zombie', 'clown zombie', null, 'armored zombie', null], 'bonz'],
		
		[[null, 'toon dark magician girl', null, 'dark rabbit', null], 'pegasus'],
		
		[['dark rabbit', null, 'parrot dragon', null, null], 'pegasus'],
		
		[['revival jam', null, 'makyura the destructor', null, null], 'marik'],
		
		[[null, 'embodiment of apophis', 'dark jeroid', null, null], 'marik'],
		
		[['strike ninja', null, 'gradius', null, null], 'dukedevlin'],
		
		[['dark assailant', null, 'yaranzo', null, 'gradius'], 'dukedevlin'],
		
		[[null, 'agido', "gravekeeper's priestess", 'agido', null], 'ishizu'],
		
		[[null, 'mudora', null, "gravekeeper's priestess", null], 'ishizu'],
		
		[['stuffed animal', 'shadow ghoul', null, null, null], 'rebecca'],
		
		[[null, 'giant soldier of stone', null, 'stuffed animal', null], 'rebecca'],
	],
	
	[
		# Level 2
		[['winged dragon', 'beaver warrior', null, 'celtic guardian', 'kuriboh'], 'yugi'],
		
		[[null, 'gaia the fierce knight', 'curse of dragon', null, null], 'solomon'],
		
		[['flame swordsman', 'swamp battleguard', null, 'panther warrior', null], 'joey'],
		
		[['gilasaurus', 'two-headed king rex', null, 'bracchio-raidus', 'uraby'], 'rex'],
		
		[['basic insect', 'larvae moth', 'killer needle', 'kwagar hercules', 'larvae moth'], 'weevil'],
		
		[[null, "harpie's pet dragon", 'harpie girl', 'cyber harpie lady', null], 'mai'],
		
		[['amazoness chain master', "amazoness paladin", null, null, 'amazoness trainee'], 'mai'],
		
		[['kairyu-shin', 'fiend kraken', '7 colored fish', null, 'great white'], 'mako'],
		
		[['pendulum machine', 'slot machine', 'launcher spider', 'giga-tech wolf', null], 'banditkeith'],
		
		[['happy lover', 'dark magician girl', null, 'gemini elf', 'happy lover'], 'tea'],
		
		[['super robolady', null, 'lava battleguard', null, 'super roboyarou'], 'tristan'],
		
		[['necro mannequin', 'diabound kernel', 'man-eater bug', 'duke of demise', 'necro mannequin'], 'bakura'],
		
		[[null, 'battle ox', 'swordstalker', 'vorse raider', null], 'kaiba'],
		
		[['jirai gumo', null, 'labyrinth tank', null, 'dungeon worm'], 'paradox'],
		
		[['clown zombie', 'zanki', null, 'the snake hair', 'armored zombie'], 'bonz'],
		
		[['toon dark magician girl', null, 'bickuribox', 'parrot dragon', 'dark rabbit'], 'pegasus'],
		
		[['dark jeroid', 'embodiment of apophis', 'revival jam', 'makyura the destructor', null], 'marik'],
		
		[['dark assailant', 'oni tank t-34', 'strike ninja', 'gradius', null], 'dukedevlin'],
		
		[[null, 'mudora', 'agido', 'kelbek', "gravekeeper's priestess"], 'ishizu'],
		
		[['stuffed animal', 'shadow ghoul', 'giant soldier of stone', 'luster dragon', null], 'rebecca'],
	],
	
	[
		# Level 3
		[[null, 'summoned skull', 'dark magician', 'gaia the fierce knight', null], 'yamiyugi'],
		
		[[null, 'curse of dragon', 'dark sage', 'gaia the fierce knight', 'feral imp'], 'solomon'],
		
		[['time wizard', 'thousand dragon', 'red-eyes black dragon', 'flame swordsman', null], 'joey'],
		
		[[null, 'twin-headed thunder dragon', 'two-headed king rex', 'serpent night dragon', 'gilasaurus'], 'rex'],
		
		[['kwagar hercules', 'great moth', null, 'javelin beetle', 'larvae moth'], 'weevil'],
		
		[['cyber harpie lady', "harpie queen", null, "amazoness queen", 'amazoness paladin'], 'mai'],
		
		[['kairyu-shin', null, 'the legendary fisherman', 'man-eating black shark', 'fiend kraken'], 'mako'],
		
		[['launcher spider', null, 'metalzoa', 'zera the mant', 'pendulum machine'], 'banditkeith'],
		
		[[null, 'power angel valkyria', 'athena', 'dark magician girl', 'happy lover'], 'tea'],
		
		[['super roboyarou', null, 'xz-tank cannon', 'lava battleguard', 'super robolady'], 'tristan'],
		
		[['diabound kernel', 'dark necrofear', 'man-eater bug', 'dark ruler ha des', null], 'yamibakura'],
		
		[[null, 'blue-eyes white dragon', 'blue-eyes white dragon', 'blue-eyes white dragon', null], 'kaiba'],
		
		[[null, 'suijin', 'sanga of the thunder', 'kazejin', null], 'paradox'],
		
		[['clown zombie', 'great mammoth of goldfine', 'dragon zombie', 'zanki', null], 'bonz'],
		
		[[null, 'red-eyes toon dragon', 'toon summoned skull', 'blue-eyes toon dragon', null], 'pegasus'],
		
		[[null, 'makyura the destructor', 'lava golem', 'egyptian god slime', 'dark jeroid'], 'yamimarik'],
		
		[['dark assailant', 'oni tank t-34', 'orgoth the relentless', 'strike ninja', 'gradius',], 'dukedevlin'],
		
		[[null, "mystical knight of jackal", 'dark horus', 'mudora', "gravekeeper's priestess"], 'ishizu'],
		
		[['stuffed animal', 'millennium shield', 'blue-eyes white dragon', 'luster dragon', 'shadow ghoul'], 'rebecca'],
		
	],
	
	[
		# Level 4
		[['celtic guardian', 'summoned skull', 'dark magician of chaos', 'gaia the fierce knight', 'beaver warrior'], 'yamiyugi'],
		
		[['mystical elf', 'curse of dragon', 'black luster soldier', 'dark sage', 'giant soldier of stone'], 'solomon'],
		
		[['swamp battleguard', 'thousand dragon', 'red-eyes black metal dragon', 'flame swordsman', 'panther warrior'], 'joey'],
		
		[['two-headed king rex', 'twin-headed thunder dragon', 'migthy dino king rex', 'serpent night dragon', 'bracchio-raidus'], 'rex'],
		
		[['great moth', 'kwagar hercules', 'perfectly ultimate great moth', 'javelin beetle', 'cocoon of evolution'], 'weevil'],
		
		[['cyber harpie lady', "harpie queen", "harpie's pet dragon", "amazoness queen", 'amazoness paladin'], 'mai'],
		
		[['kairyu-shin', 'the legendary fisherman', 'fortress whale', 'man-eating black shark', 'orca mega-fortress of darkness'], 'mako'],
		
		[['launcher spider', 'metalzoa', 'barrel dragon', 'zera the mant', 'slot machine'], 'banditkeith'],
		
		[['mystical sand', 'power angel valkyria', 'st. joan', 'athena', 'dark magician girl'], 'tea'],
		
		[['super roboyarou', 'swamp battleguard', 'xyz-dragon cannon', 'lava battleguard', 'super robolady'], 'tristan'],
		
		[['diabound kernel', 'dark necrofear', 'dark master - zorc', 'dark ruler ha des', 'doomcaliber knight'], 'yamibakura'],
		
		[['swordstalker', 'rude kaiser', 'blue-eyes ultimate dragon', 'battle ox', 'hitotsu-me giant'], 'kaiba'],
		
		[['dungeon worm', 'jirai gumo', 'gate guardian', 'labyrinth tank', 'shadow ghoul'], 'paradox'],
		
		[['the snake hair', 'dragon zombie', 'pumpking the king of ghosts', 'great mammoth of goldfine', 'zanki'], 'bonz'],
		
		[['toon summoned skull', 'red-eyes toon dragon', 'relinquished', 'blue-eyes toon dragon', 'toon dark magician girl'], 'pegasus'],
		
		[['lava golem', 'makyura the destructor', 'mystical beast of serket', 'embodiment of apophis', 'egyptian god slime'], 'yamimarik'],
		
		[['orgoth the relentless', 'oni tank t-34', 'jinzo', 'strike ninja', 'gradius',], 'dukedevlin'],
		
		[['dark horus', "mystical knight of jackal", 'cosmo brain', 'mudora', "gravekeeper's priestess"], 'ishizu'],
		
		[['shadow ghoul', 'blue-eyes white dragon', 'ancient dragon', 'millennium shield', 'giant soldier of stone'], 'rebecca'],
	]
]

var pkmn_bosses = [
	[
		[[null, 'geodude', 'vulpix', 'sandshrew', null], 'brock'],
		
		[[null, 'psyduck', 'staryu', null, 'togepi'], 'misty'],
		
		[['voltorb', null, 'electabuzz', null, null], 'surge'],
		
		[[null, 'oddish', 'bulbasaur', 'oddish', null], 'erika'],
		
		[[null, 'koffing', null, 'venomoth', null], 'koga'],
		
		[[null, 'kadabra', 'abra', null, null], 'sabrina'],
		
		[[null, 'ponyta', 'magmar', null, null], 'blaine'],
		
		[[null, 'nidorino', null, 'cubone', null], 'giovanni'],
		
		[[null, 'seel', 'cloyster', null, null], 'lorelei'],
		
		[[null, 'machop', null, 'hitmonchan', null], 'bruno'],
		
		[[null, 'gastly', 'misdreavus', 'gastly', null], 'agatha'],
		
		[[null, 'dratini', 'charmander', 'dratini', null], 'lance'],
	],
	
	[
		[[null, 'geodude', 'onix', 'rhyhorn', 'vulpix'], 'brock'],
		
		[[null, 'psyduck', 'starmie', 'seaking', null], 'misty'],
		
		[['voltorb', 'electabuzz', null, 'raichu', null], 'surge'],
		
		[[null, 'ivysaur', 'bellossom', 'oddish', null], 'erika'],
		
		[['koffing', 'koffing', 'venomoth', 'koffing', 'koffing'], 'koga'],
		
		[[null, 'abra', 'kadabra', 'alakazam', null], 'sabrina'],
		
		[[null, 'magmar', 'rapidash', 'growlithe', 'vulpix'], 'blaine'],
		
		[[null, 'nidorino', 'persian', 'cubone', 'murkrow'], 'giovanni'],
		
		[[null, 'dewgong', 'cloyster', 'slowbro', null], 'lorelei'],
		
		[[null, 'hitmonlee', 'hitmontop', 'hitmonchan', null], 'bruno'],
		
		[[null, 'haunter', 'marowak', 'arbok', null], 'agatha'],
		
		[[null, 'dratini', 'dragonair', 'seadra', 'charmander'], 'lance'],
	],
	
	[
		[['geodude', 'onix', 'ninetales', 'rhyhorn', 'geodude'], 'brock'],
		
		[[null, 'lapras', 'starmie', 'seaking', 'staryu'], 'misty'],
		
		[[null, 'electabuzz', 'raichu', 'jolteon', 'voltorb'], 'surge'],
		
		[['ivysaur', 'vileplume', 'oddish', 'bellossom', null], 'erika'],
		
		[[null, 'muk', 'venomoth', 'tentacruel', 'koffing'], 'koga'],
		
		[['hitmonlee', 'espeon', 'alakazam', 'kadabra', null], 'sabrina'],
		
		[[null, 'arcanine', 'rapidash', 'ninetales', 'magmar'], 'blaine'],
		
		[[null, 'nidorino', 'nidoqueen', 'rhydon', 'persian'], 'giovanni'],
		
		[['cloyster', 'dewgong', 'lapras', 'slowbro', null], 'lorelei'],
		
		[['machamp', 'hitmonlee', 'hitmontop', 'hitmonchan', null], 'bruno'],
		
		[['marowak', 'haunter', 'gengar', 'arbok', null], 'agatha'],
		
		[[null, 'dratini', 'dragonite', 'dragonair', null], 'lance'],
	],
	
	[
		[['starmie', 'lapras', 'gyarados', 'seaking', 'staryu'], 'misty'],
		
		[['hitmonlee', 'espeon', 'alakazam', 'scizor', 'slowking'], 'sabrina'],
		
		[[null, 'nidoqueen', 'mewtwo', 'nidoking', 'persian'], 'giovanni'],
		
		[['gyarados', 'charizard', 'dragonite', null, 'aerodactyl'], 'lance'],
		
		[['snorlax', 'lapras', 'the pikachu', 'charizard', 'espeon'], 'red'],
		
		[['alakazam', 'nidoqueen', 'umbreon', 'blastoise', 'pidgeot'], 'blue'],
		
		[['vaporeon', 'ninetales', 'clefable', 'venusaur', 'machamp'], 'green'],
		
		[['tauros', 'venusaur', 'charizard', 'blastoise', 'exeggutor'], 'oak'],
	]
]














