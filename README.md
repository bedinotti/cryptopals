# Cryptopals
This is my collection of solutions to the [Cryptopals Crypto Challenges](https://cryptopals.com). 

## Explanations
I explain each of my solutions after writing them. You can [see the full collection on my website](https://chrisdownie.net/cryptopals/).

## Architecture
While this is built as a macOS app, it doesn't have any real UI aside from the stock "Hello World" in the SwiftUI template. It's really meant to be run in Xcode with a console attached so you can see printed output.

### CryptoTools framework
Most of the interesting, reusable methods are in the `CryptoTools` framework. This includes
- `Analysis`, for analyzing encrypted data and encryption methods
- `Cipher`s, for encrypting and decrypting data
- `DataDisplay` for rendering byte arrays to make them more readable.

This framework also has an associated `CryptoToolsTests` product that unit tests these methods.

### Cryptopals app
This contains all of the challenges in the `Challenges` directory. Each challenge solution is in its own file, and sends updates back to the challenge runner with `update(_:)` and `complete(success:)`. Not all challenges can be judged successful in code, so not all challenges call `complete(success:)`. 

Each set is in its own numbered folder.
