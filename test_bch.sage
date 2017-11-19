from csprng import csprng
from binascii import hexlify
load("bch.sage")

def test_generator( seed ):
    rng = csprng()
    rng.seed(seed)
    m = 16
    delta = 10 + (rng.generate_ulong() % 100)
    n = m*delta + 10 + (rng.generate_ulong() % 100)

    print "testing bch codec generation with n = %i and delta = %i ..." % (n, delta),

    codec = BCH(m, delta, n);

    if codec.k > 0:
        print "success, with generator =", ''.join(str(c) for c in codec.generator.coefficients(sparse=False)), "and k =", codec.k
        return True
    else:
        print "failure: k < 0"
        return False

def test_encode( seed ):
    rng = csprng()
    rng.seed(seed)

    m = 16
    delta = 10 + (rng.generate_ulong() % 100)
    n = m*delta + 10 + (rng.generate_ulong() % 100)

    codec = BCH(m, delta, n);

    print "testing bch encoding with n = %i and delta = %i and consequently k = %i ..." % (n, delta, codec.k),

    msg = [(rng.generate_ulong()%2) for i in range(0, codec.k)]

    print "message", ''.join(str(m) for m in msg),

    cdwd = codec.Encode(msg)

    print "encoded as", ''.join(str(c) for c in cdwd),

    msg_ = codec.DecodeErrorFree(cdwd)[0:codec.k]

    print "decoded as", ''.join(str(m) for m in msg_),

    if msg == msg_:
        print "success! \\o/"
        return True
    else:
        print "fail! <o>"
        return False

def test_correction( seed ):
    rng = csprng()
    rng.seed(seed)

    #print hexlify(seed)

    m = 16
    delta = 10 + (rng.generate_ulong() % 20)
    n = m*delta + 10 + (rng.generate_ulong() % 50)
    num_errors = rng.generate_ulong() % (1+floor((delta-1)/2))

    codec = BCH(m, delta, n);

    print "testing bch error correction with n = %i and delta = %i and consequently k = %i and with (but not consequently) number of errors %i ..." % (n, delta, codec.k, num_errors)

    msg = [(rng.generate_ulong()%2) for i in range(0, codec.k)]

    print "message", ''.join(str(m) for m in msg),

    cdwd = codec.Encode(msg)

    print "encoded as", ''.join(str(c) for c in cdwd),

    print "adding errors in positions",
    for i in range(0, num_errors):
        pos = rng.generate_ulong()%n
        print "", pos,
        cdwd[pos] = 1 - cdwd[pos]

    msg_ = codec.Decode(cdwd)[0:codec.k]

    print "decoded as", ''.join(str(m) for m in msg_),

    if msg == msg_:
        print "success! \\o/"
        return True
    else:
        print "fail! <o>"
        return False

def main( ):
    rng = csprng()
    random = "deadbeef"
    rng.seed(bytearray(random.decode("hex")))
    print "Running series of tests with randomness", hexlify(rng.generate(4)), "..."

    success = True
    for i in range(0,10): 
        success = (success and test_generator(rng.generate(8)))
        if success == False:
            break
    for i in range(0,10): 
        success = (success and test_encode(rng.generate(8)))
        if success == False:
            break
    for i in range(0,10): 
        success = (success and test_correction(rng.generate(8)))
        if success == False:
            break
    
    if success == True:
        print "success."
    else:
        print "failure."

def test_original( rng ):
    m = 16
    delta = 45
    n = 2000
    bch = BCH(m, delta, n)
    msg = [bch.F.random_element() for i in range(0,bch.k)]
    print "message:", str(msg)
    
    cdwd = bch.Encode(msg)
    print "codeword:", cdwd
    print "(end codeword)"
    rcvd = copy(cdwd)
    
    errors = [bch.F(0) for i in range(0, bch.n)]
    num_errors = (delta-1)//2
    error_locations = []
    for i in range(0, num_errors):
        index = ZZ(Integers(len(rcvd)).random_element())
        error_locations.append(index)
    error_locations.sort()
    for index in error_locations:
        #print "creating error at location", index
        e = 1
        rcvd[index] += e
        errors[index] += e
    
    sigma = bch.Ex(1)
    for i in range(0, bch.n):
        if errors[i] == 1:
            sigma = sigma * (bch.Ex(1) - bch.z^i * bch.X)
    #print "sigma:", sigma
    #for i in range(0, bch.n):
    #    if sigma(bch.z^(-i)) == 0:
    #        print "found error at location", i
    
    print "received:", ''.join(str(r) for r in rcvd)
    print "(end received, length: %i)" % len(rcvd)
    
    #print "syndrome:", bch.Syndrome(rcvd)
    
    msg_ = bch.Decode(rcvd)
    
    print "decoded:", msg_
    
    if msg == msg_:
        print "success!"
        print "corrected", num_errors, "errors in code of dimension", bch.k, "and length", bch.n
    else:
        print "failure!"

main()

