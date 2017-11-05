F = FiniteField(256, "a")
a = F.gen()

Fz = PolynomialRing(F, "x")
x = Fz.gen()

def F2hex( elm ):
    acc = 0
    coeffs = elm.polynomial().coefficients(sparse=False)
    for i in range(0,len(coeffs)):
        acc += ZZ(coeffs[i]) * 2^i
    s = hex(acc)
    if len(s) == 1:
        return '0' + s
    else:
        return s

def hex2F( h ):
    integer = int(h, 16)
    acc = F(0)
    for i in range(0, 8):
        if integer % 2 == 1:
            acc += a^i
        integer = integer >> 1
    return acc

def Fx2hex( poly ):
    return ''.join([F2hex(c) for c in poly.coefficients(sparse=False)])

def hex2Fx( hh ):
    poly = Fz(0)
    for i in range(0, len(hh)/2):
        poly += hex2F(hh[(2*i):(2*i+2)]) * x^i
    return poly

poly = hex2Fx('0100e001')
E = QuotientRing(Fz, poly)
Ez = PolynomialRing(E, "z")
z = Ez.gen()

def E2hex( elm ):
    l = elm.lift()
    c = l.coefficients(sparse=False)
    if len(c) == 0:
        return '000000'
    if len(c) == 1:
        return '0000' + F2hex(c[0])
    if len(c) == 2:
        return '00' + F2hex(c[1]) + F2hex(c[0])
    else:
        return F2hex(c[2]) + F2hex(c[1]) + F2hex(c[0])

def hex2E( h ):
    c2 = hex2F(h[0:2])
    c1 = hex2F(h[2:4])
    c0 = hex2F(h[4:6])
    return E(x^2*c2 + x*c1 + c0)

def Ex2hex( poly ):
    return ''.join([E2hex(c) for c in poly.coefficients(sparse=False)])

def hex2Ex( hh ):
    poly = Ez(0)
    for i in range(0, len(hh) / 6):
        poly += hex2E(hh[(6*i):(6*(i+1))]) * z^i
    return poly



def special_xgcd( x, y ):
    s = Ez(0)
    old_s = Ez(1)
    t = Ez(1)
    old_t = Ez(0)
    r = y
    old_r = x

    print "input to xgcd:"
    print "x:", Ex2hex(x)
    print "y:", Ex2hex(y)
    input("press any character and then enter to continue ...")

    while r != 0:
        print "r:", Ex2hex(r)
        print "s:", Ex2hex(s)
        print "t:", Ex2hex(t)

        print ""
        print "numerator:", Ex2hex(old_r)
        print "divisor:", Ex2hex(r)

        remainder = old_r % r
        quotient = (old_r - remainder) // r

        print "quotient:", Ex2hex(quotient)
        print "remainder:", Ex2hex(remainder)

        input("press any character and then enter to continue ...")
        print ""

        old_r = r
        r = remainder

        temp = quotient * s + old_s
        old_s = s
        s = temp

        temp = quotient * t + old_t
        old_t = t
        t = temp

    a = old_s
    b = old_t
    g = old_r

    lc = g.coefficients(sparse=False)[-1]
    a = a / lc
    b = b / lc
    g = g / lc

    return g, a, b

