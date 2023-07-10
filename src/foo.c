
int foo_power(int number, int power)
{
    int result = 1;
    while (power != 0) {
        result = result * number;
        power--;
    }
    return result;
}

