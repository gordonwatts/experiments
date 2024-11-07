for i in 5:64
    z = BigFloat("1.23456789012345678901234567890123456789", precision=i)
    next_val = nextfloat(z)
    distance = abs(next_val - z)
    delta_exponent = floor(Int, log10(distance))
    significant_digits = floor(Int, -log10(abs(z - BigFloat("1.23456789012345678901234567890123456789"))))
    println("Precision: $i bits, Precision: $significant_digits, Value: $z, delta: $delta_exponent")
end
