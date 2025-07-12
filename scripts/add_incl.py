import re
import sys
import update_nsuf


def _add_sep(block: str, sep: str, _sep) -> str:
    lines = block.split('\n')
    for l in lines:
        l = l.strip()
        if not l.startswith('SFX'):
            continue
        l = re.split(' +', l)
        if len(l) > 2 and _sep in l[3]:
            new = [i for i in l]
            new[3] = new[3].replace(_sep, sep)
            lines.append(' '.join(new))
    block = '\n'.join(lines)
    return block


def add_sep_in_file(file, sep, _sep):
    with open(file, 'r') as f:
        blocks = re.split('\n\n+', f.read())
        for n, i in enumerate(blocks):
            i = i.strip()
            i = _add_sep(i, sep, _sep)
            i = update_nsuf.update_n_suff(i)
            blocks[n] = i
    with open(file, 'w') as f:
        f.write('\n\n'.join(blocks))


if __name__ == '__main__':
    sep = sys.argv[1]

    if len(sep) != 1:
        print('wrong value for first argument:', sep)
        quit(0)

    for file in sys.argv[2:]:
        add_sep_in_file(file, sep, '-')
