import re
n = int(input())
p = re.compile('(100+1+|01)+')
li = []
for i in range(n):
    S = input()
    s = p.fullmatch(S)
    if s : li.append("DANGER")
    else : li.append("PASS")
for i in li :
    print(i)
