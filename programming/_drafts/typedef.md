# Typdef In C


```c
typedef struct test_s test_t;
typedef int (*test_handler_ptr)(test_t *);

#if 0

struct {
    test_t              *next;
    test_handler_ptr     handler;
}test_s;

#elif 1

struct test_s {
    test_t              *next;
    test_handler_ptr     handler;
};

#else

struct test_s {
    struct test_s *next;
    int          (*handler)(struct test_s *);
};

#endif

int main(int argc, char* argv[])
{
    return 0;
}
```
