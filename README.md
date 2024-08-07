
<div align="left">
<picture>
 <source media="(prefers-color-scheme: dark)" srcset="https://cdn.howso.com/img/howso/1/svg/logo-gradient-light.svg" width="33%">
 <source media="(prefers-color-scheme: light)" srcset="https://cdn.howso.com/img/howso/1/svg/logo-gradient-dark.svg" width="33%">
 <img alt="Howso" src="https://cdn.howso.com/img/howso/1/png/logo-gradient-light-bg.png" width="33%">
</picture>
</div>

The Howso Engine&trade; is a natively and fully explainable ML engine, serving as an alternative to black box AI neural networks. Its core functionality gives users data exploration and machine learning capabilities through the creation and use of Trainees that help users store, explore, and analyze the relationships in their data, as well as make understandable, debuggable predictions. Howso leverages an instance-based learning approach with strong ties to the [k-nearest neighbors algorithm](https://en.wikipedia.org/wiki/K-nearest_neighbors_algorithm) and [information theory](https://en.wikipedia.org/wiki/Information_theory) to scale for real world applications.

At the core of Howso is the concept of a Trainee, a collection of data elements that comprise knowledge. In traditional ML, this is typically referred to as a model, but a Trainee is original training data coupled with metadata, parameters, details of feature attributes, with data lineage and provenance. Unlike traditional ML, Trainees are designed to be versatile so that after a single training instance (no re-training required!), they can:

- Perform **classification** on any target feature using any set of input features
- Perform **regression** on any target feature using any set of input features
- Perform **online and reinforcement learning**
- Perform **anomaly detection** based on any set of features
- Measure **feature importance** for predicting any target feature
- Identify **counterfactuals**
- Understand **increases and decreases in accuracy** for features and individual cases
- **Forecast** time series
- **Synthesize** data that maintains the same feature relationships of the original data while maintaining privacy
- **And more!**

Furthermore, Trainees are auditable, debuggable, and editable.
- **Debuggable**: Every prediction of a Trainee can be drilled down to investigate which cases from the training data were used to make the prediction.
- **Auditable**: Trainees manage metadata about themselves including: when data is trained, when training data is edited, when data is removed, etc.
- **Editable**: Specific cases of training data can be removed, edited, and emphasized (through case weighting) without the need to retrain.

## Resources
- [Documentation](https://docs.howso.com)
- [Howso Engine Recipes (sample notebooks)](https://github.com/howsoai/howso-engine-recipes)
- [Howso Playground](https://playground.howso.com)

## General Overview
This repository holds the Howso Engine, a project written in [Amalgam](https://github.com/howsoai/amalgam) that defines all of the functionality of Trainees and their management. This project is used by [howso-engine-py](https://github.com/howsoai/howso-engine-py) to expose the functionality of the Howso Engine through a Python API, and is the recommended interface for most data science applications.

To use the Howso Engine without the Python client, it is recommended that you first introduce yourself to the [Amalgam](https://github.com/howsoai/amalgam)
language. This way you can learn how to write scripts that will allow you to use the Howso Engine.

## Supported Platforms
Since the Howso Engine is written in [Amalgam](https://github.com/howsoai/amalgam), it inherits the same supported platforms. Please see Amalgam's supported platforms.

## Install
To install and use the Howso Engine, clone this repository locally and use an Amalgam executable to run Amalgam scripts that load and use the Howso Engine.

## Usage
Basic usage of the Howso Engine in an Amalgam script looks like:

``` amalgam
(seq
    (load_entity "./howso.amlg" "howso")
    (assign_to_entities "howso" (assoc filepath "./"))
    (set_entity_root_permission "howso" 1)

    (call_entity "howso" "create_trainee" (assoc trainee "iris_trainee"))

    (call_entity "howso" "set_feature_attributes" (assoc
        trainee "iris_trainee"
        features (assoc "species" (assoc "type" "nominal"))
    ))

    (call_entity "howso" "train" (assoc
        trainee "iris_trainee"
        features (list "sepal_length" "sepal_width" "petal_length" "petal_width" "species")
        input_cases
            (list
                (list 6.4 2.8 5.6 2.2 "virginica")
                (list 5.0 2.3 3.3 1.0 "versicolor")
                (list 4.9 3.1 1.5 0.1 "setosa")
                (list 5.9 3.0 4.2 1.5 "versicolor")
                (list 6.9 3.1 5.4 2.1 "virginica")
                (list 5.1 3.3 1.7 0.5 "setosa")
                ;... as many cases as appropriate
            )
        session "iris_session"
    ))

    (call_entity "howso" "analyze" (assoc trainee "iris_trainee"))

    (declare (assoc
        reaction
            (call_entity "howso" "react" (assoc
                trainee "iris_trainee"
                context_features (list "sepal_length" "sepal_width" "petal_length" "petal_width")
                context_values (list 5.3 2.5 4.1 1.3)
                action_features (list "species")
            ))
    ))

    (print reaction)
)
```

## Related Repos
- [Amalgam](https://github.com/howsoai/amalgam)
- [Amalgam extension for VSCode](https://github.com/howsoai/amalgam-ide-support-vscode)
- [amalgam-lang-py](https://github.com/howsoai/amalgam-lang-py)
- [howso-engine-py](https://github.com/howsoai/howso-engine-py)
- [Howso Engine Recipes (sample jupyter notebooks)](https://github.com/howsoai/howso-engine-recipes)


## Contributing
To learn about contributing, view `CONTRIBUTING.md`

## License

[License](LICENSE.txt)

## TODO REMOVE - 20653 - Regex to find functions: ;parameters:(\n\s+;.*)+\n\s+#[a-z_]+