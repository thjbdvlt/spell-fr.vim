import re


def update_n_suff(block: str) -> str:
    lines = block.split('\n')
    lines = [i.strip() for i in lines]
    nsuf = 0
    nnon = 0
    nfirst = None
    for n, i in enumerate(lines):
        if not i.startswith('#'):
            if nnon == 0:
                nfirst = n
            else:
                nsuf += 1
            nnon += 1
    if nfirst is None:
        return block
    lines[nfirst] = re.sub(r"\d+ *$", str(nsuf), lines[nfirst])
    block = '\n'.join(lines)
    return block
