# kdb-pdf

Generate a 2-page styled PDF explaining the kdb+/q concept currently in `content-creation/main.q`.

## Reading main.q

`content-creation/main.q` has two parts:

**Concept block** — the multiline comment at the top (`/ ... \`):
- First non-empty line after `/` is the concept name
- Contains the explanation text, syntax, bullets, and caveats

**Code block** — q code after the `\`:
- Table definitions with the actual data rows
- Sort lines (`xasc`)
- The core operation (e.g. `aj`, `select`, etc.)

Extract the data rows from the table definitions — do not include the definition syntax in the PDF.

## PDF structure

Write a Python script using `pdf_utils.py` and run it with `python3`.

```python
import sys
sys.path.insert(0, '/Users/karthik/Projects/q:kdb+/content-creation')
from pdf_utils import KDBPdf

doc = KDBPdf("kdb+/q  |  <Concept Name>")
```

**Page 1 — Concept**

1. `doc.section("What is <X>?")`
2. `doc.body(...)` — 1-2 sentences: what it does and where it is used
3. `doc.ln(3)`
4. `doc.section("How it Works")`
5. `doc.body(...)` — setup line (e.g. "Say you have a trade at T, and two quotes...")
6. `doc.bullet(...)` — one bullet per quote/event showing the timestamps
7. `doc.ln(2)`
8. `doc.body(...)` — which row gets matched and why
9. `doc.ln(2)`
10. `doc.body("Syntax:")` + `doc.highlighted_code_block([...])` — the syntax line only
11. Three `doc.bullet(...)` calls: as-of/key column, exact-match columns, sorting requirement
12. `doc.ln(3)`
13. `doc.note_box([...])` — the null/edge-case caveat, split across lines so each fits in the box width
14. `doc.divider()`

**Page 2 — Example**

1. `doc.new_page()`
2. `doc.section("Input Tables")` + `doc.body("Both tables are sorted by sym and time before the join:")`
3. `doc.ln(2)` then `start_y = doc.get_y()`
4. Two `doc.data_table(...)` calls side by side:
   - Left table (trades/events): `x0=10`
   - Right table (quotes/lookup): `x0=103`
   - Pass `highlight_rows=[...]` for the rows that get matched — these render green with a "matched" tag
5. `doc.set_y(max(left_bottom, right_bottom) + 6)`
6. `doc.section("Code")` + `doc.ln(1)` + `doc.highlighted_code_block([...])` — sort lines + operation only, with `/ comment` lines for sections
7. `doc.section("Result")` + `doc.ln(1)`
8. `doc.result_table(headers, col_w, rows)` — joined output
9. `doc.ln(4)` + `doc.body(...)` — 1-2 sentences explaining which rows matched and why the most recent was chosen over older ones

## Column widths (mm)

Standard widths that keep tables within the 88mm side-by-side budget:

| column | width |
|--------|-------|
| sym    | 18-20 |
| time   | 34-36 |
| price  | 20-22 |
| size   | 16-18 |
| bid    | 19-22 |
| ask    | 19-22 |

Use short time format (`09:30:00.250`) not full timestamps in the tables.

Result table uses `col_w` summing to ~150mm (full width): add bid/ask columns from the lookup table to the left table's columns.

## Output

Save to `/Users/karthik/Projects/q:kdb+/content-creation/<concept_name>_explainer.pdf`, then `open` it.

Write the script to the scratchpad directory, not the project directory.
