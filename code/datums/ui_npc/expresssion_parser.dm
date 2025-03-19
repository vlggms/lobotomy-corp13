// Enhanced Expression Parser with variable scope resolution
/datum/scoped_expression_parser
	var/list/tokens = list()
	var/token_pos = 1
	var/datum/var_resolver_manager/var_manager
	var/last_error = null

/datum/scoped_expression_parser/New(datum/var_resolver_manager/manager = null)
	if(manager)
		var_manager = manager
	else
		var_manager = new /datum/var_resolver_manager()

// Error handling
/datum/scoped_expression_parser/proc/set_error(message)
	last_error = message
	return null

// Main entry point - evaluate a boolean expression
/datum/scoped_expression_parser/proc/eval_scoped_expression(expression)
	if(!expression)
		return set_error("Empty expression")

	last_error = null

	// Tokenize and parse
	tokens = tokenize(expression)
	token_pos = 1

	if(!length(tokens))
		return set_error("Empty expression after tokenizing")

	var/result = parse_expression()

	// Check if we consumed all tokens
	if(token_pos <= length(tokens))
		return set_error("Unexpected token at end: [tokens[token_pos]]")

	return result

// Tokenize the input string into a list of tokens
/datum/scoped_expression_parser/proc/tokenize(expression)
	var/list/result = list()
	var/i = 1
	var/length = length(expression)

	while(i <= length)
		var/char = copytext(expression, i, i+1)

		// Skip whitespace
		if(char == " " || char == "\t" || char == "\n")
			i++
			continue

		// Check for operators
		if(char == "(" || char == ")")
			result += char
			i++
			continue

		// Check for comparison operators
		if(char == "=" || char == "<" || char == ">" || char == "!")
			var/op = char

			// Check for two-character operators (<=, >=, !=)
			if(i < length)
				var/next_char = copytext(expression, i+1, i+2)
				if(next_char == "=")
					op += "="
					i++

			result += op
			i++
			continue

		// Check for AND/OR (case-insensitive)
		if(i+2 <= length && lowertext(copytext(expression, i, i+3)) == "and")
			result += "AND"
			i += 3
			continue

		if(i+1 <= length && lowertext(copytext(expression, i, i+2)) == "or")
			result += "OR"
			i += 2
			continue

		// Check for NOT (case-insensitive)
		if(i+2 <= length && lowertext(copytext(expression, i, i+3)) == "not")
			result += "NOT"
			i += 3
			continue

		// Handle string literals in quotes
		if(char == "\"" || char == "'")
			var/quote_char = char
			var/string_literal = quote_char  // Include the quote character
			i++  // Move past the opening quote

			// Collect all characters until the closing quote
			var/escaped = FALSE
			while(i <= length)
				char = copytext(expression, i, i+1)

				// Handle escaped quotes with backslash
				if(char == "\\" && i+1 <= length)
					var/next_char = copytext(expression, i+1, i+2)
					if(next_char == quote_char)
						string_literal += next_char  // Add the quote character (not the backslash)
						i += 2  // Skip both backslash and quote
						continue

				// Check for closing quote
				if(char == quote_char && !escaped)
					string_literal += char  // Include the closing quote
					i++
					break

				// Add character to the string literal
				string_literal += char
				i++

			// Add the complete string literal as a token
			result += string_literal
			continue

		// Check for numbers
		if(text2num(char) != null || char == ".")
			var/number = ""
			while(i <= length && (text2num(copytext(expression, i, i+1)) != null || copytext(expression, i, i+1) == "."))
				number += copytext(expression, i, i+1)
				i++
			result += number
			continue

		// Check for TRUE/FALSE literals
		if(i+3 <= length && lowertext(copytext(expression, i, i+4)) == "true")
			result += "TRUE"
			i += 4
			continue

		if(i+4 <= length && lowertext(copytext(expression, i, i+5)) == "false")
			result += "FALSE"
			i += 5
			continue

		// Must be a variable name (which may include dots)
		var/varname = ""
		while(i <= length && is_valid_var_char(copytext(expression, i, i+1)))
			varname += copytext(expression, i, i+1)
			i++

		if(varname != "")
			result += varname
		else
			// Invalid character
			return set_error("Invalid character in expression: [char]")

	return result

// Check if a character is valid for variable names
/datum/scoped_expression_parser/proc/is_valid_var_char(char)
	var/ascii = text2ascii(char)
	// Allow letters, numbers, underscore, and dot
	return (ascii >= 65 && ascii <= 90) || (ascii >= 97 && ascii <= 122) || (ascii >= 48 && ascii <= 57) || ascii == 95 || ascii == 46

// Get current token safely
/datum/scoped_expression_parser/proc/current_token()
	if(token_pos > length(tokens))
		return null
	return tokens[token_pos]

// Parse expressions using recursive descent
/datum/scoped_expression_parser/proc/parse_expression()
	return parse_or_expression()

// Parse OR expressions
/datum/scoped_expression_parser/proc/parse_or_expression()
	var/left = parse_and_expression()
	if(isnull(left) && !isnull(last_error))
		return null

	while(token_pos <= length(tokens) && current_token() == "OR")
		token_pos++
		var/right = parse_and_expression()
		if(isnull(right) && !isnull(last_error))
			return null

		// Convert to boolean values for OR operation
		left = !!left || !!right

	return left

// Parse AND expressions
/datum/scoped_expression_parser/proc/parse_and_expression()
	var/left = parse_not_expression()
	if(isnull(left) && !isnull(last_error))
		return null

	while(token_pos <= length(tokens) && current_token() == "AND")
		token_pos++
		var/right = parse_not_expression()
		if(isnull(right) && !isnull(last_error))
			return null

		// Convert to boolean values for AND operation
		left = !!left && !!right

	return left

// Parse NOT expressions
/datum/scoped_expression_parser/proc/parse_not_expression()
	if(token_pos <= length(tokens) && current_token() == "NOT")
		token_pos++
		var/operand = parse_comparison()
		if(isnull(operand) && !isnull(last_error))
			return null

		return !operand

	return parse_comparison()

// Parse comparisons (=, <, >, <=, >=, !=)
/datum/scoped_expression_parser/proc/parse_comparison()
	var/left = parse_term()
	if(isnull(left) && !isnull(last_error))
		return null

	if(token_pos <= length(tokens))
		var/operator = current_token()

		if(operator == "=" || operator == "<" || operator == ">" || operator == "<=" || operator == ">=" || operator == "!=")
			token_pos++
			var/right = parse_term()
			if(isnull(right) && !isnull(last_error))
				return null

			// Handle different types appropriately
			if(istext(left) && istext(right))
				// String comparison
				switch(operator)
					if("=")
						return left == right
					if("!=")
						return left != right
					else
						return set_error("Invalid operator for strings: [operator]")
			else
				// Convert to numbers if possible for numeric comparison
				var/num_left
				var/num_right

				if(isnum(left))
					num_left = left
				else if(istext(left))
					num_left = text2num(left)
					if(isnull(num_left)) num_left = 0
				else
					num_left = 0

				if(isnum(right))
					num_right = right
				else if(istext(right))
					num_right = text2num(right)
					if(isnull(num_right)) num_right = 0
				else
					num_right = 0

				switch(operator)
					if("=")
						return num_left == num_right
					if("<")
						return num_left < num_right
					if(">")
						return num_left > num_right
					if("<=")
						return num_left <= num_right
					if(">=")
						return num_left >= num_right
					if("!=")
						return num_left != num_right

	return left

// Parse terms (variables, numbers, parenthesized expressions)
/datum/scoped_expression_parser/proc/parse_term()
	if(token_pos > length(tokens))
		return set_error("Unexpected end of expression")

	var/token = current_token()
	token_pos++

	// Handle parentheses
	if(token == "(")
		var/result = parse_expression()
		if(isnull(result) && !isnull(last_error))
			return null

		if(token_pos <= length(tokens) && current_token() == ")")
			token_pos++
			return result
		else
			return set_error("Missing closing parenthesis")

	// Handle literal TRUE/FALSE
	if(token == "TRUE")
		return TRUE

	if(token == "FALSE")
		return FALSE

	// Handle string literals
	if(length(token) >= 2)
		var/first_char = copytext(token, 1, 2)
		var/last_char = copytext(token, -1)

		if((first_char == "\"" && last_char == "\"") || (first_char == "'" && last_char == "'"))
			// Return the string without quotes
			return copytext(token, 2, -1)

	// Handle numbers
	var/num = text2num(token)
	if(!isnull(num))
		return num

	// Must be a variable - resolve using the variable manager
	return resolve_variable(token)

// Resolve a variable using the variable manager
/datum/scoped_expression_parser/proc/resolve_variable(var_path)
	if(!var_manager)
		return 0

	// Check if the var manager has this variable
	if(var_manager.has_var(var_path))
		return var_manager.get_var(var_path)

	// Return default value for undefined variables
	return var_manager.get_default_value(var_path)

// Register a new variable resolver
/datum/scoped_expression_parser/proc/register_resolver(scope_name, datum/var_resolver/resolver)
	if(!var_manager)
		var_manager = new /datum/var_resolver_manager()

	return var_manager.register_resolver(scope_name, resolver)

// Convenience function for one-off expression evaluation
/proc/eval_scoped_expression(expression, list/resolvers = list())
	var/datum/var_resolver_manager/manager = new()

	// Set up resolvers
	for(var/scope_name in resolvers)
		manager.register_resolver(scope_name, resolvers[scope_name])

	var/datum/scoped_expression_parser/parser = new(manager)
	var/result = parser.eval_scoped_expression(expression)

	if(!isnull(parser.last_error))
		return "ERROR: [parser.last_error]"

	return result
