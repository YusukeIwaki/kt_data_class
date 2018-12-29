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

Also, some convenient methods can be added like below:

```
Point = KtDataClass.create(x: Fixnum, y: Fixnum) do
  def -(other)
    self.class.new(x: x - other.x, y: y - other.y)
  end

  def norm
    Math.sqrt(x * x + y * y)
  end
end

(Point.new(x: 4, y: 5) - Point.new(x: 1, y: 1)).norm
# => 5.0
```

### Strongly typed

```
Point=KtDataClass.create(x: Fixnum, y: Fixnum)

p1 = Point.new(x: 3, y: 4)
# => #<Point:0x000000000233c5f0 @x=3, @y=4>

p2 = Point.new(x: 3, y: "4")
# ArgumentError: type mismatch: y must be a Fixnum, String given
```

### Destructuring assignment

```
Point = KtDataClass.create(x: Fixnum, y: Fixnum)
p = Point.new(x: 1, y: 2)
x, y = p

x
# => 1

y
# => 2
```
