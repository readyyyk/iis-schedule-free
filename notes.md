# Project Notes

## Resolving SwiftUI Group/model Group Naming Conflict

**Issue:**
A cryptic error appeared: `Trailing closure passed to parameter of type 'any Decoder' that does not accept a closure`, referencing the model `Group` and SwiftUI view code. This was caused by a naming conflict between the app's model `Group` and the SwiftUI `Group` view. The compiler tried to use the model's `init(from:)` in the view context, leading to the error.

**Solution:**
Disambiguate the SwiftUI view by using `SwiftUI.Group { ... }` instead of `Group { ... }` in the view code. This makes it clear to the compiler that the SwiftUI container is intended, not the model.

**Best Practice:**
Consider renaming models that conflict with common SwiftUI view/container names to avoid similar issues in the future. 
