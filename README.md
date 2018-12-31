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
Point = KtDataClass.create(:x, :y)
p1 = Point.new(x: 3, y: 4)

puts p1.x, p1.y
```

Also, some convenient methods can be added like below:

```
Point = KtDataClass.create(:x, :y) do
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

### Immutable

```
Profile = KtDataClass.create(:hobby)
profile = Profile.new(hobby: "Ruby")

profile.hobby = "Python"
# NoMethodError: undefined method `hobby=' for #<Profile:0x0000000000ee2668 @hobby="Ruby">

new_profile = profile.copy(hobby: "Python")

profile.hobby
# => "Ruby"
new_profile.hobby
# => "Python"
```

### Destructuring assignment

```
Point = KtDataClass.create(:x, :y)
p = Point.new(x: 1, y: 2)
x, y = p

x
# => 1

y
# => 2
```

## FAQ

### How can I define default value?

In Kotlin,

```
data class Point(x: Int = 0, y: Int = 0)
```

This can be implemented by overriding constructor like below:

```
Point = KtDataClass.create(:x, :y) do
  def initialize(x: 0, y: 0)
    super
  end
end

Point.new
# => #<Point:0x00000000020c5b78 @x=0, @y=0>

Point.new(x: 1)
# => #<Point:0x00000000020a90e0 @x=1, @y=0>
```
