n = int(input())
cur = 0
v, ans = [], []
for i in range(n):
    u, s, e = map(int, input().split())
    v.append([u, s, e])
v = sorted(v, key = lambda x : (x[2], x[1]))
for i in v :
    if cur <= i[1]:
        cur = i[2]
        ans.append(i[0])
print(len(ans))
print(ans)
