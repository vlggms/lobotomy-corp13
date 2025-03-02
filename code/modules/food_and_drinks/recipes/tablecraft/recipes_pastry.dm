
// see code/module/crafting/table.dm
////////////////////////////////////////////////CAKE////////////////////////////////////////////////

/datum/crafting_recipe/food/poundcake
	name = "Pound cake"
	reqs = list(
		/obj/item/food/cake/plain = 4
	)
	result = /obj/item/food/cake/pound_cake
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/vanillacake
	name = "vanilla cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/vanillapod = 2
	)
	result = /obj/item/food/cake/vanilla_cake
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/braincake
	name = "Brain cake"
	reqs = list(
		/obj/item/organ/brain = 1,
		/obj/item/food/cake/plain = 1
	)
	result = /obj/item/food/cake/brain
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/bscccake
	name = "blackberry and strawberry chocolate cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/bscc
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/bscvcake
	name = "blackberry and strawberry vanilla cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/berries = 5
	)
	result = /obj/item/food/cake/bsvc
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/clowncake
	name = "clown cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/sundae = 2,
		/obj/item/food/grown/banana = 5
	)
	result = /obj/item/food/cake/clown_cake
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/carrotcake
	name = "Carrot cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/carrot = 2
	)
	result = /obj/item/food/cake/carrot
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/cheesecake
	name = "Cheese cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/cheesewedge = 2
	)
	result = /obj/item/food/cake/cheese
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/applecake
	name = "Apple cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/apple = 2
	)
	result = /obj/item/food/cake/apple
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/orangecake
	name = "Orange cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/orange = 2
	)
	result = /obj/item/food/cake/orange
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/limecake
	name = "Lime cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lime = 2
	)
	result = /obj/item/food/cake/lime
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/lemoncake
	name = "Lemon cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/citrus/lemon = 2
	)
	result = /obj/item/food/cake/lemon
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/chocolatecake
	name = "Chocolate cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/chocolate
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/birthdaycake
	name = "Birthday cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/candle = 1,
		/datum/reagent/consumable/sugar = 5,
		/datum/reagent/consumable/caramel = 2
	)
	result = /obj/item/food/cake/birthday
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/pumpkinspicecake
	name = "Pumpkin spice cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/pumpkin = 2
	)
	result = /obj/item/food/cake/pumpkinspice
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/charlotte
	name = "Strawberry charlotte"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/berries = 5,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cake/charlotte
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/fraisier
	name = "Fraisier"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/obj/item/food/grown/berries = 5,
		/datum/reagent/consumable/cream = 5
	)
	result = /obj/item/food/cake/fraisier
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/saint_honore
	name = "Saint Honore"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/cream = 5,
		/datum/reagent/consumable/caramel = 1,
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cake/saint_honore
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/black_forest
	name = "Black Forest"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/cherries = 2,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/cake/black_forest
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/triple_berry
	name = "Triple layer berry cake"
	reqs = list(
		/obj/item/food/cake/plain = 1,
		/datum/reagent/consumable/cream = 5,
		/obj/item/food/grown/berries = 15
	)
	result = /obj/item/food/cake/triple_berry
	subcategory = CAT_PASTRY


////////////////////////////////////////////////PIES////////////////////////////////////////////////

/datum/crafting_recipe/food/cherrypie
	name = "Cherry pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/pie/cherrypie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/plumppie
	name = "Plump pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/pie/plump_pie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/applepie
	name = "Apple pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 1
	)
	result = /obj/item/food/pie/applepie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/meatpie
	name = "Meat pie"
	reqs = list(
		/datum/reagent/consumable/blackpepper = 1,
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/meat/steak/plain = 1
	)
	result = /obj/item/food/pie/meatpie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/tofupie
	name = "Tofu pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/tofu = 1
	)
	result = /obj/item/food/pie/tofupie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/amanitapie
	name = "Amanita pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/mushroom/amanita = 1
	)
	result = /obj/item/food/pie/amanita_pie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/pumpkinpie
	name = "Pumpkin pie"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/pumpkin = 1
	)
	result = /obj/item/food/pie/pumpkinpie
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/bananacreampie
	name = "Banana cream pie"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/banana = 1
	)
	result = /obj/item/food/pie/cream
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/berryclafoutis
	name = "Berry clafoutis"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/pie/berryclafoutis
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/grapetart
	name = "Grape tart"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/grapes = 3
	)
	result = /obj/item/food/pie/grapetart
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/berrytart
	name = "Berry tart"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/berries = 3
	)
	result = /obj/item/food/pie/berrytart
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/dulcedebatata
	name = "Dulce de batata"
	reqs = list(
		/datum/reagent/consumable/vanilla = 5,
		/datum/reagent/water = 5,
		/obj/item/food/grown/potato/sweet = 2
	)
	result = /obj/item/food/pie/dulcedebatata
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/baklava
	name = "Baklava pie"
	reqs = list(
		/obj/item/food/butter = 2,
		/obj/item/food/tortilla = 4,	//Layers
		/obj/item/seeds/wheat/oat = 4
	)
	result = /obj/item/food/pie/baklava
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/tarte_tatin
	name = "Tarte tatin"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/grown/apple = 2,
		/datum/reagent/consumable/caramel = 5,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/pie/tarte_tatin
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/chocolate_pie
	name = "Chocolate pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/obj/item/food/chocolatebar = 2
	)
	result = /obj/item/food/pie/chocolate
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/flan
	name = "Flan"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/datum/reagent/consumable/eggyolk = 5,
		/datum/reagent/consumable/milk = 5,
		/datum/reagent/consumable/vanilla = 5
	)
	result = /obj/item/food/pie/flan
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/lemon_meringue_pie
	name = "Lemon meringue pie"
	reqs = list(
		/obj/item/food/pie/plain = 1,
		/datum/reagent/consumable/eggyolk = 5,
		/obj/item/food/grown/citrus/lemon = 2,
		/datum/reagent/consumable/sugar = 5
	)
	result = /obj/item/food/pie/lemon_meringue
	subcategory = CAT_PASTRY


////////////////////////////////////////////////DONUTS////////////////////////////////////////////////

/datum/crafting_recipe/food/donut
	time = 15
	name = "Donut"
	reqs = list(
		/datum/reagent/consumable/sugar = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/plain
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/donut/meat
	time = 15
	name = "Meat donut"
	reqs = list(
		/obj/item/food/meat/rawcutlet = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/meat

/datum/crafting_recipe/food/donut/berry
	name = "Berry Donut"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/berry

/datum/crafting_recipe/food/donut/apple
	name = "Apple Donut"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/apple

/datum/crafting_recipe/food/donut/caramel
	name = "Caramel Donut"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/caramel

/datum/crafting_recipe/food/donut/choco
	name = "Chocolate Donut"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/choco

/datum/crafting_recipe/food/donut/matcha
	name = "Matcha Donut"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/matcha

/datum/crafting_recipe/food/donut/blumpkin
	name = "Blumpkin Donut"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/blumpkin

/datum/crafting_recipe/food/donut/bungo
	name = "Bungo Donut"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/bungo

/datum/crafting_recipe/food/donut/laugh
	name = "Sweet Pea Donut"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/plain = 1
	)
	result = /obj/item/food/donut/laugh

////////////////////////////////////////////////////JELLY DONUTS///////////////////////////////////////////////////////

/datum/crafting_recipe/food/donut/jelly
	name = "Jelly donut"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/donut/jelly/plain


/datum/crafting_recipe/food/donut/jelly/berry
	name = "Berry Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/berryjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/berry

/datum/crafting_recipe/food/donut/jelly/apple
	name = "Apple Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/applejuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/apple

/datum/crafting_recipe/food/donut/jelly/caramel
	name = "Caramel Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/caramel = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/caramel

/datum/crafting_recipe/food/donut/jelly/choco
	name = "Chocolate Jelly Donut"
	reqs = list(
		/obj/item/food/chocolatebar = 1,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/choco

/datum/crafting_recipe/food/donut/jelly/blumpkin
	name = "Blumpkin Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/blumpkinjuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/blumpkin

/datum/crafting_recipe/food/donut/jelly/bungo
	name = "Bungo Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/bungojuice = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/bungo

/datum/crafting_recipe/food/donut/jelly/matcha
	name = "Matcha Jelly Donut"
	reqs = list(
		/datum/reagent/toxin/teapowder = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/matcha

/datum/crafting_recipe/food/donut/jelly/laugh
	name = "Sweet Pea Jelly Donut"
	reqs = list(
		/datum/reagent/consumable/laughsyrup = 3,
		/obj/item/food/donut/jelly/plain = 1
	)
	result = /obj/item/food/donut/jelly/laugh

////////////////////////////////////////////////WAFFLES////////////////////////////////////////////////

/datum/crafting_recipe/food/waffles
	time = 15
	name = "Waffles"
	reqs = list(
		/obj/item/food/pastrybase = 2
	)
	result = /obj/item/food/waffles
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/soylenviridians
	name = "Soylent viridians"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/grown/soybeans = 1
	)
	result = /obj/item/food/soylenviridians
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/soylentgreen
	name = "Soylent green"
	reqs = list(
		/obj/item/food/pastrybase = 2,
		/obj/item/food/meat/slab/human = 2
	)
	result = /obj/item/food/soylentgreen
	subcategory = CAT_PASTRY

////////////////////////////////////////////////DONKPOCCKETS////////////////////////////////////////////////

/datum/crafting_recipe/food/donkpocket
	time = 15
	name = "Donk-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1
	)
	result = /obj/item/food/donkpocket
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/dankpocket
	time = 15
	name = "Dank-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/cannabis = 1
	)
	result = /obj/item/food/dankpocket
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/donkpocket/spicy
	time = 15
	name = "Spicy-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/chili
	)
	result = /obj/item/food/donkpocket/spicy
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/donkpocket/teriyaki
	time = 15
	name = "Teriyaki-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/datum/reagent/consumable/soysauce = 3
	)
	result = /obj/item/food/donkpocket/teriyaki
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/donkpocket/pizza
	time = 15
	name = "Pizza-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/tomato = 1
	)
	result = /obj/item/food/donkpocket/pizza
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/donkpocket/honk
	time = 15
	name = "Honk-Pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/banana = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/donkpocket/honk
	subcategory = CAT_PASTRY


/datum/crafting_recipe/food/donkpocket/berry
	time = 15
	name = "Berry-pocket"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/donkpocket/berry
	subcategory = CAT_PASTRY


////////////////////////////////////////////////MUFFINS////////////////////////////////////////////////

/datum/crafting_recipe/food/muffin
	time = 15
	name = "Muffin"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/muffin
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/berrymuffin
	name = "Berry muffin"
	reqs = list(
		/datum/reagent/consumable/milk = 5,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/berries = 1
	)
	result = /obj/item/food/muffin/berry
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/chawanmushi
	name = "Chawanmushi"
	reqs = list(
		/datum/reagent/water = 5,
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/boiledegg = 2,
		/obj/item/food/grown/mushroom/chanterelle = 1
	)
	result = /obj/item/food/chawanmushi
	subcategory = CAT_PASTRY

////////////////////////////////////////////OTHER////////////////////////////////////////////

/datum/crafting_recipe/food/hotdog
	name = "Hot dog"
	reqs = list(
		/datum/reagent/consumable/ketchup = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/sausage = 1
	)
	result = /obj/item/food/hotdog
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/meatbun
	name = "Meat bun"
	reqs = list(
		/datum/reagent/consumable/soysauce = 5,
		/obj/item/food/bun = 1,
		/obj/item/food/meatball = 1,
		/obj/item/food/grown/cabbage = 1
	)
	result = /obj/item/food/meatbun
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/khachapuri
	name = "Khachapuri"
	reqs = list(
		/datum/reagent/consumable/eggyolk = 5,
		/obj/item/food/cheesewedge = 1,
		/obj/item/food/bread/plain = 1
	)
	result = /obj/item/food/khachapuri
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/sugarcookie
	time = 15
	name = "Sugar cookie"
	reqs = list(
		/datum/reagent/consumable/sugar = 5,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/cookie/sugar
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/fortunecookie
	time = 15
	name = "Fortune cookie"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/paper = 1
	)
	parts =	list(
		/obj/item/paper = 1
	)
	result = /obj/item/food/fortunecookie
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/poppypretzel
	time = 15
	name = "Poppy pretzel"
	reqs = list(
		/obj/item/seeds/poppy = 1,
		/obj/item/food/pastrybase = 1
	)
	result = /obj/item/food/poppypretzel
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/plumphelmetbiscuit
	time = 15
	name = "Plumphelmet biscuit"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/mushroom/plumphelmet = 1
	)
	result = /obj/item/food/plumphelmetbiscuit
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/cracker
	time = 15
	name = "Cracker"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pastrybase = 1,
	)
	result = /obj/item/food/cracker
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/chococornet
	name = "Choco cornet"
	reqs = list(
		/datum/reagent/consumable/salt = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/chococornet
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/oatmealcookie
	name = "Oatmeal cookie"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/oatmeal
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/raisincookie
	name = "Raisin cookie"
	reqs = list(
		/obj/item/food/no_raisin = 1,
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/oat = 1
	)
	result = /obj/item/food/cookie/raisin
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/cherrycupcake
	name = "Cherry cupcake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/cherries = 1
	)
	result = /obj/item/food/cherrycupcake
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/bluecherrycupcake
	name = "Blue cherry cupcake"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/grown/bluecherries = 1
	)
	result = /obj/item/food/cherrycupcake/blue
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/honeybun
	name = "Honey bun"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/honey = 5
	)
	result = /obj/item/food/honeybun
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/cannoli
	name = "Cannoli"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/datum/reagent/consumable/milk = 1,
		/datum/reagent/consumable/sugar = 3
	)
	result = /obj/item/food/cannoli
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/croissant
	name = "Croissant"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/butter = 1
	)
	result = /obj/item/food/croissant
	subcategory = CAT_PASTRY

/datum/crafting_recipe/food/pain_au_chocolat
	name = "Pain au chocolat"
	reqs = list(
		/obj/item/food/pastrybase = 1,
		/obj/item/food/butter = 1,
		/obj/item/food/chocolatebar = 1
	)
	result = /obj/item/food/pain_au_chocolat
	subcategory = CAT_PASTRY
