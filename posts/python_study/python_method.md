<link rel="stylesheet" type="text/css" media="all" href="https://shlomo90.github.io/homepage.css" />

# Python

---

## classmethod

* A class method is a method which is bound to the class and not the object of the class.
* Here is the example.

```python
class C(object):
    test = 'good'
    add = 10

    @classmethod
    def fun(cls, arg1, arg2):
        print arg1
        print arg2
		cls.add = 30
        return arg1 + arg2 + cls.add

    def good(self, arg1, arg2):
        print arg1
        print arg2
		self.add = 20
        return arg1 + arg2 + cls.add

c = C()
a = C()
#print c.test
C.test = 'ttt'
b = C()
#print b.test
#print a.test

print C.fun(1, 2)
#print C.good(3, 4)  #<-- not working. (unbound method good() should be called with C instance
print C().good(3, 4)    #<-- working.
```

* classmethod is ...
	1. it receives an implicit first arguemnt. (it uses the 'cls' convention not 'self'.)
	2. it doesn't need an instance to call classes' functions. (Ex: `C.fun(1, 2)`)
	3. In the classmethod function, you can change cls's members that would be affected to another
	   **INSTANCES**'s members. (it is bound to class.)
	   - It can modify a class state that would apply across all the instances of the class. For example it can modify a class variable that will be applicable to all the instances.

## staticmethod

* staticmethod is ...
	1. it doesn't receive an implicit first argument.
	2. it doesn't need an instance to call classes' functions. (Ex: `C.fun(1, 2)`)
	3. Differnt from classmethod, It generally cannot change the classes' state. because it can't access the class state.
	   (But, Actually It's possible to use `__dict__`. See below example.)

```python
class C(object):
    test = 'good'
    add = 10

    @classmethod
    def fun(cls, arg1, arg2):
        print arg1
        print arg2
        cls.add = 20
        return arg1 + arg2 + cls.add

    def good(self, arg1, arg2):
        print arg1
        print arg2
        #self.add = 30
        return arg1 + arg2 + self.add

    @staticmethod
    def bad(arg1, arg2):
        print "dict is {}".format(C.__dict__)
        return arg1 + arg2 + C.__dict__['add']

b = C()
print b.bad(1, 2)	#<-- result: 13
print C.fun(1, 2)	#<-- result: 23 ('add' variable changed to 20)
print b.bad(1, 2)	#<-- result: 23 (C.__dict__['add'] is changed to 20)
```
