import numpy as np

def generate_random_integer_matrix(rows, columns):
    if rows <= 0:
        return "Invalid matrix size"
    
    random_matrix = np.random.randint(0, 16, size=(rows, columns), dtype=np.uint8)
    return random_matrix

def integer_matrix_to_binary(matrix):
    binary_matrix = np.unpackbits(matrix, axis=1).reshape(matrix.shape[0], -1, 8)[:, :, -4:]
    return binary_matrix

# Example usage:
rows = int(input("Enter the number of rows: "))
result = generate_random_integer_matrix(rows, rows)

binary_result = integer_matrix_to_binary(result)

# Specify the file path where you want to save the output
output_file = "input.txt"

# Open the file for writing and write the binary matrix to the file
with open(output_file, "w") as file:
    for row in binary_result:
        file.write("\n".join(map(str, row)) + "\n")

print(f"4-Bit Binary Matrix saved to {output_file}")

def process_file(input_file, output_file):
    try:
        with open(input_file, "r") as file:
            lines = file.readlines()

        modified_lines = []

        for line in lines:
            # Remove spaces between numbers and brackets at the beginning and end of each line
            modified_line = line.strip().replace("[", "").replace("]", "\n").replace(" ", "")
            modified_lines.append(modified_line)

        with open(output_file, "w") as file:
            file.writelines(modified_lines)

        print(f"Processed content saved to {output_file}")
    except FileNotFoundError:
        print(f"File not found: {input_file}")
    except Exception as e:
        print(f"An error occurred: {str(e)}")

# Specify the input and output file paths
input_file = "input.txt"  # Replace with your input file
output_file = "C:\\Users\\khanh\\image.txt"  # Replace with your output file

# Call the function to process the file
process_file(input_file, output_file)
