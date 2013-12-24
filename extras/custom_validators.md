---
layout: chapter
---

- subclass
- triggers: when these options are passed to `@validate`, this validator will be initialized and its validations will be run
- options: passed to constructor, avaliable at `@options`
- validateEach:
  - `record` is the record being validated
  - `key` is the key that was passed to `@validate`
  - `errors` is a `Batman.ErrorsSet`, may `errors.add(key, message)`
  - must fire `callback`
- Push the Validator to `Batmman.Validators` so that it will be checked by `@validate`

{% highlight coffeescript %}
class Batman.LessThanPropertyValidator extends Batman.Validator
  @triggers 'lessThanProperty'
  @options 'allowBlank'

  validateEach: (errors, record, key, callback) ->
      value = record.get(key)
      compareKey = @options.lessThanProperty
      otherValue = record.get(compareKey)
      else !@handleBlank(value) && value >= otherValue
        errors.add(key, 'must be less than #{compareKey}')
      callback()

Batman.Validators.push Batman.LessThanPropertyValidator
{% endhighlight %}
