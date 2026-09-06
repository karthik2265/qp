# Read and trim lines
with open("day-6-inputs.txt") as f:
    inputs = [line.strip() for line in f.readlines()]

# Collapse multiple spaces then split on single space
import re
inputs = [re.split(r" ", re.sub(r" +", " ", line)) for line in inputs]
rows, cols = len(inputs), len(inputs[0])
formattedInputs = []
for i in range(cols):
    x = []
    for j in range(rows):
        x.append(inputs[j][i])
    formattedInputs.append(x)
inputs = formattedInputs
print(inputs)
# Evaluate each row
def evaluate(x):
    if x[-1] == "*":
        result = 1
        for n in x[:-1]:
            result *= int(n)
        return result
    else:
        return sum(int(n) for n in x[:-1])

print(sum(evaluate(x) for x in inputs))