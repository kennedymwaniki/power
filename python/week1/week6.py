import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import requests


numbers = np.array(range(1, 11))
mean_value = np.mean(numbers)
print(f"NumPy array: {numbers}")
print(f"Mean value: {mean_value}")


data = {
    'Name': ['Alice', 'Bob', 'Charlie', 'David', 'Emma'],
    'Age': [25, 30, 35, 40, 45],
    'Salary': [50000, 60000, 70000, 80000, 90000]
}
df = pd.DataFrame(data)
print("\nDataFrame:")
print(df)
print("\nSummary Statistics:")
print(df.describe())

#
response = requests.get('https://jsonplaceholder.typicode.com/todos/1')
data = response.json()
print("\nAPI Response:")
print(f"Task title: {data['title']}")
print(f"Completed: {data['completed']}")


plt.figure(figsize=(8, 4))
plt.plot(numbers, numbers**2, marker='o', linestyle='-', color='blue')
plt.title('Square of Numbers')
plt.xlabel('Number')
plt.ylabel('Square')
plt.grid(True)
plt.savefig('number_squares_plot.png')  
plt.show() 
