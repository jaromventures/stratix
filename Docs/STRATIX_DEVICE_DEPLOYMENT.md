# Stratix device deployment

The `Stratix tvOS Device IPA` workflow builds a physical-device IPA with Xcode 26 or newer and the tvOS SDK. It intentionally leaves the IPA unsigned so Apple credentials and private keys never enter GitHub Actions.

The resulting artifact is suitable for the existing Windows atvloadly workflow. atvloadly performs the local Apple-ID signing and installs the app without changing other Apple TV applications. Use a user-owned bundle identifier if the signing tool requires one; do not reuse the upstream developer team ID.

Before installing, confirm the Apple TV is paired in atvloadly and that the target Apple TV runs tvOS 26 or newer. A successful Actions artifact proves only compilation and packaging. Launch, Microsoft device-code authentication, Game Pass entitlement, controller input, WebRTC video, and audio still require testing on the physical Apple TV.

Do not commit Apple certificates, provisioning profiles, P12 files, Apple passwords, Microsoft tokens, or device-code values.
