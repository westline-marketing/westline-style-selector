# Bugbot review rules — @westline/style-selector

## Review context from the vault

Read `vault/01-project-context.md`, `vault/02-architecture.md`, `vault/03-status.md`, `vault/04-code-map.md`, and `vault/handoff.md`, then the relevant README/GUIDE/changelog section. The package source and public types are executable truth; the vault records consumer contracts and release history. Flag drift because many client sites consume this package.

## Project and severity

This public React/TypeScript package applies allowlisted CSS-variable presets, serializes a pre-hydration inline script, persists selection/trigger state, portals an accessible drawer, and publishes to npm on tags. Prepaint injection, token allowlisting, server/client entrypoints, production gating, accessibility, storage namespaces, and releases are high-risk shared contracts.

## Always flag

- User/config values reaching the inline prepaint script without the established escaping/serialization protections, or any ability to inject script, HTML, selectors, CSS properties, `url()`, or event handlers.
- Bypassing or weakening `allowedTokens`, applying variables outside `targetSelector`, failing to clear package-owned overrides, or letting one instance overwrite another's style/storage namespace.
- Root/server-safe exports importing browser globals or client components, missing `'use client'` on the client subpath, hydration mismatch, or DOM/storage access during SSR.
- Production gating changes that make the selector default-on, misunderstand `NEXT_PUBLIC_ENABLE_STYLE_SELECTOR`, or leave client review tooling visible after launch.
- Focus-trap, keyboard, scroll-lock, touch target, reduced-motion, contrast, draggable-trigger, or mobile drawer regressions.
- Persistence/legacy migration changes that lose a valid preset, accept an unknown preset, retain stale URL state, or collide across instances.
- Public type/export changes without backward compatibility or release notes; npm workflow changes that skip tests/build/provenance or expose `NPM_TOKEN`.

## Lower-priority / avoid noise

- Consuming sites own their preset colors and token names; do not enforce one site's palette here.
- Demo/generated output and cosmetic drawer preferences are lower priority unless public behavior or accessibility changes.

## Verification expectations

Require unit/jsdom tests for prepaint escaping, allowlists, SSR import safety, namespace migration, late-mounted targets, accessibility interactions, and mobile layout. Run test, typecheck, build, and `npm pack --dry-run` for public-contract/release changes.
