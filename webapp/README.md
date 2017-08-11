# Rails app demonstrating decorator-based self-schizophrenia

I was curious whether a popular Rails decorator library,
[Draper](https://github.com/drapergem/draper), suffered from
self-schizophrenia issues like showing the wrong IDs in forms, haml,
etc, or exhibiting dispatch/"local rebinding" issues.

I only got as far as to demonstrate Draper doesn't integrate with
Haml's auto-id syntax, but that's good enough to prove the point.

It should show "widget_1" as the ID, but instead it shows "widget_decorator_1":

### Wrong ID:

![Wrong IDs generated with haml+draper](readme/screenshot_03.jpg)

&nbsp;

### The Code:

![Wrong IDs generated with haml+draper](readme/screenshot_04.jpg)
