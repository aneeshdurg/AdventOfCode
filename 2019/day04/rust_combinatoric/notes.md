input is 171309-643603
first number that meets the requirements is 177777, and the last number is
599999. Thus the range can be simplified to `17777-59999`.

We can reduce the number of digits from 6 to 5 and ignore the recurring number
restriction. Any one number can be duplicated to get a total number for 5 * the
number found. This isn't true for the starting number though, because 11777
wouldn't be a valid choice, so we want to skip ahead to 222222 maybe.

Alternatively we could keep the first digit aside and remember to multiply by 6
instead of 5 in some cases.

Psuedocode:
```
find_passwords(a, b) {
    assert(num_digits(a) == num_digits(b));
    // base cases
    if (b > a)
        return 0;
    if a - b < 10 {
        res = 0;
        for(c = a; c < b; c++;) {
            if c/10 < c % 10 {
                res++;
            }
        }
        return res;
    }
    

    let max_n = max_num_with_n_digits(num_digits(a));
    let c = first_digit(a);
    let end = c == first_digit(b) ? remove_first(b) : max_n;
    let res = (num_digits(a) - 1) * find_passwords(remove_first(a), end);

    for (c = first_digit(a) + 1; c < first_digit(b) - 1; c++) {
        res += find_passwords(
            c * 10 ^ (num_digits(b) - 1), max_num_with_n_digits(num_digits(a) - 1));
    }

    let c = first_digit(b);
    // Already covered before the for loop
    if (c == first_digit(a))
        return res;
    let end = remove_first(b);
    let res = (num_digits(a) - 1) * find_passwords(
        first_digit(b) * 10 ^ num_digits(b), remove_first(b));
    return res;
}
// run time: f(n) = 9 * f(n-1) -> O(e^n)
```

