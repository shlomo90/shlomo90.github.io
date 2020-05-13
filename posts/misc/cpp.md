

# C Plus Plus

## Purpose

* I can read C++ code well.
* I can make a C++ code file without any reference
* I can fully understance about C++.


## Template

* This code example is in `pagespeed` module in Nginx that is written as C++.
* At the first time, I don't understand many directives I don't know, but Let's figure them out step by step.

### code example

``` cpp
template<class T>
class PoolElement {
    public: 
        typedef typename std::list<T*>::iterator Position;

        PoolElement() { }

        // Returns a pointer to a mutable location holding the position of
        // the element in any containing pool.
        Position* pool_position() { return &pool_position_; }

    private:
        Position pool_position_;

        DISALLOW_COPY_AND_ASSIGN(PoolElement);
};

class NgxConnection : public PoolElement<NgxConnection> {
    ...
}
```

### Analysis

* First of all, We need to know about `std::list`.
    * `std::list` is a container that supports constant time insertion and removal of elements from anywhere in the container.
    * It is usually implemented as a doubly-linked list.

``` cpp
template<class T, class Allocator = std::allocator<T>>
class list;
```
    * template parameters
        * The type of the elements (`std::list` seems like supporting linked list with the type of something T)
        * Allocator that is used to acquire/release memory and to construct/destroy the elements in that memory.
    * usages
        * `std::list<int> l = {7, 5, 1, 32, 222}`: In the namespace 'std', the int type's list.
        * modifiers
            * `clear`: `l.clear()`
            * `push_back`: `l.push_back(13)`
* `template<class T>` means the class `PoolElement` is a template class and its members could have `T` types.
    * `T` could be int or double or etc....
* `PoolElement` class doesn't take parameters but it has public/private member variables and functions.
    * `typedef typename std::list<T*>::iterator Position;`
        * `typedef` is defining something (ex: typename std::list<T*>::iterator) as `Position`.
        * `typename` is used for specifying that a dependent name in a template definition or declarations is a type
            * `std::list<T*>::iterator` is a type.
            * `list<T*>` is the dependent name in a template definition.
            > A name used in a template declaration or definition and that is dependent on a template-parameter is assumed not to name a type unless the applicable name lookup finds a type name or the name is qualified by the keyword typename.
* As I mentioned, the constructor `PoolElement() {}` doesn't take any parameter and do nothing.
* `Position* pool_position() { return &pool_position_; }` 
    * public method `pool_position` does return the private member `pool_position_`.
    * It is conventional for C++. Usually We don't access private members directly.
* `Position pool_position_`
    * `Position` is type defined as `std::list<T*>::iterator` and it dependent class PoolElement's template type.
    * if the template type (T) is int, `Position` would have `std::list<int*>::iterator`.
* `DISALLOW_COPY_AND_ASSIGN(PoolElement);`
    * We don't care about it yet.


## ':' single colon's ussage

### To Inherite

* See the case example
``` cpp
class PoolElement;
class NgxConnection;
class NgxConnection : public PoolElement<NgxConnection> {
    public:
        // ... snipped ...
    private:
        // ... snipped ...
}
```

* The example shows `NgxConnection` is inherited by `PoolElement`.
* Also, You can override method and members.


## Constructor and Destructor in class

* Constructor and Destructor can have many types Let's See the cases

### Cases 1

``` cpp
class Car {
    public:
    string brand;
    string model;
    int year;
    Car(string x, string y, int z); //<-- Constructor declaration
}


Car::Car(string x, string y, int z) {
  brand = x;
  model = y
  year = z;
}
```

* You can just declare the function prototype and define it later.


### Case 2

``` cpp
class Car {
    public:
    string brand;
    string model;
    int year;
    Car(string x, string y, int z) {
        brand = x;
        model = y
        year = z;
    }
}
```

* Usually the constructor is declared and defined at the same time.


### Case 3

``` cpp
class String
{
private:
    char *s;
    int size;
public:
    String(char *); // constructor
    ~String();      // destructor
};

String::String(char *c)
{
    size = strlen(c);
    s = new char[size+1];
    strcpy(s,c);
}

String::~String()
{
    delete []s;
}
```

* The destructor name starts with '~' it's convention.
* The purpose of destructor is to release memroy areas allocated.
* The constructor and destructor are no more than one.


## using directive

* `using` directive
    * using-directives for namespaces and using-declarations for namespace members
    * example `using namespace std;`


## virtual directive

* The `virtual` specifier specifies that a non-static member function is virtual and supports dynamic dispatch.
* Virtual functions are member functions whose behavior can be overridden in derived classes.


## & and * operators

* The meaning of '&' between variable type and name is a "reference to".

``` cpp
int main()
{
    int a {4};
    int& ra = a;    // ra refers to 'a' variable

    cout << ra << endl; // it's same with a
}
```

