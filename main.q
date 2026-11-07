/
🧩 Challenge

    Load the inventory.txt into a kdb+ table.
    Classify each food item by adding a new column with a flag (1b,0b) indicating whether the food is perishable or not
    Clean the inventory by:
        Removing any expired items (items with quantity of zero or less)
        Grouping any duplicated items (e.g., if milk appears twice, the resulting table should have only one row with the quantities summed)
    Update and replenish the inventory:
        After a recount, you need to update your inventory. Items to update: banana +5, rice +10, chocolate +3
        Some foods are already in your list, others may be new.
        Overwrite quantities where the food exists, otherwise append new rows where they don’t.
\

// read data
table: ("SF"; enlist ",") 0: `:input.txt;
perishableItems: `apples`bread`milk`carrots`eggs`yogurt`cheese`lettuce`tomatoes`grapes`banana;
table: update perishable: name in perishableItems from table;
// clean
table: delete from table where quantity <= 0;
table: select quantity: sum quantity by name from table;
// update
names:`banana`rice`chocolate;
quantities: 5 10 3f;
rows: names!quantities;
// update quantity for existing items
table: update quantity: quantity + rows[name] from table where name in (key rows);
// add for new ones
existingItems: exec name from table where name in names;
rows: existingItems _ rows;
rows: `name`quantity!(key rows; value rows);
rows: flip rows;
`table insert rows;
// show table;
// 1st question
// show count table;
// 2nd quesiton
totalPerishableItems: exec sum quantity from table where name in perishableItems;
show totalPerishableItems;
