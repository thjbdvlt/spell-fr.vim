import re
import update_nsuf


def _add_compflag(block: str) -> str:
    lines = block.split("\n")
    nlines = len(lines)
    for n in range(nlines):
        l = lines[n]
        l = l.strip()
        if l.startswith("SFX") and "is:ipre" in l and "is:3sg" in l:
            l = re.split(" +", l)
            new = [i for i in l]
            new[3] = new[3].replace('/', '-/&v')
            new = ' '.join(new)
            lines.append(new)
    block = "\n".join(lines)
    return block


def add_sep_in_file(file):
    with open(file, "r") as f:
        blocks = re.split("\n\n+", f.read())
        for n, i in enumerate(blocks):
            i = i.strip()
            i = _add_compflag(i)
            i = update_nsuf.update_n_suff(i)
            blocks[n] = i
    with open(file, "w") as f:
        f.write("\n\n".join(blocks))


if __name__ == '__main__':
    add_sep_in_file("../aff/verbs.aff")
