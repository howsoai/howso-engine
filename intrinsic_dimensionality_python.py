import pmlb
import pprint
from howso.engine import Trainee
from howso.utilities import infer_feature_attributes

df = pmlb.fetch_data("adult")
print(len(df))

features = infer_feature_attributes(df)

num_features = len(features.get_names(types="continuous"))
nom_features = features.get_names(types="nominal")

for feature in nom_features:
    num_features += df[feature].nunique()

t = Trainee(features=features)
t.train(df)
t.analyze()

print(t.react_aggregate(
    details={"intrinsic_dimensionality": True}
))

# print("Actual num features               : ", len(features))
# print("Adjusted num features             : ", num_features)

# estimate_id_response = t.client.execute(
#     t.id,
#     "estimate_intrinsic_dimensionality",
#     {
#         "num_samples": 50,
#         # "features": list(df.columns),
#         # "weight_feature": None,
#     }
# )
# print("Estimated intrinsic dimensionality: ", round(estimate_id_response["d"], 3))

# estimate_local_fill_response = t.client.execute(
#     t.id,
#     "estimate_local_fill",
#     {
#         "num_samples": 50,
#         "d": estimate_id_response["d"]
#     }
# )
# print(
#     "Should use generate_new_cases       : ",
#     estimate_local_fill_response["new_case_generation_recommended"]
# )
# print(
#     "  Avg. new-case volume              : ",
#     estimate_local_fill_response["avg_new_case_volume"]
# )
# print(
#     "  Avg. k volume                     : ",
#     estimate_local_fill_response["avg_k_volume"]
# )
