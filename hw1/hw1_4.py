class node:
    def __init__(self, val):
       self.l, self.r, self.val = None, None, val
root = node(15)
root.l, root.r = node(1), node(37)
root.l.l, root.l.r = node(61), node(26)
root.r.l, root.r.r = node(59), node(48)
def pre(u):
    print(u.val)
    if u.l: pre(u.l)
    if u.r: pre(u.r)
def _in(u):
    if u.l: _in(u.l)
    print(u.val)
    if u.r: _in(u.r)
def post(u):
    if u.l: post(u.l)
    if u.r: post(u.r)
    print(u.val)
print("Preorder Traverse")
pre(root)
print("Inorder Traverse")
_in(root)
print("Postorder Traverse")
post(root)
