# Engine Typing Guide (WiP)

To document parameters, we will do "type-hinting" with comments on each parameter in the form of an assoc that specifies things like
the parameter's type (or possible types), the types of its values, the types of it's keys and so on.

Return types of methods should be specified by comments on the assoc with the parameters.

- All parameters must have at least "type" specified
- Optionality will be automatically inferred by the default value. Nullable/Optional are the same here.
- There is no "boolean" type in Amalgam at this point, so flags must list both "true" and "false" as possible types.


## Typing (assoc) keys and their values

| Key    | Values |
| ------ | ------ |
| type | If single type, the type as a string. If multiple types, a list of types as strings. The available types are "list", "assoc", "number", "string", "true", "false", "any".
| values | Only used when `type` is "list" or "assoc". Values should be similar to the values of `type` and should define the possible types of the values. This value can be an assoc if the type is a data structure/
| min_size | Only applicable when `type` is "list" or "assoc". Value should be an integer.
| max_size | Only applicable when `type` is "list" or "assoc". Value should be an integer.
| enum | Only applicable when `type` is "string". A list of possible values for the string
| min | Only applicable when `type` is "number". The minimum value.
| max | Only applicable when `type` is "number". The maximum value.
| indices | Only applicable when `type` is "assoc". Value is an assoc of named indices to their expected types.
| additional_indices | Only applicable when `type` is "assoc". Value should be  similar to `type` values but is specified for indices that were not named in `indices`. (Does this just overlap with `values`)


## Examples

Train
```
#train
(declare
    (assoc
        ;(assoc type "list" values (assoc type "list" values "any"))
        input_cases (list)
        ;(assoc type "list" values "string")
        features (list)
        ;(assoc type "list" values "string")
        derived_features (null)
        ;(assoc type "string")
        session (null)
        ;(assoc type "string")
        series (null)
        ;(assoc type (list "true" "false"))
        input_is_substituted (false)
        ;(assoc type (list "true" "false"))
        allow_training_reserved_features (false)
        ;(assoc type "string")
        accumulate_weight_feature (null)
        ;(assoc type (list "true" "false"))
        train_weights_only (false)
        ;(assoc type (list "true" "false"))
        skip_auto_analyze (false)
    )
    ...
)
```

Analyze
```
#analyze
(declare
    (assoc
        ;(assoc type "list" values "string")
        context_features (list)
        ;(assoc type "list" values "string")
        action_features (list)
        ;(assoc type "number")
        k_folds 1
        ;(assoc type (list "true" "false"))
        bypass_hyperparameter_analysis (null)
        ;(assoc type (list "true" "false"))
        bypass_calculate_feature_residuals (null)
        ;(assoc type (list "true" "false"))
        bypass_calculate_feature_weights (null)
        ;(assoc type (list "true" "false"))
        use_deviations (null)
        ;(assoc type "number")
        num_samples (null)
        ;(assoc type "number")
        num_analysis_samples (null)
        ;(assoc type "number")
        analysis_sub_model_size (null)
        ;(assoc type "list" values "number")
        k_values (null)
        ;(assoc type "list" values "number")
        p_values (null)
        ;(assoc type "list" values "number")
        dt_values (null)
        ;(assoc type "string" enum (list "single_targeted" "omni_targeted" "targetless"))
        targeted_model "single_targeted"
        ;(assoc type "string")
        weight_feature ".case_weight"
        ;(assoc type (list "true" "false"))
        use_case_weights (null)
        ;(assoc type (list "true" "false"))
        inverse_residuals_as_weights (null)
    )
    ...
)
```