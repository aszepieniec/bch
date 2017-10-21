load("reedsolomon.sage")

m = 5
delta = 17
rs = ReedSolomon(m, delta)
msg = [rs.F.random_element() for i in range(0,rs.k)]
print "msg:", msg

cdwd = rs.Encode(msg)
print "cdwd:", cdwd
cdwd_poly = rs.Fx(0)
for i in range(0,len(cdwd)):
    cdwd_poly += cdwd[i] * rs.x^i
rcvd = copy(cdwd)

num_errors = 8
for i in range(0, num_errors):
    index = ZZ(Integers(len(rcvd)).random_element())
    rcvd[index] = rs.F.random_element()

msg_ = rs.Decode(rcvd)

if msg == msg_:
    print "success!"
else:
    print "failure!"
