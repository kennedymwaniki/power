def modify_content(content):
   
    return content.upper()

def read_and_write_file():
   
    filename = input("Enter the filename to read: ")

    try:
        # Try to open and read the file
        with open(filename, "r") as file:
            content = file.read()

        # Modify content
        modified_content = modify_content(content)

        # Define the new filename
        new_filename = "modified_" + filename


        with open(new_filename, "w") as file:
            file.write(modified_content)

        print(f" Modified content saved to '{new_filename}'")

    except FileNotFoundError:
        print(" Error: The file does not exist.")
    except PermissionError:
        print("Error: You don't have permission to read this file.")
    except Exception as e:
        print(f" An unexpected error occurred: {e}")

read_and_write_file()
