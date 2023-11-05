import numpy as np

def generate_random_integer_matrix(rows, columns):
    if rows <= 0 or columns <= 0:
        return "Invalid matrix size"
    
    random_matrix = np.random.randint(0, 16, size=(rows, columns))
    return random_matrix

def integer_matrix_to_binary(matrix):
    binary_matrix = np.unpackbits(matrix[:, :, np.newaxis], axis=2)[:, :, -4:]
    return binary_matrix

# Example usage:
rows = int(input("Enter the number of rows: "))
columns = int(input("Enter the number of columns: "))
result = generate_random_integer_matrix(rows, columns)
print("Random Integer Matrix:")
print(result)

binary_result = integer_matrix_to_binary(result)
print("\n4-Bit Binary Matrix:")
print(binary_result)
