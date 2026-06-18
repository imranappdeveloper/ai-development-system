# wf-feature-alpha-mobile — Project Context

| Field | Value |
|-------|-------|
| project | wf-feature-alpha-mobile |
| stack | React Native 0.74, TypeScript, Expo |
| test_runner | jest + @testing-library/react-native |
| e2e_runner | detox |
| platform_target | cross_platform |
| api_base | `https://api.example.com/api/v1` |
| auth | Secure token storage (`expo-secure-store`) |

## Module Map

| module | path | purpose |
|--------|------|---------|
| screens | `src/screens/` | Native screen components |
| components | `src/components/` | Shared UI components |
| navigation | `src/navigation/` | Stack and tab navigators |
| store | `src/store/` | Client state and API clients |
| tests | `src/__tests__/` | unit and widget tests |
| e2e | `e2e/` | Detox end-to-end tests |

## Test Conventions

```bash
npm test
npm test -- PreferencesScreen.test.tsx
detox test -c ios.sim.debug
```