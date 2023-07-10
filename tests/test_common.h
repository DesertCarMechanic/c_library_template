
enum RESULT {
    RESULT_SUCCESS,
    RESULT_FAILURE
};

struct TestUnit {
    void (*print_error)(void);
    void (*print_success)(void);
    enum RESULT (*test)(void);
};

