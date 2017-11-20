F = FiniteField(2^12, "a")
z = F.gen()

def str2F( s ):
    integer = int(s, 16)
    elm = F(0)
    for i in range(0, 12):
        if (integer & (1 << i)) != 0:
            elm += z^i
    return elm

def F2str( e ):
    integer = 0
    coeffs = e.polynomial().coefficients(sparse=False)
    for i in range(0,len(coeffs)):
        if coeffs[i] == F(1):
            integer += 2^i
    h = hex(integer)
    while len(h) < 3:
        h = '0' + h
    return h

Fx = PolynomialRing(F, "x")
x = Fx.gen()

def str2Fx( s ):
    poly = Fx(0)
    for i in range(0, len(s)/3):
        poly += str2F(s[(3*i):(3*i+3)]) * x^i
    return poly

def Fx2str( p ):
    return ''.join(F2str(c) for c in p.coefficients(sparse=False))


