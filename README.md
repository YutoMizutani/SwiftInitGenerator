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