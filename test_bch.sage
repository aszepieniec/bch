load("bch.sage")

m = 8
delta = 45
bch = BCH(m, delta)
msg = [bch.F.random_element() for i in range(0,bch.k)]
print "message:", msg

cdwd = bch.Encode(msg)
print "codeword:", cdwd
rcvd = copy(cdwd)

errors = [bch.F(0) for i in range(0, bch.n)]
num_errors = (delta-1)//4
error_locations = []
for i in range(0, num_errors):
    index = ZZ(Integers(len(rcvd)).random_element())
    error_locations.append(index)
error_locations.sort()
for index in error_locations:
    print "creating error at location", index
    e = 1
    rcvd[index] += e
    errors[index] += e

sigma = bch.Ex(1)
for i in range(0, bch.n):
    if errors[i] == 1:
        sigma = sigma * (bch.Ex(1) - bch.z^i * bch.X)
print "sigma:", sigma
for i in range(0, bch.n):
    if sigma(bch.z^(-i)) == 0:
        print "found error at location", i

print "received:", rcvd

print "syndrome:", bch.Syndrome(rcvd)

msg_ = bch.Decode(rcvd)

print "decoded:", msg_

if msg == msg_:
    print "success!"
else:
    print "failure!"

