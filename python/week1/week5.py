class Book:
    def __init__(self, title, author, pages):
        self.title = title
        self.author = author
        self.pages = pages
        self.current_page = 1
    
    def read(self, num_pages):
        self.current_page += num_pages
        print(f"Now on page {self.current_page}")
    
    def get_info(self):
        return f"{self.title} by {self.author}, {self.pages} pages"

#
class Ebook(Book):
    def __init__(self, title, author, pages, format):
        super().__init__(title, author, pages)
        self.format = format
    
    def get_info(self):
        return f"{self.title} by {self.author}, {self.pages} pages, {self.format} format"


my_book = Book("Chozi la heri", "Asumpta", 320)
print(my_book.get_info())
my_book.read(10)

my_ebook = Ebook("The inheritance", "Matei", 295, "PDF")
print(my_ebook.get_info())


// ACTIVIT2
class Animal:
    def __init__(self, name):
        self.name = name
    
    def move(self):
        print("Moving...")

class Dog(Animal):
    def move(self):
        print(f"{self.name} is running on four legs")
        
class Bird(Animal):
    def move(self):
        print(f"{self.name} is flying through the air")
        
class Fish(Animal):
    def move(self):
        print(f"{self.name} is swimming in the water ")

# Demonstrate polymorphism
animals = [
    Dog("Max"),
    Bird("Tweety"),
    Fish("Nemo")
]

for animal in animals:
    animal.move()
