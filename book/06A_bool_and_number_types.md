# Chapter 6 – Bool and number types
See *6.1_bools.jai*:

```c++
#import "Basic";

main :: () {
    b1 := true;
    print("b1 is of type %\n", type_of(b1)); // => b1 is of type bool

    // equality:
    print("Are 1 and 1.0 equal? %\n", 1 == 1.0); // => Are 1 and 1.0 equal? true
    print("Are Jai and Java different? %\n", "Jai" != "Java"); // => Are Jai and Java different? true

    n := 7;
    m := 42;
    print("%\n", n != m); // => true

    // operators:
    print("! changes to %\n", !b1); // => ! changes to false
    b2 := !b1;

    print("b1 and b2 is %\n", b1 && b2); // => b1 and b2 is false
    print("b1 or b2 is %\n", b1 || b2);  // => b1 or b2 is true
}
```

## 6.1 - Boolean values
bool values `true` and `false` were discussed in § 5.1

### 6.1.1 Equal values and boolean expressions
Two values a and b can be compared with the equality operator **==**:  `a == b`.
This is a _boolean expression_ or _condition_, resulting in a bool value:  
  - it is true when a and b have the same value  
  - it is false in all other cases.

For example:  true == true and 1 == 1.0 are both true.  
The inequality operator **!=** reverses this, it returns true when the values are different:    `"Jai" != "Java"` gives true.

In Jai you cannot compare values of a different type, for example: 
`0 == false: // => Error: Type mismatch. Type wanted: s64; type given: bool.`
Number types are an exception to this rule, for example `1 == 2.0`  is allowed and returns false.

_Question_ What is the value of `"3" == 3`, why?  
_Answer_ This gives an error! Error: Type mismatch. Type wanted: string; type given: s64.

### 6.1.2 Boolean operators
The negation operator (boolean NOT) **!** changes a true value to false and vice-versa.  
The **&&** (boolean AND) operator is true only when both operands are true. 
The **||** (boolean OR) operator is false only when both operands are false.  
They operate in a 'short-circuit' manner, meaning:  
* for && when the 1st operand is false, the 2nd operand is not evaluated, because we know the result is false.  
* for || when the 1st operand is true, the 2nd operand is not evaluated, because we know the result is false.

You can find complete truth tables [here](https://en.wikipedia.org/wiki/Truth_table).

### 6.1.3 The assert statement
See *6.2_assert.jai*:

```c++
#import "Basic";

main :: () {
    assert(5 == 5.0);
    // assert(4 == 5, "4 does not equal 5"); // (1)
    // print("This is not printed when assert (false)");

    n := 42;
    assert(type_of(n) == int);
}

// => With line (1) uncommented:
/*
d:/Jai/The_Way_to_Jai/6_Bool_and_number types/examples/6.3_assert.jai:5,3: Assertion failed: 4 does not equal 5

Stack trace:
c:/jai/modules/Preload.jai:334: default_assertion_failed
c:/jai/modules/Basic/module.jai:74: assert
d:/Jai/The_Way_to_Jai/6_Bool_and_number types/examples/6.3_assert.jai:5: main
*/
```

Instead of always printing out if a bool expression is true of false, there is a handy shortcut with the **assert** procedure, defined in module _Basic_.

`assert` takes an expression, and when this is true, nothing happens. When the expression is false, an assert stops the program execution with **Assertion failed** and the line where it happened, and prints out a stack trace. A message parameter after the expression is optional, but when there is one, it is also printed out (see the example in line (1)).

`assert` also works with complex expressions, procedure calls, and so on. It is a very useful tool to make sure your program is always in a correct state. It is also very handy during debugging.
Also you can leave important assert statements in production code and disable them as described in § 20.1.2. That way, when a problem occurs you can quickly enable them in development/test to try to find the cause.

## 6.2 - Number types
See *6.3_numbers.jai*:

```c++
#import "Basic";

main :: () {
    // 6.2.2 - arithmetic operations:
    score1 := 42;
    score2 := 13;
    total_score := score1 + score2;
    print("total_score is %\n", total_score); // => total_score is 55

    print("8 / 3 is %\n", 8 / 3); // => 8 / 3 is 2
    print("8.0 / 3 is %\n", 8.0 / 3); // => 8.0 / 3 is 2.666667
    print("8 %% 3 is %\n", 8 % 3); // => 8 % 3 is 2
    
    // (1) Dividing by zero
    // print("8 / 0 is %\n", 8 / 0); // => Error: Division by zero.
    // print("8.0 / 0 is %\n", 8.0 / 0); // => Error: Division by zero.
    z := 0;
    // print("8 / z is %\n", 8 / z); // => Runtime error, program stops after this line
    /*
    The program crashed. Printing the stack trace:
handle_exception                  c:\jai\modules\Runtime_Support_Crash_Handler.jai:211    
... (skipping OS-internal procedures)
main                              d:\Jai\The_Way_to_Jai\examples\6\6.3_numbers.jai:18 
    */

    // Mixing of different types:
    a: s32 = -5_069_105;
    b: u8  = 10;
    c: u16 = 50;
    d := a + b; 
    print("d is %\n", d); // => d is -5068898
    print("total_score has type %\n", type_of(total_score));
    // => total_score has type s64
    // total_score *= 3.14; // (2) => Error: Number mismatch. Type wanted: s64; type given: float32.
    message := "YOU WON!";
    // score3 := total_score + message; 
    // (3) => Error: Type mismatch between the arguments of binary operator + (left type: s64; right type: string).

    // (4) Size of integers:
    // This number won't fit into 16 bits
    // i: s16 = 80000;  // => Error: Loss of information (trying to fit 64 bits into 16 bits). Can't do this without an explicit cast. Type wanted: s16; type given: s64.
    // -1 is signed, so it is out of range of what a u32 can store. 
    // j: u32 = -1; // => Error: Number signedness mismatch. Type wanted: u32; type given: s64.    
    // b = c; // Error: Loss of information (trying to fit 16 bits into 8 bits). Can't do this without an explicit cast. Type wanted: u8; type given: u16.

    // (5) Casting:
    b = cast(u8) c;
    b = xx c;
    foo: u8 = xx ifx true then #char "." else #char "#";
    // cast u8 to float works:
    f: float;
    g: u8 = 74;
    f = cast(float) g;
    print("%\n", f); // => 74
    // cast error at runtime:
    // b = cast(u8) a;
    // (6) => Cast bounds check failed.  Number must be in [0, 255]; it was -5069105.  Site is D:/Jai/The Book of Jai/3_Constants_Variables_Types_Operations/code/5_numbers.jai:19. Panic.
    // b = xx a; // => Same error
    b = cast, no_check(u8) a;
    print("a is % and b is %\n", a, b); // => a is -5069105 and b is 207
    a, b += 1;
    print("a is % and b is %\n", a, b); // =>  is -5069104 and b is 208
 
    // Casting float to integer type truncates:
    pi := 3.14; 
    e: u8;
    e = cast(u8) pi;
    e = xx pi; // autocast, equivalent of cast above
    print("e is %\n", e); // (7) => e is 3

    // Cast of bool to int:
    e = xx true;
    print("e is %\n", e); // (8A) => e is 1
    e = xx false;
    print("e is %\n", e); // (8B) => e is 0
    // Cast of int to bool:
    b1: bool = cast(bool) 0;
    print("%\n", b1);       // (8C) => false
    b1 = cast(bool) -50;  // same for positive integers
    print("%\n", b1);       // (8D) => true
    
    // (9) Precedence
    count := 10;
    print("%\n", count/2 - 1);   // => 4
    print("%\n", (count/2) - 1); // => 4
    print("%\n", count/(2 - 1)); // => 10
}
```

We talked about the different number types in § 5.1.2

### 6.2.1 - Comparison operators
We encountered == and != in § 6.1.1.
Numbers have a natural ordering, so they can also be compared with <, <=, > and >=.  
An expression formed with these also results in a bool value:   
`-1 < 42;  // equals true`  
Module _Basic_ contains `min` and `max` routines.

### 6.2.2 - Arithmetic operators
The usual +, -, * and /, % operators are defined for numbers, with abbreviations +=, -=, *= and /=:  `a *= 5;` is the same as `a = a * 5;`.  
Integer division truncates. Modulo operator % doesn't work for floats.
There are no increment (++) or decrement (--) operators.

Division by zero results in a compile-time error if the compiler can see it, but with variables you get a runtime panic with a stack strace; see line (1) and following.

### 6.2.3 - Mixing of different types
Different int types can be mixed, but int and float types cannot: see line (2).  
Addition (+) is only defined for numbers, not for strings, as we see in line (3).  
Line (4) and following: Any number literal or variable can be assigned to a variable if the variable has a 'bigger' type than the literal (so called widening), that is: if it can accommodate the literal; this is _implicit conversion_.
For example, s8, s16, u32 will automatically cast to s64.
But in many cases, Jai blocks the conversion, when the receiving type is too small, or when you want to put a signed integer into an unsigned type.

Conversions cause a lot of bugs in C/C++, that’s why Jai only allows implicit type conversions that make sense.

### 6.2.4 - Casting of values
Line (5) and following: In cases where the compiler indicates an assignment is not possible (for example: to put a bigger type into a smaller type), you can try to force an explicit cast (conversion) with :    **n = cast(Type) m;**  
casting m to type Type and assigning the result to n.

Casting will not always work as you can see in line (6). Cast operations check the range of the value they are casting; if information is lost, that's an error, but it's a runtime error:  

Explicit cast of a float to an int works, but the value is truncated, as you see in line (7):

If you're really sure what you're doing, you can turn off the check at runtime with:  **cast, no_check(type)**
`b = cast, no_check(u8) a;`
This gives an added performance bonus. 

If there is information loss, you can _truncate_ the bits you don't care about, when you are very sure nothing wrong will happen:
**cast, trunc(type)** 

!! At this time (Jan 2023), math bounds checks are not yet implemented: casting checks for overflow, when the compiler can check it with constant values.  For an example of overflow, see 26.19_modify4. One way of taking care of this with polymorph procedures is to write an #modify that checks the type, see § 26.10 !!

### 6.2.5 - Autocasting with xx
Automatic casting can be used when the compiler can infer what casting has to take place at a certain moment, this is indicated with **xx**:  
xx variable;   	// autocast variable to whatever type is needed  
Example:   
`b = xx c;`

But with xx the run-time casting checks are still in place.  
`b = xx a;`    
fails with the same previous error as when doing a cast(u8) a;

In the float to int example, this works but truncates:  
`e = xx pi;`

Use xx to do a quick cast, you can always write the complete cast() when reviewing the code.

#### 6.2.5.1 - Cast of bool to int
bool values can be autocast to ints with xx (see lines (8A-B)):
```c++    
xx true  returns 1  
xx false returns 0
```
#### 6.2.5.2 - Cast of int to bool - truthiness
xx doesn't work here, but a cast(bool) of 0 returns false, and a cast(bool) of any other integer gives true (see line (8C and 8D)).

```c++ 
 // Cast of int to bool:
    b1: bool = cast(bool) 0;
    print("%", b1);       // (8C) => false
    b1 = cast(bool) -50;  // same for positive integers
    print("%", b1);       // (8D) => true
```

In general:
* a cast(bool) of a variable will be false if it's value is zero, null or empty. * a cast(bool) of a variable will be true if it contains a real value.  
This is called the _truthiness_ of a value. This is very useful in branching and looping conditions, see § 14 and § 15. 

### 6.2.6 Complex expressions and precedence
The same [precedence rules as in C](https://www.tutorialspoint.com/cprogramming/c_operators_precedence.htm) are followed, for example: *, /, and % operators have higher precedence and are by default evaluated first before evaluating + and -  
But you can override these rules by using parentheses ( ) around the expression(s) that have to be evaluated first.  
Arbitrarily complex expressions can be formed with boolean and other operators, which can quickly become unreadable. Use parentheses to make the expression more readable, as the code in line (7) shows.

### 6.2.7 Bitwise operators

#### 6.2.7.1 Using bitwise operators
See *6.4_bitwise.jai*:

```c++
#import "Basic";

main :: () {
    // Bitwise operators:
    ab := 0b00_01;
    al := ab << 1;
    print("al is: %\n", al); // => al is: 2
    ar := al >> 1;
    print("ar is the same as ab: %\n", ar == ab); // => ar is the same as ab: true
    alr := ab <<< 1;
    print("alr is: %\n", alr); // => alr is: 2

    print("11001100 & 10001000 is %\n", 0b11001100 & 0b10001000); // => 136
    print("11001100 | 10000011 is %\n", 0b11001100 | 0b10000011); // => 207
    n := 8;
    print("%\n", n % 2 == 0); // => true
    print("%\n", n & 1 == 0); // => true}

/*
al is: 2
ar is the same as ab: true
alr is: 2
11001100 & 10001000 is 136
11001100 | 10000011 is 207
true
*/
```

These are Jai's bitwise operators (they work as in C):

```c++
| - bitwise OR
& - bitwise AND
^ - bitwise XOR
<< - shift left
<<< - rotate left
>> - shift right
>>> - rotate right
~ - bitwise NOT (one's complement) (unary)
```

The code shows some examples of their use. The bitwise operators perform an arithmetic shift, following C's rules.

#### 6.2.7.2 Tests on numbers
Using the % or & operator, the following expressions return true when n is even:	

```c++
n % 2 == 0   
n & 1 == 0 
```

This expression checks that n is a power of 2:

```c++
n & (n - 1) == 0
```

### 6.2.8 Formatting procs
See *6.5_formatting.jai*:

```c++
#import "Basic";

main :: () {
    // Formatting:
    i := 108;
    print("% ", formatInt(i, minimum_digits=2)); // => 108
    print("% ", formatInt(i, base=16, minimum_digits=2)); // => 6c
    j := 7;
    print("% ", formatInt(j, minimum_digits=2)); // => 07
    
    f1 := 2.25193;
    f2 := 3.1400;
    LEADING_WIDTH :: 4;
    print("% \n", formatFloat(f1, width=LEADING_WIDTH, trailing_width=3, zero_removal=.NO)); 
    // => 2.252
    print("% \n", formatFloat(f2, width=1, trailing_width=3, zero_removal=.NO)); // => 3.140
    print("% \n", formatFloat(f2, width=1, trailing_width=3, zero_removal=.YES)); // => 3.14
    print("Scientific-notation-formatted float: %, Decimal value: %\n",  
        formatFloat(12342345234.0, mode=.SCIENTIFIC), 12342345234.0);
}

/*
108 6c i2 = ff
07 2.252
3.140
3.14
Scientific-notation-formatted float: 1.234235e+10, Decimal value: 12342345234
*/
```

These `format` procs give additional functionality for formatting integers and floating numbers. They are defined in Print.jai in the _Basic_ module and return a `Formatter` data structure. The print function knows how to use a Formatter as control structure.

**formatInt** :: (value : Any, base := 10, minimum_digits := 1, digits_per_comma : u16 = 0, comma_string := "") -> FormatInt 

**formatFloat** :: (value : Any, width := -1, trailing_width := -1, mode := FormatFloat.Mode.DECIMAL, zero_removal := FormatFloat.Zero_Removal.YES) -> FormatFloat

Additionally, you can use `print_style.default_format_int` and `print_style.default_format_float` from the context, which contains default Formatters (see § 25.8).

### 6.2.9 Random numbers
See *6.6_random.jai*:

```c++
#import "Basic";
#import "Random";

main :: () {
    // Random numbers: 
    print("A random integer: %\n", random_get()); // => 1137526400306752306
    print("A random float between 0 and 1: %\n", random_get_zero_to_one()); // => 0.709799
    print("A random float between 0 and 100: %\n", random_get_within_range(0, 100)); // => 75.796494

    r := random_seed(current_time_monotonic().low); 
    
    print("\nA random integer: %\n", random_get()); // => 1137526400306752306
    print("A random float between 0 and 1: %\n", random_get_zero_to_one()); // => 0.709799
    print("A random float between 0 and 100: %\n", random_get_within_range(0, 100)); // => 75.796494

}

/*
A random integer: 1137526400306752306
A random float between 0 and 1: 0.709799
A random float between 0 and 100: 75.796494

A random integer: 16108974926811509810
A random float between 0 and 1: 0.603063
A random float between 0 and 100: 65.397636 
*/
```

The following procedures are defined in the _Random_ module (this is just a file *Random.jai* in the _modules_ folder) which deals with random number generation.    
```c++
// sets the global random seed to the value passed as argument
random_seed :: (new_seed: u32) 

// returns a 32 bit unsigned integer, a random number between 0 and 4,294,967,295
random_get :: () -> u64

// returns a 32 bit floating point number within the range of 0.0 and 1.0, like .1358701
random_get_zero_to_one :: () -> float
// returns a 32 bit floating point number within the range of min and max
random_get_within_range :: (min: float, max: float) -> float
```

This is often used with an Apollo time-value (discussed in § 6B) like this:  
`r := random_seed(current_time_monotonic().low);`  
That way the `random_get` functions start with a new seed (which they retrieve from the Context, see § 25).  

If you want more sophistication, use the _PCG_ module which contains the same procs.

### 6.2.10 The Math module
The _Math_ module deals with mathematical operations with an emphasis on game programming related math, such as multiplying 2x2, 3x3, and 4x4 matrices.

It contains amongst others:
* a list of constants like PI, TAU, FLOAT64_MIN, FLOAT64_MAX, FLOAT64_INFINITY, FLOAT64_NAN
* a set of common mathematical functions, like abs,log2
* color utility procedures
* a set of common mathematical objects, such as Vector2, Vector3, Vector4, Quaternion, Matrix2, Matrix3 and Matrix4, Plane, which are all structs  


[6B - Times and dates](https://github.com/Ivo-Balbaert/The_Way_to_Jai/blob/main/book/06B_Times_and_dates.md)   
