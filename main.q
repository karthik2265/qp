raw: read0 `$":day-1-inputs.txt";
directions: raw[;0];
rotations: "J"$1_/:raw;
rotations: @[rotations; where directions="L"; neg];
count_zeros:0;

position_change:{[curr_pos;rotation]
    // if[(curr_pos=0) & (rotation > 0) & (rotation <= 99); count_zeros:: count_zeros+1];
    show "###"
    show `rotation`curr_pos!(rotation;curr_pos);
    q: (curr_pos + rotation) div 100;
    m: (curr_pos + rotation) - (100 * q); 
    count_zeros :: count_zeros + abs q;
    show `wraps`next_pos!(abs 1; m);
    show "###";
    :m;
    }
final_position: 50 position_change/ rotations;
if[final_position=0;count_zeros: count_zeros+1];
show final_position;
show count_zeros;
