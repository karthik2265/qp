position = 50
count = 0

with open("day-1-inputs.txt") as f:
    for line in f:
        print("###")
        if position == 0:
          count += 1
        instruction = line.strip()

        direction = instruction[0]
        steps = int(instruction[1:])
        print(direction)
        print(steps)

        if direction == "R":
            position = (position + steps) 
            position = position % 100
        else:  # "L"
            position = (position - steps) 
            position = position % 100
        print(position)
        print("###")

print(count, position) # 969, 50