/*
 * Double linked list
 */

typedef struct queue_s  queue_t;

struct queue_s {
    queue_t     *prev;
    queue_t     *next;
};

// double circle linked list 
#define queue_init(q) \
    (q)->prev = (q); \
    (q)->next = (q);

/*
 * 1. 
 *
 *      q1           q2    
 *   +------+     +------+
 *   | prev <-----> prev |
 *   | next <-----> next |
 *   +------+     +------+
 *           target 
 *          +------+
 *          | prev |
 *          | next |
 *          +------+
 *   - To be easy to understand, q1 and q2 could be same or not
 *   - There is a target to be inserted between them
 *   - First, link target's prev, next
 *     - x's prev points to q
 *     - x's next points to q's next's prev
 *
 * 2. 
 *      q1                    q2    
 *   +------+              +------+
 *   | prev <--------------> prev |
 *   | next <--------------> next |
 *   +------+              +------+
 *       ^        q            ^
 *       |      +------+       |
 *       +------+ prev |       |
 *              | next +-------+
 *              +------+
 *   - Link q1's next and q2's prev
 *     - q's next's prev points to x
 *     - q's next = x
 *
 * 3. 
 *     q            x             q
 *   +------+     +------+      +------+
 *   | prev |<----+ prev |<-----+ prev |
 *   | next +---->| next +----->| next |
 *   +------+     +------+      +------+
 */

#define queue_insert_head(q, target) \
    (target)->prev = (q); \
    (target)->next = (q)->next->prev; \
    (q)->next->prev = (target); \
    (q)->next = (target);

#define ngx_queue_insert_head(h, x)                                           \
    (x)->next = (h)->next;                                                    \
    (x)->next->prev = x;                                                      \
    (x)->prev = h;                                                            \
    (h)->next = x


// init
// insert
// delete

struct test {
    queue_t      queue;
    void        *data;
};



int main(int argc, char *argv[])
{
    struct test t[100];
    queue_t head;
    queue_t *iter;

    queue_init(&head);
    for (int i = 0; i < 100; i++) {
        //queue_insert_head(&head, &t[i].queue);
        ngx_queue_insert_head(&head, &t[i].queue);
    }

    iter = &head;
    printf("%p\n", iter->next);
    printf("%p\n", iter->next->next);
    printf("%p\n", iter->next->next->next);
    return 0;
}
