# FlikPik Development Guide

## Build & Test Commands
- Build: Open in Xcode and use Cmd+B (Build) or Product > Build
- Run: Cmd+R or Product > Run
- Test UI: Use SwiftUI Previews in Xcode (Option+Cmd+Return)
- Clean: Product > Clean Build Folder

## Code Style Guidelines
- **Architecture**: Follow MVVM pattern with SwiftUI
- **Imports**: SwiftUI and Foundation first, then alphabetical
- **Naming**: UpperCamelCase for types, lowerCamelCase for properties/methods
- **Types**: Use strong typing, avoid Any/AnyObject
- **Optionals**: Prefer conditional unwrapping (if let/guard let) over force unwrapping
- **Error Handling**: Use do-catch with meaningful error messages
- **Async**: Use modern async/await pattern for asynchronous operations
- **SwiftUI**: Use @State, @Binding, @Environment appropriately
- **Comments**: Document complex logic, but prefer self-documenting code

## Project Structure
- Views/ - UI components
- Managers/ - Data controllers and service layer