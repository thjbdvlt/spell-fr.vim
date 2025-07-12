import update_nsuf
import re


def _add_sep_pl(block: str) -> str:
    lines = block.split('\n')
    nlines = len(lines)
    for n in range(nlines):
        l = lines[n]
        l = l.strip()
        if l.startswith('SFX') and 'is:incl' in l and re.search(r"is:\w*pl\b", l):
            # split the line
            l = re.split(' +', l)
            new = [i for i in l]
            # if not ('·' in l[3] or '-' in l[3]):
            #     continue
            # get the current separator
            sep = '·' if '·' in new[3] else '-'
            # add the separator before the plural mark
            new[3] = re.sub('(s[$/])', f'{sep}\\1', new[3])
            new = ' '.join(new)
            lines.append(new)
            # update the morph. features
    block = '\n'.join(lines)
    return block


def add_sep_in_file(file):
    with open(file, 'r') as f:
        blocks = re.split('\n\n+', f.read())
        for n, i in enumerate(blocks):
            i = i.strip()
            i = _add_sep_pl(i)
            i = update_nsuf.update_n_suff(i)
            blocks[n] = i
    with open(file, 'w') as f:
        f.write('\n\n'.join(blocks))


if __name__ == '__main__':
    add_sep_in_file('../aff/verbs.aff')
