---
layout: default
---

## Tools

### Get values from the current context

1. __Highlight an element in the Chrome inspector__ by right-clicking an element and selecting "inspect this element". Now, toggle to the JavaScript console and evaluate `$0`. That's the node that you've highlighted in the inspector!

2. __`$context(node)`__ returns the context for the given node. This is great for seeing what keypaths are on the node, for example,

  {% highlight javascript %}
  // select a node in the inspector
  $context($0).get("myRecord.attribute")
  $context($0).get("controller")
  $context($0).get("controller.myRecord.attribute")
  {% endhighlight %}

## Common Errors:

### `Uncaught HierarchyRequestError: A Node was inserted somewhere it doesn't belong.`
- if you're using Rails, then the server is returning the layout instead of the template HTML. The error is raised when your browser is asked to insert a `html`, `head` or `body` tag inside a `body` tag. That node doesn't belong there!
- Open your network log, and visit the path where batman.js is trying to load the template. Is the server serving the template HTML there, or something else?
- If you're using rails and trying to use Slim or HAML for your templates or serve templates in production, check out [this fix](#todo)

### `Uncaught TypeError: Cannot call method 'dispatch' of undefined` ==> Batman is trying to call `dispatch` on a controller that doesn't exist. Check:
- In your App definition, did you provide the correct `camel_case` spelling of the controller name?
- Did you define the controller named in the route?
- Is it loaded on the page?
