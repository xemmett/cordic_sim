
from math import degrees, atan
from pprint import pprint

def main():
    values = []
    for i in range(0, 20):
        x = pow(2, -1*i)
        y = degrees(atan(x))
        print(y)

main()