v = list(map(int,input().split()))
def merge(l, m, r):
    t = []
    p1, p2 = l, m + 1
    while p1 <= m and p2 <= r:
        if v[p1] <= v[p2] :
            t.append(v[p1])
            p1 += 1
        else :
            t.append(v[p2])
            p2 += 1
    while p1 <= m:
        t.append(v[p1])
        p1 += 1
    while p2 <= m:
        t.append(v[p2])
        p2 += 1
    for i in range(len(t)): v[l + i] = t[i]
def merge_sort(l, r):
    if l == r: return
    m = int((l + r)//2)
    merge_sort(l, m)
    merge_sort(m + 1, r)
    merge(l, m, r)
merge_sort(0, len(v) - 1)
print(v)
