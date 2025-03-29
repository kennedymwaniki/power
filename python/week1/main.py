def calculate(num1, num2, operation):
    """Perform the calculation based on the given operation."""
    if operation == '+':
        return num1 + num2
    elif operation == '-':
        return num1 - num2
    elif operation == '*':
        return num1 * num2
    elif operation == '/':
        # Handle division by zero
        if num2 == 0:
            return "Error: Division by zero"
        return num1 / num2
    else:
        return "Error: Invalid operation"


print(calculate(10, 5, '+'))
print(calculate(10, 5, '-'))
print(calculate(9, 5, '*'))
