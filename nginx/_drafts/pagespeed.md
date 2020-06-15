## pagespeed

* code example

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

* it means that `NgxConnection` that is inherited from `PoolElement`.
* `NgxConnection` class itself has the `NgxConnection` type's list.
