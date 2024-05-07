"""enlève les doublons dans les annotations morphologiques

par exemple:
    aller # po:verb po:verb po:verb
    aller # po:verb
"""


def enlever_doublons(line):
    word, comment = line.split("#")
    annotations = " ".join(sorted(set(comment.split()), reverse=True))
    return f"{word.strip()} # {annotations.strip()}"


if __name__ == "__main__":
    import sys

    try:
        filepath = sys.argv[1]
    except IndexError:
        print("need an argument: filepath.")

    with open(filepath, "r") as f:
        c = f.readlines()

    a = [enlever_doublons(l) if "#" in l else l for l in c]

    with open(filepath, "w") as f:
        f.write("\n".join(a))
