# KtDataClass

Kotlinの

```
data class Point(val x: Int, val y: Int)

val p1 = Point(3, 4)
```

のように書けるやつをRubyで作ってみようという試み。

## Feature

### Basic usage

```
Point = KtDataClass.create(x: Fixnum, y: Fixnum)
p1 = Point.new(x: 3, y: 4)

puts p1.x, p1.y
```


### Strongly typed

```
Point=KtDataClass.create(x: Fixnum, y: Fixnum)

p1 = Point.new(x: 3, y: 4)
# => #<Point:0x000000000233c5f0 @x=3, @y=4>

p2 = Point.new(x: 3, y: "4")
# ArgumentError: type mismatch: y must be a Fixnum, String given
```