li = list(map(int,input().split()))
n = int(input())
def binary_search(s, e):
    while s <= e:
        m = (s+e)//2
        if li[m] == n:
            return m + 1
            break
        elif li[m] < n:
            s = m + 1
        else:
            e = m - 1
    return -1
ans = binary_search(0, len(li)-1)
if ans < 0: print("None")
else: print(ans)
