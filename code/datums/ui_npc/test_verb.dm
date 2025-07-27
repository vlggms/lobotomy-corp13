// Testing verb that can be run in-game
/client/verb/run_parser_tests()
	set name = "Run Parser Tests"
	set category = "Debug"

	src << "<b>Running expression parser tests...</b>"

	var/datum/expression_test/tester = new()
	tester.RunAllTests()

	// Display results to client
	src << "<b>TEST SUMMARY:</b>"
	src << "Tests passed: [tester.tests_passed]"
	src << "Tests failed: [tester.tests_failed]"
	src << "Total tests: [tester.tests_passed + tester.tests_failed]"

	if(tester.tests_failed == 0)
		src << "<font color='green'><b>ALL TESTS PASSED!</b></font>"
	else
		src << "<font color='red'><b>[tester.tests_failed] TESTS FAILED!</b></font>"
