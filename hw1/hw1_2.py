li = list(map(int,input().split()))
def q_sort(s, e):
    if s >= e : return
    pv = li[(s+e)//2]
    p1, p2 = s, e
    while p1 <= p2:
        while li[p1] < pv: p1 += 1
        while li[p2] > pv: p2 -= 1
        if p1 <= p2:
            tmp = li[p1]
            li[p1] = li[p2]
            li[p2] = tmp
            p1 += 1
            p2 -= 1
    q_sort(s,p2)
    q_sort(p1,e)
q_sort(0, len(li)-1)
print(li)
