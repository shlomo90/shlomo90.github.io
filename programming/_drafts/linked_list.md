---
layout: post
tags: programming c linked_list double single
comments: true
---

# Linked List


* Various types of linked list
  * Single Linked List
  * Double Linked List
  * Circular Linked List

---

## Single Linked List

* Definition
  * A node are forward linked to the next node.
* Pros
  * Simple. not complex code.
* Cons
  * To find the specific node, It should start from the head.
  * To get the previous node of a specific node, It should start over.
  * Backward searching is too overhead.
  * Moving nodes are not effective
  * It needs to know where the head is to access another node.

* Example code (Single Linked List)

```c
#include <stdio.h>
#include <stddef.h>

#define my_get_data(q, type, queue) \
    (type*)(q - offsetof(type, queue))

typedef struct queue_s   queue_t;
typedef struct data_s    data_t;

struct queue_s {
    queue_t    *next;
};

struct data_s {
    queue_t     queue;
    int         key;
};

void init_queue(queue_t *head, data_t *data, int num)
{
    queue_t     **temp;

    temp = &head->next;
    for (int i=0; i<num; i++) {
        data[i].key = i;
        *temp = &data[i].queue;
        temp = &data[i].queue.next;
    }
}

int remove_queue(queue_t *head, int key)
{
    queue_t     **temp;
    data_t       *data;
    int           rc;

    rc = 1;
    temp = &head->next;
    while (*temp != NULL) {
        data = my_get_data(*temp, data_t, queue);
        if (data->key == key) {
            data->key = -1;
            if ((*temp)->next == NULL) {
                *temp = NULL;
            } else {
                *temp = (*temp)->next;
            }
            rc = 0;
            break;
        }        
        temp = &(*temp)->next;
    }
    return rc;
}

void print_queue(queue_t *head)
{
    queue_t    *iter;

    for (iter=head->next; iter!=NULL; iter=iter->next) {
        data_t      *data;
        data = my_get_data(iter, data_t, queue);
        printf("%d\n", data->key);
    }
}

int main(int argc, char* argv[])
{
    data_t      data[100];
    queue_t     head;

    init_queue(&head, data, 100);   // Initalize queues in data array
    remove_queue(&head, 99);        // Remove 99's queue
    print_queue(&head);             // Print all queues
    return 0;
}

```

## Double Linked List

* Definition
  * A node are each forward and backward linked to the prev/next node.
* Pros
  * It searches any direction (Forward or Backward)
* Cons
  * Need more memory?
* Example Codes


```c

```
