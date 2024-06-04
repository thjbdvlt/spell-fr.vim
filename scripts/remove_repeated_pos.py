"""enlève les doublons dans les annotations morphologiques

par exemple:
    aller # po:verb po:verb po:verb
    aller # po:verb
"""

import csv
import os

COMMENT_STRING = "#"

_current = os.path.realpath(__file__)
_dir = os.path.dirname(_current)
_superdir = os.path.dirname(_dir)
CSV_FILEPATH = os.path.join(_superdir, 'feats', 'is_to_feats.csv')

if not os.path.isfile(CSV_FILEPATH):
    raise FileNotFoundError(CSV_FILEPATH)

_rows = []
with open(CSV_FILEPATH, "r") as f:
    _rows = list(csv.reader(f))

LOOKUP_FEATS = {}
for is_, feats in _rows:
    LOOKUP_FEATS[is_] = " ".join(["is:" + i for i in feats.split("|")])


def enlever_doublons(line):
    word, comment = line.split(COMMENT_STRING)
    annotations = " ".join(sorted(set(comment.split()), reverse=True))
    return f"{word.strip()} {COMMENT_STRING} {annotations.strip()}"


def convert_to_feats(line):
    word, comment = line.split(COMMENT_STRING)
    annotes = comment.split()
    base_annotes = []
    feats = []
    for i in annotes:
        if i.startswith("is:"):
            feats.append(LOOKUP_FEATS[i])
        else:
            base_annotes.append(i)
    annotes = list(set(base_annotes)) + sorted(set(feats))
    annotes = " ".join(annotes)
    return f"{word.strip()} {COMMENT_STRING} {annotes.strip()}"


if __name__ == "__main__":
    import sys

    try:
        filepath = sys.argv[1]
    except IndexError:
        print("need an argument: filepath.")

    with open(filepath, "r") as f:
        c = f.readlines()

    # _rows = [convert_to_feats(l) if COMMENT_STRING in l else l for l in c]
    _rows = [enlever_doublons(l) if COMMENT_STRING in l else l for l in c]

    with open(filepath, "w") as f:
        f.write("\n".join(_rows))
