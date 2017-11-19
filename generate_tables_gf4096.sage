F = FiniteField(4096, "a")

def F2int( elm ):
    integer = 0
    coeffs = elm.polynomial().coefficients(sparse=False)
    for i in range(0, len(coeffs)):
        integer += ZZ(coeffs[i]) * 2^i
    return integer

table = []
x = F.gen()
acc = F(1)
for i in range(0, 4095):
    table.append(F2int(acc))
    acc *= x

print "#ifndef GF4096_TABLES"
print "#define GF4096_TABLES"
print ""
print "unsigned int gf4096_antilogs[4096] = {",
for i in range(0, len(table)):
    if i % 10 == 0:
        print ""
    print "%i, " % table[i],
print "1"
print "};"

print "unsigned int gf4096_dlogs[4096] = {"
print "4095, ",
idx = 0
for i in range(1, len(table)):
    for idx in range(0, len(table)):
        if table[idx] == i:
            break
    print "%i, " % idx,
    if i % 10 == 9:
        print ""
for idx in range(0, len(table)):
    if table[idx] == 4095:
        break
print "%i" % idx
print "};"
print ""
print "#endif"
print ""

