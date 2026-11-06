from fpdf import FPDF
from fpdf.enums import XPos, YPos

Q_BUILTINS = {'xasc', 'xdesc', 'aj', 'aj0', 'show', 'select', 'from',
               'where', 'by', 'update', 'delete', 'exec', 'lj', 'ij', 'pj'}

SYNTAX = {
    'comment':  (106, 153, 85),
    'symbol':   (79,  193, 255),
    'keyword':  (220, 220, 100),
    'string':   (206, 145, 120),
    'number':   (181, 206, 168),
    'operator': (180, 180, 180),
    'default':  (200, 200, 200),
}

def _tokenize_q(line):
    if line.lstrip().startswith('/'):
        return [('comment', line)]
    tokens = []
    i = 0
    while i < len(line):
        c = line[i]
        if c == '`':
            j = i + 1
            while j < len(line) and (line[j].isalnum() or line[j] == '_'):
                j += 1
            tokens.append(('symbol', line[i:j]))
            i = j
        elif c == '"':
            j = i + 1
            while j < len(line) and line[j] != '"':
                j += 1
            tokens.append(('string', line[i:min(j+1, len(line))]))
            i = min(j + 1, len(line))
        elif c.isdigit():
            j = i + 1
            while j < len(line) and line[j] in '0123456789.eE:DT_':
                j += 1
            tokens.append(('number', line[i:j]))
            i = j
        elif c.isalpha() or c == '_':
            j = i + 1
            while j < len(line) and (line[j].isalnum() or line[j] == '_'):
                j += 1
            word = line[i:j]
            tokens.append(('keyword' if word in Q_BUILTINS else 'default', word))
            i = j
        elif c in ':;[](){}.,!#%&|^~<>+*/\\=@':
            tokens.append(('operator', c))
            i += 1
        else:
            tokens.append(('default', c))
            i += 1
    return tokens


class _InnerPDF(FPDF):
    def __init__(self, title):
        super().__init__()
        self._title = title

    def header(self):
        self.set_fill_color(15, 23, 42)
        self.rect(0, 0, 210, 20, 'F')
        self.set_font("Helvetica", "B", 13)
        self.set_text_color(255, 255, 255)
        self.set_y(5)
        self.cell(0, 10, self._title, align="C",
                  new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        self.set_text_color(0, 0, 0)
        self.ln(10)

    def footer(self):
        self.set_y(-12)
        self.set_font("Helvetica", "I", 8)
        self.set_text_color(150, 150, 150)
        self.cell(0, 10, f"Page {self.page_no()}", align="C")


class KDBPdf:
    """
    Themed PDF builder for kdb+/q concept explainers.

    Usage:
        doc = KDBPdf("kdb+/q  |  As-of Join (aj)")

        # Page 1 - concept
        doc.section("What is X?")
        doc.body("...")
        doc.bullet("...")
        doc.highlighted_code_block(["aj[`sym`time; trades; quotes]"])
        doc.note_box(["Caveat line 1", "Caveat line 2"])
        doc.divider()

        # Page 2 - example
        doc.new_page()
        doc.section("Input Tables")
        y = doc.get_y()
        doc.data_table(x0=10,  y0=y, label="trades", headers=[...], col_w=[...], rows=[...])
        doc.data_table(x0=103, y0=y, label="quotes", headers=[...], col_w=[...], rows=[...], highlight_rows=[1,4])
        doc.set_y(bottom_y + 6)
        doc.section("Code")
        doc.highlighted_code_block([...])
        doc.section("Result")
        doc.result_table(headers=[...], col_w=[...], rows=[...])
        doc.body("Explanation...")

        doc.save("/path/to/output.pdf")

    Standard column widths (mm) for financial tables:
        sym:   18-20
        time:  34-36  (use short form e.g. 09:30:00.250, not full timestamp)
        price: 20-22
        size:  16-18
        bid:   19-22
        ask:   19-22

    Side-by-side layout: trades at x0=10, quotes at x0=103 (both ~88mm wide)
    highlight_rows: list of row indices in the quotes table that aj matched
    """

    def __init__(self, title="kdb+/q"):
        self._p = _InnerPDF(title)
        self._p.set_auto_page_break(auto=True, margin=18)
        self._p.add_page()

    def new_page(self):
        self._p.add_page()

    def get_y(self):
        return self._p.get_y()

    def set_y(self, y):
        self._p.set_y(y)

    def ln(self, h=5):
        self._p.ln(h)

    def section(self, title):
        p = self._p
        p.set_font("Helvetica", "B", 14)
        p.set_text_color(15, 23, 42)
        p.set_fill_color(226, 232, 240)
        p.cell(0, 10, f"  {title}", new_x=XPos.LMARGIN, new_y=YPos.NEXT, fill=True)
        p.ln(3)

    def body(self, text, indent=0):
        p = self._p
        p.set_font("Helvetica", "", 12)
        p.set_text_color(30, 30, 30)
        p.set_x(p.l_margin + indent)
        p.multi_cell(0, 7, text)
        p.ln(2)

    def bullet(self, text):
        p = self._p
        p.set_font("Helvetica", "", 12)
        p.set_text_color(30, 30, 30)
        p.set_x(p.l_margin)
        p.multi_cell(0, 7, f"- {text}")

    def note_box(self, lines):
        p = self._p
        p.set_fill_color(254, 243, 199)
        p.set_draw_color(234, 179, 8)
        p.set_line_width(0.4)
        x = p.l_margin
        h = len(lines) * 7 + 7
        p.rect(x, p.get_y(), 190, h, 'FD')
        p.set_font("Helvetica", "", 11)
        p.set_text_color(120, 80, 0)
        p.set_y(p.get_y() + 3)
        for line in lines:
            p.set_x(x + 3)
            p.cell(0, 7, line, new_x=XPos.LMARGIN, new_y=YPos.NEXT)
        p.ln(4)

    def divider(self):
        p = self._p
        p.set_draw_color(203, 213, 225)
        p.set_line_width(0.3)
        p.line(p.l_margin, p.get_y(), 200, p.get_y())
        p.ln(4)

    def highlighted_code_block(self, lines):
        p = self._p
        p.set_font("Courier", "", 11)
        x0 = p.l_margin
        lh = 8
        h = len(lines) * lh + 6
        block_y = p.get_y()
        p.set_fill_color(22, 27, 34)
        p.set_draw_color(55, 65, 81)
        p.set_line_width(0.3)
        p.rect(x0, block_y, 190, h, 'FD')
        p.set_fill_color(56, 139, 253)
        p.rect(x0, block_y, 2, h, 'F')
        y = block_y + 4
        for line in lines:
            x = x0 + 7
            for color_key, text in _tokenize_q(line):
                r, g, b = SYNTAX[color_key]
                p.set_text_color(r, g, b)
                p.set_xy(x, y)
                w = p.get_string_width(text)
                p.cell(w, lh, text)
                x += w
            y += lh
        p.set_text_color(30, 30, 30)
        p.set_y(block_y + h + 5)

    def data_table(self, x0, y0, label, headers, col_w, rows, highlight_rows=None):
        p = self._p
        highlight_rows = highlight_rows or []
        p.set_font("Helvetica", "B", 10)
        p.set_text_color(100, 116, 139)
        p.set_xy(x0, y0)
        p.cell(sum(col_w), 7, label)
        y = y0 + 7
        p.set_fill_color(15, 23, 42)
        p.set_text_color(255, 255, 255)
        p.set_font("Helvetica", "B", 9.5)
        p.set_xy(x0, y)
        for i, h in enumerate(headers):
            p.cell(col_w[i], 9, h, border=1, fill=True, align="C")
        y += 9
        for ri, row in enumerate(rows):
            if ri in highlight_rows:
                p.set_fill_color(187, 247, 208)
                p.set_text_color(20, 83, 45)
            elif ri % 2 == 0:
                p.set_fill_color(241, 245, 249)
                p.set_text_color(30, 30, 30)
            else:
                p.set_fill_color(255, 255, 255)
                p.set_text_color(30, 30, 30)
            p.set_font("Courier", "", 9.5)
            p.set_xy(x0, y)
            for i, val in enumerate(row):
                p.cell(col_w[i], 9, val, border=1, fill=True, align="C")
            if ri in highlight_rows:
                p.set_font("Helvetica", "B", 7.5)
                p.set_text_color(21, 128, 61)
                p.set_xy(x0 + sum(col_w) + 1, y + 2)
                p.cell(14, 5, "matched")
            y += 9
        return y

    def result_table(self, headers, col_w, rows):
        p = self._p
        p.set_fill_color(15, 23, 42)
        p.set_text_color(255, 255, 255)
        p.set_font("Helvetica", "B", 10)
        for i, h in enumerate(headers):
            p.cell(col_w[i], 9, h, border=1, fill=True, align="C")
        p.ln()
        for ri, row in enumerate(rows):
            p.set_fill_color(241, 245, 249) if ri % 2 == 0 else p.set_fill_color(255, 255, 255)
            p.set_text_color(30, 30, 30)
            p.set_font("Courier", "", 9.5)
            for i, val in enumerate(row):
                p.cell(col_w[i], 9, val, border=1, fill=True, align="C")
            p.ln()

    def save(self, path):
        self._p.output(path)
        print(f"PDF saved: {path}")
