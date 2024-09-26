# Contributing

This Howso&trade; open source project only accepts code contributions from individuals and organizations that have signed a contributor license agreement. For more information on contributing and for links to the individual and corporate CLAs, please visit: https://www.howso.com/cla

# Code Layout

## API and Endpoints

`howso.amlg` holds the endpoints of the engine that can be used to do things like create Trainees, train
Trainees, and investigate the datasets held by the Trainee. Endpoints are defined by Snake Case labels within
`howso.amlg` with comment-descriptions of the endpoint's behavior, accepted parameters, and expected
return information.

## Trainees and Modules

All Trainee methods and attributes are defined in either `trainee_template.amlg` or in one of the Amalgam
files defined within the `trainee_template` directory. Attributes refer to the variables that hold cached values
and other information that are relevant for reuse to the Trainee. Methods refer to the callable sections of code
that execute machine learning or auxiliary tasks.

# Development

## Debugging

Debugging the Howso Engine is supported through the debugging tools provided for the
[Amalgam language](https://github.com/howsoai/amalgam). Specifically, the [Amalgam extension
for VSCode](https://github.com/howsoai/amalgam-ide-support-vscode) is recommended for debugging the
Howso Engine. This extension supports debugging Amalgam scripts as well as trace files produced
by [amalgam-lang-py](https://github.com/howsoai/amalgam-lang-py). Please see these projects to
get further information about debugging Amalgam.

## Testing

The Howso Engine has a suite of unit tests and performance tests. To run the full set of unit tests, simply
call the desired Amalgam executable on `ut_comprehensive_unit_test.amlg` from within the `unit_tests` directory.
Unit tests can be called with the additional "validate" command line argument which triggers Amalgam's memory
validation at the end of the test.

Unit tests are held in the `unit_tests` directory while performance tests are held in the `performance_tests`
directory.

To create your own tests, we recommend creating a new Amalgam script in the `unit_tests` directory. It is
also recommended to use the following code at the beginning of the test:

```
#unit_test (direct_assign_to_entities (assoc unit_test (load "unit_test.amlg")))
(call (load "unit_test_howso.amlg") (assoc name "ut_your_custom_test_name.amlg"))
```

This code imports the unit testing framework defined within `unit_tests/unit_test_amlg` and calls the code
within `unit_tests/unit_test_howso.amlg` which instantiates the `howso` entity, which can be used to call
the API endpoints defined in `howso.amlg`. This unit testing framework includes methods such as `#assert_same`,
`#assert_approximate`, and more. Please see `unit_tests/unit_test.amlg` to see the full list of methods to
help with unit testing. It is also recommended to add periodic calls to `#exit_if_failures` in longer test
files so that tests can fail out early. The `#assert_*` methods will **not** halt the execution of a test alone.

If you wish to add a test to the comprehensive test set, you can add it to the appropriate test file that is
called from `ut_comprehensive_unit_test.amlg`. If you want to test an endpoint, it makes the most sense to
add your test to `ut_howso.amlg`. If you want to test a Trainee method, then it makes more sense to add
your test to `ut_trainee_template.amlg`. Please read these files to see how to add your test file to the set.


## Typing Guide (WiP)

To document parameters, we do "type-hinting" with comments on each parameter in the form of an assoc that specifies things like
the parameter's type (or possible types), the types of its values, the types of its keys and so on.

Return types of methods should be specified by comments on the assoc with the parameters. (This is currently in planning)

- All parameters must have at least "type" or "ref" specified
- Optionality will be automatically inferred by the default value. Nullable/Optional are the same here.


### Typing (assoc) keys and their values

| Key                 | Values |
| ------------------- | ------ |
| type                | If single type, the type as a string. If multiple types, a list of types as strings. The available types are "list", "assoc", "number", "string", "boolean", "any".
| values              | Only used when `type` is "list". Values should be similar to the values of `type` and should define the possible types of the values. This value can be an assoc if the type is a data structure.
| min_size            | Only applicable when `type` is "list" or "assoc". Value should be an integer.
| max_size            | Only applicable when `type` is "list" or "assoc". Value should be an integer.
| enum                | Only applicable when `type` is "string". A list of possible values for the string
| min                 | Only applicable when `type` is "number". The minimum value.
| max                 | Only applicable when `type` is "number". The maximum value.
| indices             | Only applicable when `type` is "assoc". Value is an assoc of named indices to their expected types.
| additional_indices  | Only applicable when `type` is "assoc". Value should be  similar to `type` values but is defined for all unspecified indices.
| optional            | The value of this should be a boolean, and this should only be specified for sub-types. This will be automatically added to the top level of type hints based on the default value of the parameter.
| required            | The value of this should be a boolean. If used under the type within an 'indices' (assoc), then that index must be present in the parent (assoc). If used in a top-level type, that parameter must be specified as a non-null value.


### Typing Examples

```
#foo_bar_method
(declare
    (assoc
        ;{type "list" values "string"}
        ;a list of strings
        list_of_strs (list)
        ;{type "number" min 1}
        ;a value in the range (0,inf)
        some_positive_number (null)
        ;{type "boolean"}
        ;some true/false value
        some_boolean (null)
        ;{type "assoc" values "number"}
        ;a map of numbers
        map_of_number_values (assoc)
    )
    ...
)
```

Explicit mention of a parameter's type should not be repeated in the description. Additionally, explicit mention of
`optional` in a parameter's description should not be included. Optional parameters are identified by having a default
value of (null). In the above example `list_of_strs` and `map_of_number_values` would be interpreted as required while
 `some_positive_number` and `some_boolean` would be interpreted as optional because a default value is (null).

## Style Guide

The styling of code written in the Howso Engine inherits the styling of the Amalgam language with additions
that help reading the code easier. These additions are mostly the use of different naming conventions for
labels of different types of code. See the [Amalgam](https://github.com/howsoai/amalgam) project for more
information on how to style Amalgam code.

### Trainee Methods

Trainee methods that are called from endpoints are defined in modules
within the `trainee_template` directory using labels written in Pascal Case.

For example: `#ReactIntoTrainee`

### Endpoints

Endpoints are defined in `howso.amlg` using labels written in Snake Case.

For example: `#react_aggregate`

### Trainee Attributes

Trainees have several cached values that hold important information called attributes. These often hold information
that save the Engine from having to recompute common values. These variables are defined in `trainee_template.amlg`
and are referenced using labels written in Camel Case.

For example: `#featureAttributes`

# FAQ

I got an empty response from an endpoint, what happened?

- The Engine likely made a computation that contained one or more NaN, which are not allowed to be emitted
in JSON format. The best course is to find a set of reproduction steps and debug up to just before the response is
emitted; there, you will be able to verify the presence of a NaN and work backwards towards its source.

The engine crashed with a segmentation fault, did I do something wrong?

- The Howso Engine is written in Amalgam which is designed to never have segmentation faults. This indicates that
there is an issue within Amalgam. See the [Amalgam documentation](https://github.com/howsoai/amalgam) in order to learn how to debug your issue.