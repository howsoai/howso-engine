# Howso Engine&trade;

The Howso Engine is an application that enables data exploration and machine learning capabilities through
the creation and use of Trainees that help users store, explore, and analyze the relationships in their data.
The Howso Engine utilizes a instance-based learning approach with strong ties to the [k-nearest neighbors algorithm](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) and [information theory](https://en.wikipedia.org/wiki/Information_theory).

Trainees are designed to be quite versatile, being a single model that after training a dataset can do all of the following without the need to retrain:
- Perform **classification** on any target feature using any set of input features
- Perform **regression** on any target feature using any set of input features
- Perform **anomaly detection** based on any set of features
- Measure **feature importance** for predicting any target feature
- **Synthesize** data that maintains the same feature relationships of the original data while maintaining privacy

Furthermore, Trainees are auditable, debuggable, and editable.
- **Debuggable**: Every prediction of a Trainee can be drilled down to investigate which cases from the training data were used to make the prediction.
- **Auditable**: Trainees manage metadata about themselves including: when data is trained, when training data is edited, when data is removed, etc.
- **Editable**: Specific cases of training data can be removed, edited, and emphasized (through case weighting) without the need to retrain.

# General Overview

The Engine allows users to manage and use Trainees. Trainees are the abstraction that are used
to manage training data, make predictions, and investigate the properties of the data they contain. As
is the case with all machine learning applications, Trainees must be trained with training data. Once
they are trained, Trainees possess a large array of functionality that can help users understand and
utilize their data. Trainees can be used to generate data, make predictions, evaluate predictability,
find anomalies, measure feature importance, and much more.

The code comprising the Engine is split up into two sections, one being the outward facing API
containing endpoints that allow users to interact with and use the engine for machine learning
tasks. The other section is that of the Trainee and all Trainee functionality defined in individual
modules. The API endpoints of the Engine are how users manage Trainees and access Trainee functionality.

The Howso Engine is written in [Amalgam](https://github.com/howsoai/amalgam), which is a domain specific language designed with
genetic programming and machine learning in mind. Due to this origin, it is naturally oriented for much of the
functionality that the Howso Engine provides. A key principle of Amalgam is the use of **entities**. When
the Engine is used, the external API must be instantiated from the definition:  `howso.amlg`. Similarly,
when a Trainee is created, an entity inside the `howso` entity is created to represent the Trainee from the definition:
`trainee_template.amlg`. To learn more about the use of entities and their implications, please see the
[Amalgam](https://github.com/howsoai/amalgam) project.

There exist a collection of Python packages that make the Howso Engine accessible and usable within Python
projects. The the necessary packages to use the Howso Engine within Python are [amalgam-lang-py](https://github.com/howsoai/amalgam-lang-py),
[howso-engine-py](https://github.com/howsoai/howso-engine-py). amalgam-lang is a package that exposes Amalgam entities to Python and
howso-engine-api is a package that specifically provides functions that expose Howso Engine functionality
through a Python interface which allow for seamless use of Trainees. Please see these packages if you
are interested in adding functionality to the Howso Engine that extends up through the Python interface.

## Concepts and Vocabulary

- ***Trainee***: A Trainee is the entity which users train with training data, then use for machine learning tasks
and data insights. This replaces the traditional use of the word **model** in most machine learning spaces. We
intentionally separate the verbiage to distinguish the functional differences between Trainees and more typical
machine learning models.
- ***Context Features***: Context features are the set of features used to make a prediction or any other operation.
In other machine learning spaces, these may be referred to as **independent features** or **input features**.
- ***Action Features***: Action features are the set of features being predicted. In other machine learning spaces,
these may be referred to as **dependent features** or **target features**.
- ***React***: React is the primary method of the Trainee to evaluate or predict feature values of a case. React is
a very powerful method with a plethora of available functionality, please see `#React` to get a full sense of the
capabilities of the operation.
- ***Analyze***: Analyze is a key method of the Trainee that uses a series of experiments to
determine the optimal set of hyperparameters for the dataset. This can be computed for Targetless or
Targeted flows which will typically yield different hyperparameters. The hyperparameters of each
Analyze call are cached within the Trainee and used in any following queries that fit the conditions
of the Analyze.
- ***Distance Contribution***: Distance Contribution is the amount of distance that a specific case contributes to
the model. It is defined as the harmonic mean of the distance to each of its nearest neighbors.
- ***Surprisal***: [Surprisal](https://en.wikipedia.org/wiki/Information_content) is a measure of how surprising
an observation is. It is primarily another way to express probability, but it is often used in the Howso Engine to
evaluate the conformity of a case to the rest of the data.
- ***Conviction***: Conviction is a novel normalized metric to evaluate the surprisal of a case. Conviction is
defined as the ratio of expected surprisal to observed surprisal. The Engine supports the use of different types of
convictions that can leverage surprisals of prediction residuals, feature values, distance contributions, etc.
- ***Targetless Learning***: Targetless is the word used in the Howso Engine to describe workflows where no specific action feature is being targeted for predictions. In these workflows, the Engine uses Inverse Residual Weighting (IRW) to determine feature weights.
- ***Targeted Learning***: Targeted is the general term used in the Howso Engine to describe workflows where a single action feature or set of action features it targeted for predictions. In these workflows, the Engine determines feature weights by analyzing the data to determine which features are most important for predicting the action features accurately.

## Usage

In most cases, usage of the Howso Engine takes places through the endpoints specified within `howso.amlg`.
Endpoints should be accessed along with a JSON blob of the appropriate parameters for the desired behavior. In
most cases, this JSON blob will include things like the name of the Trainee and the desired features of the
data.

Endpoints return JSON blobs containing the keys: `payload`, `warnings`, and `errors`.
`warnings` and `errors` hold lists of strings describing any warnings or errors that came up during the
execution of the requested endpoint. Meanwhile, `payload` contains the requested data desired from the user.

## User Guides

The Howso Engine is designed to support users in the pursuit of many different machine learning tasks.

Below is a very high-level set of steps recommended for using the Howso Engine:

1. Define the feature attributes of the data (Feature types, bounds, etc.)
2. Create a Trainee and set the feature attributes
3. Train the Trainee with the data
4. Call Analyze on the Trainee to find optimal hyperparameters
5. Explore your data!

Once the Trainee has been given feature attributes, trained, and analyzed, then the Trainee is ready
to be used for all supported machine learning tasks. At this point one could start making predictions
on unseen data, investigate the most noisy features, find the most anomalous training cases, and much more.

For more advanced user guides that advise about:
- Anomaly detection
- Classification
- Regression
- Time-series forecasting
- Feature importance analysis
- Reinforcement learning
- Data synthesis
- Prediction auditing
- Measuring model performance (global or conditional)
- Bias mitigation
- Trainee editing
- ID-based privacy

Please see the [extended documentation](https://docs.howso.com).

## Examples

The best place to find examples of how to use the Howso Engine in
Amalgam are here in the unit tests! Inspecting the unit tests should
give a thorough picture of how to do things like create a Trainee,
set feature attributes, train data, make predictions, and more.

To find examples of how to utilize the Howso Engine from Python,
see the [Howso Engine Recipes](https://github.com/howsoai/howso-engine-recipes), which
are a collection of [Jupyter notebooks](https://jupyter.org/) that
give tutorials on how to use the Howso Engine for various tasks.

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

## Style Guide

The styling of code written in the Howso Engine inherits the styling of the Amalgam language with additions
that help reading the code of the Engine a bit easier. These additions are mostly the use of different
naming conventions for labels of different types of code.

### Trainee Methods

Trainee methods that are called from endpoints are defined in modules
within the `trainee_template` directory using labels written in Pascal Case.

For example: `#ReactIntoTrainee`

### Endpoints

Endpoints are defined in `howso.amlg` using labels written in Snake Case.

For example: `#react_into_trainee`

### Trainee Attributes

Trainees have several cached values that hold important information called attributes. These often hold information
that save the Engine from having to recompute common values. These variables are defined in `trainee_template.amlg`
and are referenced using labels written in Camel Case.

For example: `#featureAttributes`

# FAQ

I got an empty response from an endpoint, what happened?

- The Engine likely made a computation that contained a NaN, which are not allowed to be emitted
in JSON format. The best course is to find a set of reproduction steps and debug up to just before the response is
emitted, there you will be able to verify the presence of a NaN and work backwards towards its source.

The engine crashed with a segmentation fault, did I do something wrong?

- The Howso Engine is written in Amalgam which is designed to never have segmentation faults. This indicates that
there is an issue within Amalgam. See the Amalgam documentation in order to learn how to debug your issue.

## License

[License](LICENSE.txt)

## Contributing

[Contributing](CONTRIBUTING.md)