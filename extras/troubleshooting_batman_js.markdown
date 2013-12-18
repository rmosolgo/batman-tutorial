---
---

## Common Errors:

`Uncaught TypeError: Cannot call method 'dispatch' of undefined` ==> Batman is trying to call `dispatch` on a controller that doesn't exist. Check:
- In your App definition, did you provide the correct `camel_case` spelling of the controller name?
- Did you define the controller named in the route?
- Is it loaded on the page?
