# RandomUserKit

This is a sample project to use as an example for a post on [the buddybuild blog](https://www.buddybuild.com/blog).

Follow along by [forking the repository](https://help.github.com/articles/fork-a-repo/).

## Usage

```swift
import RandomUserKit

let provider = Provider()
provider.fetchOne { results in 
  switch results { 
    case let .success(user):
      print("Fetched user \(user.name.first) \(user.name.last) (\(user.email))")
    case let .failure(error):
      print("Got error: \(error)")
  }
}
```
