def solve_2025_part2(filename="input.txt"):
    position = 50
    zero_count = 0
    
    with open(filename, 'r') as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
                
            direction = line[0]         # 'L' or 'R'
            steps = int(line[1:])       # Distance to rotate
            
            # Simulate each click step-by-step
            for _ in range(steps):
                if direction == 'L':
                    position -= 1
                else:
                    position += 1
                    
                # Dial wraps around between 0 and 99
                position %= 100
                
                # Check if this precise step landed on zero
                if position == 0:
                    zero_count += 1
                    
    return zero_count

print("2025 Part 2 Solution:", solve_2025_part2("day-1-inputs.txt"))