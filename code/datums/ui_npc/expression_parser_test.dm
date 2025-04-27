// TEST ENTRY POINT FOR EXPRESSION PARSER
// Add this file to your existing codebase

// A simple entry point to run when using the -run parameter
/proc/RunExpressionTest()
	log_world("RUNNING EXPRESSION PARSER TEST")
	log_world("==============================")

	var/datum/expression_test/test_runner = new /datum/expression_test
	test_runner.RunAllTests()

	return 1

// Test runner datum
/datum/expression_test
	var/datum/var_resolver_manager/manager
	var/datum/scoped_expression_parser/parser
	var/tests_passed = 0
	var/tests_failed = 0

/datum/expression_test/New()
	SetupTestEnvironment()

/datum/expression_test/proc/SetupTestEnvironment()
	log_world("Setting up test environment...")

	// Create the variable manager and parsers
	manager = new()

	// Add test variables - adjust if needed to match your implementation
	var/datum/var_resolver/dictionary/player_vars = new(list(
		"health" = 75,
		"max_health" = 100,
		"name" = "TestPlayer",
		"class" = "warrior",
		"inventory" = list(
			"sword" = TRUE,
			"shield" = TRUE,
			"potion" = 3
		)
	))
	manager.register_resolver("player", player_vars)

	var/datum/var_resolver/dictionary/world_vars = new(list(
		"time" = list(
			"hour" = 14,
			"is_night" = FALSE
		),
		"quest" = list(
			"main_quest_complete" = FALSE,
			"side_quest_active" = TRUE
		),
		"location" = "town"
	))
	manager.register_resolver("world", world_vars)

	var/datum/var_resolver/dictionary/dialog_vars = new(list(
		"visit_count" = 2,
		"detailed_description_shown" = TRUE,
		"topics" = list(
			"quest" = TRUE,
			"town" = FALSE,
			"weather" = TRUE
		)
	))
	manager.register_resolver("dialog", dialog_vars)

	// Create parser
	parser = new(manager)

	log_world("Test environment ready!")

/datum/expression_test/proc/RunAllTests()
	RunBasicTests()
	RunComplexTests()
	RunErrorTests()

	// Print summary
	log_world("\nTEST SUMMARY:")
	log_world("Tests passed: [tests_passed]")
	log_world("Tests failed: [tests_failed]")
	log_world("Total tests: [tests_passed + tests_failed]")

	if(tests_failed == 0)
		log_world("ALL TESTS PASSED!")
	else
		log_world("[tests_failed] TESTS FAILED!")

	// Test a single expression
/datum/expression_test/proc/TestExpression(expression, expected)
	var/result = parser.eval_scoped_expression(expression)

	// Check for errors
	if(!isnull(parser.last_error))
		// If we expect an error (expected == null), that's fine
		if(isnull(expected))
			log_world("PASS: [expression] => ERROR: [parser.last_error] (expected error)")
			tests_passed++
			return TRUE
		else
			log_world("FAIL: [expression] => ERROR: [parser.last_error] (expected [expected])")
			tests_failed++
			return FALSE

	// If we expected an error but didn't get one
	if(isnull(expected) && isnull(parser.last_error))
		log_world("FAIL: [expression] => [result] (expected an error)")
		tests_failed++
		return FALSE

	// Check result
	if(result == expected)
		log_world("PASS: [expression] => [result]")
		tests_passed++
		return TRUE
	else
		log_world("FAIL: [expression] => [result] (expected [expected])")
		tests_failed++
		return FALSE

	// Run basic test expressions
/datum/expression_test/proc/RunBasicTests()
	log_world("\nRUNNING BASIC TESTS:")

	// Simple comparisons
	TestExpression("player.health = 75", TRUE)
	TestExpression("player.health < player.max_health", TRUE)
	TestExpression("player.name = \"TestPlayer\"", TRUE)
	TestExpression("player.health > 100", FALSE)

	// Logical operators
	TestExpression("player.health > 50 AND player.class = \"warrior\"", TRUE)
	TestExpression("player.health < 50 OR player.inventory.sword", TRUE)
	TestExpression("NOT player.inventory.shield", FALSE)
	TestExpression("player.inventory.sword AND NOT player.inventory.axe", TRUE)

	// Nested properties
	TestExpression("player.inventory.potion = 3", TRUE)
	TestExpression("world.time.is_night", FALSE)
	TestExpression("world.quest.main_quest_complete", FALSE)
	TestExpression("dialog.topics.quest", TRUE)

// Run more complex test expressions
/datum/expression_test/proc/RunComplexTests()
	log_world("\nRUNNING COMPLEX TESTS:")

	// Complex conditions
	TestExpression("player.health < player.max_health AND player.inventory.potion > 0", TRUE)
	TestExpression("(player.class = \"warrior\" OR player.class = \"paladin\") AND player.inventory.shield", TRUE)
	TestExpression("world.quest.main_quest_complete OR (world.quest.side_quest_active AND player.inventory.sword)", TRUE)
	TestExpression("dialog.visit_count > 1 AND dialog.topics.quest AND NOT dialog.topics.town", TRUE)
	TestExpression("(player.health > 50 AND player.inventory.potion > 0) OR (player.health <= 50 AND player.inventory.potion = 0)", TRUE)
	TestExpression("NOT (player.health < 50 OR world.time.is_night) AND dialog.detailed_description_shown", TRUE)

	// Test error handling
/datum/expression_test/proc/RunErrorTests()
	log_world("\nRUNNING ERROR TESTS:")

	// Syntax errors
	TestExpression("player.health >< 100", null)  // Invalid operator
	TestExpression("player.health AND OR player.inventory.sword", null)  // Invalid expression

	// Missing variables (should not error, just return false)
	TestExpression("player.nonexistent = 10", FALSE)
	TestExpression("missing.variable = TRUE", FALSE)

	// Complex errors
	TestExpression("(player.health > 50 AND", null)  // Incomplete expression
	TestExpression("player.inventory.potion = \"three\"", FALSE)  // Type mismatch
