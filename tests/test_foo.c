
#include <stdio.h>

#include "../src/foo.h"
#include "test_common.h"

void foo_test_power_print_error(void)
{ printf("foo_power function error"); }
void foo_test_power_print_success(void)
{ printf("foo_power function ran successfully"); }
enum RESULT foo_test_power_func(void)
{
    if (foo_power(10, 2) == 100) return RESULT_SUCCESS;
    return RESULT_FAILURE;
}

struct TestUnit foo_test_pow = {
    foo_test_power_print_error,
    foo_test_power_print_success,
    foo_test_power_func,
};

