load("gf256e3.sage")

def proper_lift( element ):
    F = FiniteField(2)
    Fx = PolynomialRing(F, "x")
    x = Fx.gen()
    poly = Fx(0)
    large_coeffs = element.lift().coefficients(sparse=False)
    for i in range(0, len(large_coeffs)):
        small_coeffs = large_coeffs[i].polynomial().coefficients(sparse=False)
        for j in range(0, len(small_coeffs)):
            poly += small_coeffs[j] * x^(i*8+j)
    return poly

def minpoly( element ):
    MS = MatrixSpace(FiniteField(2), 24, 25)
    mat = copy(MS.zero())


    for i in range(0, 25):
        coeffs = proper_lift(element^i).coefficients(sparse=False)
        for j in range(0, len(coeffs)):
            mat[j, i] = coeffs[j]

    print "mat:"
    print mat.str()

    k = mat.right_kernel().matrix().transpose()
    print "mat rank:", mat.rank()
    print "k:", k
    poly = PolynomialRing(FiniteField(2), "x")(0)
    for i in range(0, 24):
        poly += k[i,0] * poly.parent().gen()^i

    return poly

