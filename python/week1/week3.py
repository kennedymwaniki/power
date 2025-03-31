def calculate_discount(price, discount_percent):

    if discount_percent >= 20:
        return price - (price * (discount_percent / 100))
    return price


original_price = int(input("enter the item price "))
discount_percent = int(input("enter the discount percentage: "))


final_price = calculate_discount(original_price, discount_percent)


print(f"Final price after discount: ${final_price}")
