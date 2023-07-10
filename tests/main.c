
#include <stdio.h> // for printf
#include <stdlib.h> // for srand
#include "test_foo.h"
#include "test_common.h"

void run_test(struct TestUnit *t)
{
    enum RESULT r = t->test();
    if (r == RESULT_SUCCESS) {
        printf("Success: ");
        t->print_success();
        printf("\n");
    } else {
        printf("Error: ");
        t->print_error();
        printf("\n");
    }
}

int main() {

    srand(TEST_SEED); // TEST_SEED defined in Makefile

    struct TestUnit *tests[] = {
        &foo_test_pow,
        NULL,
    };

    unsigned int i;
    struct TestUnit *current_test = tests[0];
    for(i=1; current_test != NULL; i++) {
        run_test(current_test);
        current_test = tests[i];
    }

    return 0;
}
