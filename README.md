# SwiftInitGenerator

## TL;DR

```swift
class User: Equatable {
var id: UUID;
/// Some comments
var name: String?;var favorited: Bool
```

↓

```swift
init(id: UUID,
name: String?,
favorited: Bool) {
self.id = id
self.name = name
self.favorited = favorited
}
```

## これは何ですか?

class は init が必要ですが，自動で生成してくれることはありません。それを class から 変数定義までをそれっぽくコピペするだけで吐いてくれるツールです。
ネストは Xcode に任せる形で，プロパティ補完のみ行ないます。

## Screenshot

<img width="592" alt="screenshot 165" src="https://user-images.githubusercontent.com/22558921/59078873-09527800-891c-11e9-991c-8f4deac8d695.png">
