#!/bin/env python


def a():
    import random

    while True:
        n = 7

        str = ""

        for x in range(0, n):
            str += chr(random.randint(0x61, 0x7A))

        print(str)

        input("")


def b():
    from random_word import RandomWords

    while True:

        r = RandomWords()

        w1 = r.get_random_word(minLength=5)
        w1 = w1[0: 2]
        w2 = r.get_random_word(maxLength=7)

        print(str(w1 + w2).lower())
        input("")


def c():
    import random

    while True:
        n = 7

        str = "seria"

        for x in range(0, 2):
            str = chr(random.randint(0x61, 0x7A)) + str

        print(str)

        input("")


c()
