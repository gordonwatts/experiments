# Introduction

This directory contains some experiments in understanding the accuracy of various calculations and bits, etc.

## Calculations and Accuracy

The `calcaccuracy.jl` file simulates a random calculation to see how much it might vary depending on the size of the error. I conclude from this it is very easy to build a set of operations that are unstable. You have to be very careful you aren't dividing by small numbers or multiplying by large ones, etc. As long as you do that, you're mean will remain stable and the _width_ of the resulting calculation is also as expected.

Simple (no operations):
```powershell
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 0 --precision 9
Using 8 threads
Mean: -2.128e-13, stddev: 1.000e-09, n_trials: 10000
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 0 --precision 5
Using 8 threads
Mean: -2.045e-09, stddev: 9.999e-06, n_trials: 10000
```

Lets do a single random operation:
```powershell
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 1 --precision 9
Using 8 threads
Mean: -4.734e-08, stddev: 1.937e-04, n_trials: 10000
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 1 --precision 5
Using 8 threads
Mean: 1.896e-10, stddev: 8.187e-06, n_trials: 10000
```

Lets do a depth of 4, which is $2^4=16$ operations:
```powershell
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 4 --precision 9
Using 8 threads
Mean: 5.259e-02, stddev: 2.517e+03, n_trials: 10000
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 4 --precision 5
Using 8 threads
Mean: 1.124e+08, stddev: 1.125e+10, n_trials: 10000
```

What if we turn off using `/` and `-` (so only `+`, `*`, `sqrt`, and `$x^2$`):

```powershell
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 4 --precision 9 
Using 8 threads
Mean: 1.007e-14, stddev: 1.617e-09, n_trials: 10000
PS C:\Users\gordo\Code\atlas\experiments> C:\Users\gordo\AppData\Local\Programs\Julia-1.11.1\bin\julia.exe .\Precision\calcaccuracy.jl --depth 4 --precision 5
Using 8 threads
Mean: -3.651e-09, stddev: 2.186e-05, n_trials: 10000
```

## Precision

The `precision.jl` dumps out the following which gives one an idea of how much numbers change as a function of how many bits are used for the floating point mantisa:

```text
Precision: 5 bits, Precision: 1, Value: 1.25, delta: -2
Precision: 6 bits, Precision: 1, Value: 1.25, delta: -2
Precision: 7 bits, Precision: 3, Value: 1.234, delta: -2
Precision: 8 bits, Precision: 3, Value: 1.234, delta: -3
Precision: 9 bits, Precision: 3, Value: 1.234, delta: -3
Precision: 10 bits, Precision: 3, Value: 1.2344, delta: -3
Precision: 11 bits, Precision: 3, Value: 1.2344, delta: -4
Precision: 12 bits, Precision: 3, Value: 1.2344, delta: -4
Precision: 13 bits, Precision: 4, Value: 1.2346, delta: -4
Precision: 14 bits, Precision: 4, Value: 1.23462, delta: -4
Precision: 15 bits, Precision: 5, Value: 1.23456, delta: -5
Precision: 16 bits, Precision: 5, Value: 1.23456, delta: -5
Precision: 17 bits, Precision: 5, Value: 1.234573, delta: -5
Precision: 18 bits, Precision: 5, Value: 1.234566, delta: -6
Precision: 19 bits, Precision: 5, Value: 1.23457, delta: -6
Precision: 20 bits, Precision: 6, Value: 1.2345676, delta: -6
Precision: 21 bits, Precision: 6, Value: 1.2345676, delta: -7
Precision: 22 bits, Precision: 6, Value: 1.2345681, delta: -7
Precision: 23 bits, Precision: 8, Value: 1.2345679, delta: -7
Precision: 24 bits, Precision: 8, Value: 1.23456788, delta: -7
Precision: 25 bits, Precision: 8, Value: 1.23456788, delta: -8
Precision: 26 bits, Precision: 8, Value: 1.23456788, delta: -8
Precision: 27 bits, Precision: 8, Value: 1.234567896, delta: -8
Precision: 28 bits, Precision: 8, Value: 1.234567888, delta: -9
Precision: 29 bits, Precision: 8, Value: 1.234567892, delta: -9
Precision: 30 bits, Precision: 9, Value: 1.2345678899, delta: -9
Precision: 31 bits, Precision: 9, Value: 1.2345678899, delta: -10
Precision: 32 bits, Precision: 9, Value: 1.2345678899, delta: -10
Precision: 33 bits, Precision: 10, Value: 1.2345678902, delta: -10
Precision: 34 bits, Precision: 10, Value: 1.23456789018, delta: -10
Precision: 35 bits, Precision: 11, Value: 1.23456789012, delta: -11
Precision: 36 bits, Precision: 11, Value: 1.23456789012, delta: -11
Precision: 37 bits, Precision: 11, Value: 1.234567890118, delta: -11
Precision: 38 bits, Precision: 11, Value: 1.234567890126, delta: -12
Precision: 39 bits, Precision: 11, Value: 1.234567890122, delta: -12
Precision: 40 bits, Precision: 12, Value: 1.2345678901238, delta: -12
Precision: 41 bits, Precision: 12, Value: 1.2345678901238, delta: -13
Precision: 42 bits, Precision: 12, Value: 1.2345678901233, delta: -13
Precision: 43 bits, Precision: 12, Value: 1.2345678901233, delta: -13
Precision: 44 bits, Precision: 14, Value: 1.23456789012346, delta: -13
Precision: 45 bits, Precision: 14, Value: 1.23456789012346, delta: -14
Precision: 46 bits, Precision: 14, Value: 1.23456789012346, delta: -14
Precision: 47 bits, Precision: 14, Value: 1.234567890123458, delta: -14
Precision: 48 bits, Precision: 14, Value: 1.234567890123458, delta: -15
Precision: 49 bits, Precision: 14, Value: 1.234567890123458, delta: -15
Precision: 50 bits, Precision: 15, Value: 1.234567890123456, delta: -15
Precision: 51 bits, Precision: 15, Value: 1.2345678901234569, delta: -16
Precision: 52 bits, Precision: 15, Value: 1.2345678901234569, delta: -16
Precision: 53 bits, Precision: 16, Value: 1.2345678901234567, delta: -16
Precision: 54 bits, Precision: 16, Value: 1.2345678901234568, delta: -16
Precision: 55 bits, Precision: 16, Value: 1.2345678901234568, delta: -17
Precision: 56 bits, Precision: 16, Value: 1.2345678901234568, delta: -17
Precision: 57 bits, Precision: 17, Value: 1.234567890123456788, delta: -17
Precision: 58 bits, Precision: 17, Value: 1.234567890123456788, delta: -18
Precision: 59 bits, Precision: 17, Value: 1.234567890123456788, delta: -18
Precision: 60 bits, Precision: 18, Value: 1.2345678901234567893, delta: -18
Precision: 61 bits, Precision: 18, Value: 1.2345678901234567893, delta: -19
Precision: 62 bits, Precision: 18, Value: 1.2345678901234567889, delta: -19
Precision: 63 bits, Precision: 19, Value: 1.2345678901234567891, delta: -19
Precision: 64 bits, Precision: 19, Value: 1.23456789012345678899, delta: -19
```